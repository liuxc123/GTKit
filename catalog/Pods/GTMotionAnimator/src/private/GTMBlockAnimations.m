//
//  GTMBlockAnimations.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMBlockAnimations.h"

#import "GTMMotionAnimator.h"
#import "GTMAnimatableKeyPaths.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// Returns the set of animatable key paths supported by GTMMotionAnimator's implicit animations.
static NSSet<GTMAnimatableKeyPath> *AllAnimatableKeyPaths(void) {
    static NSSet *animatableKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animatableKeyPaths = [NSSet setWithArray:@[GTMKeyPathAnchorPoint,
                                                   GTMKeyPathBackgroundColor,
                                                   GTMKeyPathBorderWidth,
                                                   GTMKeyPathBorderColor,
                                                   GTMKeyPathBounds,
                                                   GTMKeyPathCornerRadius,
                                                   GTMKeyPathHeight,
                                                   GTMKeyPathOpacity,
                                                   GTMKeyPathPosition,
                                                   GTMKeyPathRotation,
                                                   GTMKeyPathScale,
                                                   GTMKeyPathShadowColor,
                                                   GTMKeyPathShadowOffset,
                                                   GTMKeyPathShadowOpacity,
                                                   GTMKeyPathShadowRadius,
                                                   GTMKeyPathStrokeStart,
                                                   GTMKeyPathStrokeEnd,
                                                   GTMKeyPathTransform,
                                                   GTMKeyPathWidth,
                                                   GTMKeyPathX,
                                                   GTMKeyPathY,
                                                   GTMKeyPathZ]];
    });
    return animatableKeyPaths;
}

@interface GTMActionContext: NSObject
@property(nonatomic, readonly) NSArray<GTMImplicitAction *> *interceptedActions;
@end

// The original CALayer method implementation of -actionForKey:
static IMP sOriginalActionForKeyLayerImp = NULL;

static NSMutableArray<GTMActionContext *> *sActionContext = nil;

@implementation GTMImplicitAction

- (instancetype)initWithLayer:(CALayer *)layer
                      keyPath:(NSString *)keyPath {
    self = [super init];
    if (self) {
        _layer = layer;
        _keyPath = [keyPath copy];
        _initialModelValue = [_layer valueForKeyPath:_keyPath];
        _hadPresentationLayer = [_layer presentationLayer] != nil;
        _initialPresentationValue = [[_layer presentationLayer] valueForKeyPath:_keyPath];
    }
    return self;
}

@end

@implementation GTMActionContext {
    NSMutableArray<GTMImplicitAction *> *_interceptedActions;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _interceptedActions = [NSMutableArray array];
    }
    return self;
}

- (void)addActionForLayer:(CALayer *)layer keyPath:(NSString *)keyPath {
    [_interceptedActions addObject:[[GTMImplicitAction alloc] initWithLayer:layer keyPath:keyPath]];
}

- (NSArray<GTMImplicitAction *> *)interceptedActions {
    return [_interceptedActions copy];
}

@end

@interface GTMLayerDelegate: NSObject <CALayerDelegate>
@end

static id<CAAction> ActionForKey(CALayer *layer, SEL _cmd, NSString *event) {
    NSCAssert([NSStringFromSelector(_cmd) isEqualToString:
               NSStringFromSelector(@selector(actionForKey:))],
              @"Invalid method signature.");

    GTMActionContext *context = [sActionContext lastObject];
    NSCAssert(context != nil, @"MotionAnimator action method invoked out of implicit scope.");

    BOOL shouldAnimateWithAnimator = [AllAnimatableKeyPaths() containsObject:event];
    if (context == nil || !shouldAnimateWithAnimator) {
        // Fall through to the original CALayer implementation.
        return ((id<CAAction>(*)(id, SEL, NSString *))sOriginalActionForKeyLayerImp)
        (layer, _cmd, event);
    }

    // We don't have access to the "to" value of our animation here, so we unfortunately can't
    // calculate additive values if the animator is configured as such. So, to support additive
    // animations, we queue up the modified actions and then add them all at the end of our
    // GTMAnimateImplicitly invocation.
    [context addActionForLayer:layer keyPath:event];
    return nil;
}

NSArray<GTMImplicitAction *> *GTMAnimateImplicitly(void (^work)(void)) {
    if (!work) {
        return nil;
    }

    SEL actionForKeySelector = @selector(actionForKey:);
    Method actionForKeyMethod = class_getInstanceMethod([CALayer class], actionForKeySelector);

    // This method can be called recursively, so we maintain a context stack in the scope of this
    // method. Note that this is absolutely not thread safe, but neither is Core Animation.
    if (!sActionContext) {
        sActionContext = [NSMutableArray array];

        // Swap the original CALayer implementation with our own so that we can intercept all
        // actionForKey: events.
        sOriginalActionForKeyLayerImp = method_setImplementation(actionForKeyMethod,
                                                                 (IMP)ActionForKey);
    }

    [sActionContext addObject:[[GTMActionContext alloc] init]];

    work();

    // Return any intercepted actions we received during the invocation of work.
    GTMActionContext *context = [sActionContext lastObject];
    [sActionContext removeLastObject];

    if ([sActionContext count] == 0) {
        // Restore our original method if we've emptied the stack.
        method_setImplementation(actionForKeyMethod, sOriginalActionForKeyLayerImp);
        sOriginalActionForKeyLayerImp = nil;

        sActionContext = nil;
    }

    return context.interceptedActions;
}

@implementation GTMLayerDelegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    // Check whether we're inside of an GTMAnimateImplicitly block or not.
    if (sOriginalActionForKeyLayerImp == nil) {
        return nil; // Tell Core Animation to Keep searching for an action provider.
    }
    return ActionForKey(layer, _cmd, event);
}

@end

@implementation GTMMotionAnimator (ImplicitLayerAnimations)

+ (id<CALayerDelegate>)sharedLayerDelegate {
    static GTMLayerDelegate *sharedInstance;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[GTMLayerDelegate alloc] init];
        }
    }
    return sharedInstance;
}

@end

