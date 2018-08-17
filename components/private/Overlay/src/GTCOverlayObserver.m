//
//  GTCOverlayObserver.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCOverlayObserver.h"

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "GTCOverlayImplementor.h"
#import "private/GTCOverlayAnimationObserver.h"
#import "private/GTCOverlayObserverOverlay.h"
#import "private/GTCOverlayObserverTransition.h"

// If this is ever required elsewhere in the code, just disable unused parameter warnings entirely
// with -Wno-unused-params.
#ifdef NS_BLOCK_ASSERTIONS
#define GTC_UNUSED_IN_RELEASE __unused
#else
#define GTC_UNUSED_IN_RELEASE
#endif

@interface GTCOverlayObserver () <GTCOverlayAnimationObserverDelegate>

/** The list of overlays currently known to this observer. */
@property(nonatomic) NSMutableDictionary *overlays;

/** The currently-pending transition. */
@property(nonatomic) GTCOverlayObserverTransition *pendingTransition;

/** The table holding the target-action mapping. */
@property(nonatomic) NSMapTable *actionTable;

/** The animation observer used to coalesce events. */
@property(nonatomic, strong) GTCOverlayAnimationObserver *observer;

@end

@implementation GTCOverlayObserver

static GTCOverlayObserver *_sOverlayObserver;

// This class must be available before the keyboard (or any other overlay contributor) has a chance
// to report overlay changes. The +load method is the only safe place early enough.
+ (void)load {
    @autoreleasepool {
        _sOverlayObserver = [[GTCOverlayObserver alloc] init];
    }
}

+ (instancetype)observerForScreen:(GTC_UNUSED_IN_RELEASE UIScreen *)screen {
    NSParameterAssert(screen == nil || screen == [UIScreen mainScreen]);
    return _sOverlayObserver;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _overlays = [NSMutableDictionary dictionary];
        _observer = [[GTCOverlayAnimationObserver alloc] init];
        _observer.delegate = self;

        // Set up the target/action table. The keys will be weak pointers to objects, with no calls to
        // hashing done only on the pointer address (as opposed to calling -hash/-isEqual:).
        // The values will be strong references to objects.
        NSPointerFunctionsOptions keyOptions =
        (NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPointerPersonality);
        NSPointerFunctionsOptions valueOptions =
        (NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality);
        _actionTable = [NSMapTable mapTableWithKeyOptions:keyOptions valueOptions:valueOptions];

        // Register to hear when an overlay changes.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleOverlayChangeNotification:)
                                                     name:GTCOverlayDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Overlays

- (GTCOverlayObserverOverlay *)overlayWithIdentifier:(NSString *)identifier {
    return self.overlays[identifier];
}

- (GTCOverlayObserverOverlay *)buildOverlayWithIdentifier:(NSString *)identifier {
    GTCOverlayObserverOverlay *overlay = self.overlays[identifier];
    if (overlay == nil) {
        overlay = [[GTCOverlayObserverOverlay alloc] init];
        overlay.identifier = identifier;
        self.overlays[identifier] = overlay;
    }

    return overlay;
}

- (void)removeOverlayWithIdentifier:(NSString *)identifier {
    [self.overlays removeObjectForKey:identifier];
}

- (NSArray *)sortedOverlays {
    NSArray *sortedKeys = [[self.overlays allKeys] sortedArrayUsingSelector:@selector(compare:)];

    NSMutableArray *result = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        [result addObject:self.overlays[key]];
    }

    return result;
}

#pragma mark - Input Sources

- (BOOL)updateOverlay:(NSString *)identifier withFrame:(CGRect)frame {
    BOOL changed = NO;

    GTCOverlayObserverOverlay *existingOverlay = [self overlayWithIdentifier:identifier];

    if (existingOverlay != nil) {
        if (CGRectIsEmpty(frame)) {
            // We're getting rid of this overlay entirely.
            [self removeOverlayWithIdentifier:identifier];
            changed = YES;
        } else if (!CGRectEqualToRect(existingOverlay.frame, frame)) {
            // We're changing to a new frame for this overlay.
            existingOverlay.frame = frame;
            changed = YES;
        }
    } else if (!CGRectIsEmpty(frame)) {
        GTCOverlayObserverOverlay *overlay = [self buildOverlayWithIdentifier:identifier];
        overlay.frame = frame;
        changed = YES;
    }

    return changed;
}

- (void)handleOverlayChangeNotification:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSString *identifier = userInfo[GTCOverlayIdentifierKey];

    // Don't even bother if an identifier wasn't provided.
    if (identifier.length == 0) {
        return;
    }

    NSValue *frame = userInfo[GTCOverlayFrameKey] ?
    userInfo[GTCOverlayFrameKey] : [NSValue valueWithCGRect:CGRectNull];
    NSNumber *duration = userInfo[GTCOverlayTransitionDurationKey];

    // Update the overlay frame.
    BOOL updated = [self updateOverlay:identifier withFrame:[frame CGRectValue]];

    // If there was actually a change, set up a transition.
    if (updated) {
        if (self.pendingTransition == nil) {
            self.pendingTransition = [[GTCOverlayObserverTransition alloc] init];
            [self.observer messageDelegateOnNextRunloop];
        }
    }

    // If we were given a duration, then update the animation parameters.
    if (self.pendingTransition != nil && duration != nil) {
        self.pendingTransition.duration = duration.doubleValue;
        self.pendingTransition.customTimingFunction = userInfo[GTCOverlayTransitionTimingFunctionKey];
        self.pendingTransition.animationCurve =
        ((NSNumber *)userInfo[GTCOverlayTransitionCurveKey]).integerValue;

        // If this update requires us to run the animation immediately, go ahead and fire it off.
        NSNumber *runImmediately = userInfo[GTCOverlayTransitionImmediacyKey];
        if (runImmediately.boolValue) {
            [self fireTransition];
        }
    }
}

#pragma mark - Target/Action

- (NSInvocation *)buildInvocationForTarget:(id)target action:(SEL)action {
    NSMethodSignature *signature = [target methodSignatureForSelector:action];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:action];

    return invocation;
}

- (void)invokeTarget:(NSInvocation *)invocation
      withTransition:(GTCOverlayObserverTransition *)transition {
    NSParameterAssert(invocation != nil);
    NSParameterAssert(transition != nil);

    [invocation setArgument:&transition atIndex:2];
    [invocation invoke];
}

- (NSUInteger)indexOfInvocationForTarget:(id)target action:(SEL)action {
    NSMutableArray *invocations = [self.actionTable objectForKey:target];

    if (invocations == nil) {
        return NSNotFound;
    }

    return [invocations indexOfObjectPassingTest:
            ^BOOL(NSInvocation *invocation, __unused NSUInteger idx, __unused BOOL *stop) {
                return invocation.selector == action;
            }];
}

- (void)addTarget:(id)target action:(SEL)action {
    NSParameterAssert(target != nil);

    NSUInteger foundIndex = [self indexOfInvocationForTarget:target action:action];
    if (foundIndex != NSNotFound) {
        return;
    }

    NSInvocation *invocation = [self buildInvocationForTarget:target action:action];
    NSParameterAssert(invocation != nil);

    NSMutableArray *invocations = [self.actionTable objectForKey:target];
    if (invocations == nil) {
        invocations = [NSMutableArray array];
        [self.actionTable setObject:invocations forKey:target];
    }

    [invocations addObject:invocation];

    if (self.overlays.count > 0) {
        // If there's already a pending transition, let the runloop take care of it, otherwise create
        // one and call it immediately on just the newly-added target, so that it can get its initial
        // value.
        if (self.pendingTransition == nil) {
            GTCOverlayObserverTransition *transition = [[GTCOverlayObserverTransition alloc] init];
            transition.overlays = [self sortedOverlays];

            [self invokeTarget:invocation withTransition:transition];

            // Run the (non-animated) transition.
            [transition runAnimation];
        }
    }
}

- (void)removeTarget:(id)target {
    NSParameterAssert(target != nil);

    [self.actionTable removeObjectForKey:target];
}

- (void)removeTarget:(id)target action:(SEL)action {
    NSParameterAssert(target != nil);

    NSUInteger foundIndex = [self indexOfInvocationForTarget:target action:action];

    if (foundIndex != NSNotFound) {
        NSMutableArray *invocations = [self.actionTable objectForKey:target];

        if (invocations.count == 1) {
            // Clean up all the invocations if this was the only one.
            [self removeTarget:target];
        } else {
            // Otherwise remove this single invocation.
            [invocations removeObjectAtIndex:foundIndex];
        }
    }
}

#pragma mark - Runloop Observer

- (void)fireTransition {
    if (self.pendingTransition == nil) {
        return;
    }

    // Update the transition with the latest set of overlays.
    self.pendingTransition.overlays = [self sortedOverlays];

    // Call all of our targets and let them know a transition has happened.
    for (id target in self.actionTable) {
        NSArray *invocations = [self.actionTable objectForKey:target];
        for (NSInvocation *invocation in invocations) {
            [self invokeTarget:invocation withTransition:self.pendingTransition];
        }
    }

    // Actually run the transition animation.
    [self.pendingTransition runAnimation];

    self.pendingTransition = nil;
}

- (void)animationObserverDidEndRunloop:(__unused GTCOverlayAnimationObserver *)observer {
    [self fireTransition];
}

@end
