//
//  GTMAnimationRegistrar.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMAnimationRegistrar.h"

#import "GTMRegisteredAnimation.h"

@implementation GTMAnimationRegistrar {
    NSMapTable<CALayer *, NSMutableSet<GTMRegisteredAnimation *> *> *_layersToRegisteredAnimation;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _layersToRegisteredAnimation = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
                                                             valueOptions:NSPointerFunctionsStrongMemory];
    }
    return self;
}

#pragma mark - Private

- (void)forEachAnimation:(void (^)(CALayer *, CABasicAnimation *, NSString *))work {
    // Copy the registered animations before iteration in case further modifications happen to the
    // registered animations. Consider if we remove an animation, its associated completion block
    // might invoke logic that adds a new animation, potentially modifying our collections.
    for (CALayer *layer in [_layersToRegisteredAnimation copy]) {
        NSSet *keyPathAnimations = [_layersToRegisteredAnimation objectForKey:layer];
        for (GTMRegisteredAnimation *keyPathAnimation in [keyPathAnimations copy]) {
            if (![keyPathAnimation.animation isKindOfClass:[CABasicAnimation class]]) {
                continue;
            }

            work(layer, [keyPathAnimation.animation copy], keyPathAnimation.key);
        }
    }
}

#pragma mark - Public

- (void)addAnimation:(CABasicAnimation *)animation
             toLayer:(CALayer *)layer
              forKey:(NSString *)key
          completion:(void(^)(BOOL))completion {
    if (key == nil) {
        key = [NSUUID UUID].UUIDString;
    }

    NSMutableSet *animatedKeyPaths = [_layersToRegisteredAnimation objectForKey:layer];
    if (!animatedKeyPaths) {
        animatedKeyPaths = [[NSMutableSet alloc] init];
        [_layersToRegisteredAnimation setObject:animatedKeyPaths forKey:layer];
    }
    GTMRegisteredAnimation *keyPathAnimation =
    [[GTMRegisteredAnimation alloc] initWithKey:key animation:animation];
    [animatedKeyPaths addObject:keyPathAnimation];

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [animatedKeyPaths removeObject:keyPathAnimation];

        if (completion) {
            completion(YES);
        }
    }];

    [layer addAnimation:animation forKey:key];

    [CATransaction commit];
}

- (void)commitCurrentAnimationValuesToAllLayers {
    [self forEachAnimation:^(CALayer *layer, CABasicAnimation *animation, NSString *key) {
        id presentationLayer = [layer presentationLayer];
        if (presentationLayer != nil) {
            id presentationValue = [presentationLayer valueForKeyPath:animation.keyPath];
            [layer setValue:presentationValue forKeyPath:animation.keyPath];
        }
    }];
}

- (void)removeAllAnimations {
    [self forEachAnimation:^(CALayer *layer, CABasicAnimation *animation, NSString *key) {
        [layer removeAnimationForKey:key];
    }];
    [_layersToRegisteredAnimation removeAllObjects];
}

@end

