//
//  GTMMotionAnimator.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMMotionAnimator.h"

#import <UIKit/UIKit.h>

#import "CATransaction+MotionAnimator.h"
#import "private/CABasicAnimation+MotionAnimator.h"
#import "private/GTMAnimationRegistrar.h"
#import "private/GTMUIKitValueCoercion.h"
#import "private/GTMBlockAnimations.h"
#import "private/GTMDragCoefficient.h"

@implementation GTMMotionAnimator {
    NSMutableArray *_tracers;
    GTMAnimationRegistrar *_registrar;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _registrar = [[GTMAnimationRegistrar alloc] init];
        _timeScaleFactor = 1;
        _additive = true;
    }
    return self;
}

- (void)animateWithTraits:(GTMAnimationTraits *)traits
                  between:(NSArray *)values
                    layer:(CALayer *)layer
                  keyPath:(GTMAnimatableKeyPath)keyPath {
    [self animateWithTraits:traits between:values layer:layer keyPath:keyPath completion:nil];
}

- (void)animateWithTraits:(GTMAnimationTraits *)traits
                  between:(NSArray *)values
                    layer:(CALayer *)layer
                  keyPath:(GTMAnimatableKeyPath)keyPath
               completion:(void(^)(BOOL))completion {
    NSAssert([values count] == 2, @"The values array must contain exactly two values.");

    if (_shouldReverseValues) {
        values = [[values reverseObjectEnumerator] allObjects];
    }
    values = GTMCoerceUIKitValuesToCoreAnimationValues(values);

    void (^commitToModelLayer)(void) = ^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer setValue:[values lastObject] forKeyPath:keyPath];
        [CATransaction commit];
    };

    void (^exitEarly)(void) = ^{
        commitToModelLayer();

        if (completion) {
            completion(YES);
        }
    };

    CGFloat timeScaleFactor = [self computedTimeScaleFactor];
    if (timeScaleFactor == 0) {
        exitEarly();
        return;
    }

    CABasicAnimation *animation = GTMAnimationFromTraits(traits, timeScaleFactor);

    if (animation == nil) {
        exitEarly();
        return;
    }

    BOOL beginFromCurrentState = self.beginFromCurrentState;

    [self addAnimation:animation
               toLayer:layer
           withKeyPath:keyPath
                traits:traits
       timeScaleFactor:timeScaleFactor
           destination:[values lastObject]
          initialValue:^(BOOL wantsPresentationValue) {
              if (beginFromCurrentState) {
                  if (wantsPresentationValue && [layer presentationLayer]) {
                      return [[layer presentationLayer] valueForKeyPath:keyPath];
                  } else {
                      return [layer valueForKeyPath:keyPath];
                  }
              } else {
                  return [values firstObject];
              }

          } completion:completion];

    commitToModelLayer();

    for (void (^tracer)(CALayer *, CAAnimation *) in _tracers) {
        tracer(layer, animation);
    }
}

- (void)animateWithTraits:(GTMAnimationTraits *)traits animations:(void (^)(void))animations {
    [self animateWithTraits:traits animations:animations completion:nil];
}

- (void)animateWithTraits:(GTMAnimationTraits *)traits
               animations:(void (^)(void))animations
               completion:(void(^)(BOOL))completion {
    NSArray<GTMImplicitAction *> *actions = GTMAnimateImplicitly(animations);

    void (^exitEarly)(void) = ^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        animations();
        [CATransaction commit];

        if (completion) {
            completion(YES);
        }
    };

    CGFloat timeScaleFactor = [self computedTimeScaleFactor];
    if (timeScaleFactor == 0) {
        exitEarly();
        return; // No need to animate anything.
    }

    // We'll reuse this animation template for each action.
    CABasicAnimation *animationTemplate = GTMAnimationFromTraits(traits, timeScaleFactor);
    if (animationTemplate == nil) {
        exitEarly();
        return;
    }

    [CATransaction begin];
    if (completion) {
        [CATransaction setCompletionBlock:^{
            completion(YES);
        }];
    }

    for (GTMImplicitAction *action in actions) {
        CABasicAnimation *animation = [animationTemplate copy];

        [self addAnimation:animation
                   toLayer:action.layer
               withKeyPath:action.keyPath
                    traits:traits
           timeScaleFactor:timeScaleFactor
               destination:[action.layer valueForKeyPath:action.keyPath]
              initialValue:^(BOOL wantsPresentationValue) {
                  if (wantsPresentationValue && action.hadPresentationLayer) {
                      return action.initialPresentationValue;
                  } else {
                      // Additive animations always animate from the initial model layer value.
                      return action.initialModelValue;
                  }
              } completion:nil];

        for (void (^tracer)(CALayer *, CAAnimation *) in _tracers) {
            tracer(action.layer, animation);
        }
    }

    [CATransaction commit];
}

- (void)addCoreAnimationTracer:(void (^)(CALayer *, CAAnimation *))tracer {
    if (!_tracers) {
        _tracers = [NSMutableArray array];
    }
    [_tracers addObject:[tracer copy]];
}

- (void)removeAllAnimations {
    [_registrar removeAllAnimations];
}

- (void)stopAllAnimations {
    [_registrar commitCurrentAnimationValuesToAllLayers];
    [_registrar removeAllAnimations];
}

#pragma mark - UIKit equivalency

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^ __nonnull)(void))animations {
    [self animateWithDuration:duration animations:animations completion:nil];
}

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL))completion {
    [self animateWithDuration:duration
                        delay:UIViewAnimationOptionCurveEaseInOut
                      options:0
                   animations:animations
                   completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
                    options:(UIViewAnimationOptions)options
                 animations:(void (^ __nonnull)(void))animations
                 completion:(void (^ __nullable)(BOOL finished))completion {
    GTMMotionAnimator *animator = [[[self class] alloc] init];
    GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithDuration:duration];
    traits.delay = delay;
    if ((options & UIViewAnimationOptionCurveEaseIn) == UIViewAnimationOptionCurveEaseIn) {
        traits.timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else if ((options & UIViewAnimationOptionCurveEaseOut) == UIViewAnimationOptionCurveEaseOut) {
        traits.timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    } else if ((options & UIViewAnimationOptionCurveLinear) == UIViewAnimationOptionCurveLinear) {
        traits.timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    [animator animateWithTraits:traits animations:animations completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity
                    options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL))completion {
    GTMMotionAnimator *animator = [[[self class] alloc] init];
    GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithDuration:duration];
    traits.delay = delay;
    traits.timingCurve =
    [[GTMSpringTimingCurveGenerator alloc] initWithDuration:duration
                                               dampingRatio:dampingRatio
                                            initialVelocity:velocity].springTimingCurve;
    [animator animateWithTraits:traits animations:animations completion:completion];
}

#pragma mark - Legacy

- (void)animateWithTiming:(GTMMotionTiming)timing animations:(void (^)(void))animations {
    GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithMotionTiming:timing];
    [self animateWithTraits:traits animations:animations];
}

- (void)animateWithTiming:(GTMMotionTiming)timing
               animations:(void (^)(void))animations
               completion:(void (^)(void))completion {
    GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithMotionTiming:timing];
    [self animateWithTraits:traits animations:animations completion:^(BOOL didComplete) {
        if (completion) {
            completion();
        }
    }];
}

- (void)animateWithTiming:(GTMMotionTiming)timing
                  toLayer:(CALayer *)layer
               withValues:(NSArray *)values
                  keyPath:(GTMAnimatableKeyPath)keyPath {
    GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithMotionTiming:timing];
    [self animateWithTraits:traits between:values layer:layer keyPath:keyPath];
}

- (void)animateWithTiming:(GTMMotionTiming)timing
                  toLayer:(CALayer *)layer
               withValues:(NSArray *)values
                  keyPath:(GTMAnimatableKeyPath)keyPath
               completion:(void (^)(void))completion {
    GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithMotionTiming:timing];
    [self animateWithTraits:traits
                    between:values
                      layer:layer
                    keyPath:keyPath
                 completion:^(BOOL didComplete) {
                     if (completion) {
                         completion();
                     }
                 }];
}

#pragma mark - Private

- (CGFloat)computedTimeScaleFactor {
    CGFloat timeScaleFactor;
    id transactionTimeScaleFactor = [CATransaction gtm_timeScaleFactor];
    if (transactionTimeScaleFactor != nil) {
#if CGFLOAT_IS_DOUBLE
        timeScaleFactor = [transactionTimeScaleFactor doubleValue];
#else
        timeScaleFactor = [transactionTimeScaleFactor floatValue];
#endif
    } else {
        timeScaleFactor = _timeScaleFactor;
    }

    return GTMSimulatorAnimationDragCoefficient() * timeScaleFactor;
}

- (void)addAnimation:(CABasicAnimation *)animation
             toLayer:(CALayer *)layer
         withKeyPath:(NSString *)keyPath
              traits:(GTMAnimationTraits *)traits
     timeScaleFactor:(CGFloat)timeScaleFactor
         destination:(id)destination
        initialValue:(id(^)(BOOL wantsPresentationValue))initialValueBlock
          completion:(void(^)(BOOL))completion {
    // Must configure the keyPath and toValue before we can identify whether the animation supports
    // being additive.
    animation.keyPath = keyPath;
    animation.toValue = destination;
    animation.additive = self.additive && GTMCanAnimationBeAdditive(keyPath, animation.toValue);

    // Additive animations always read from the model layer's value so that the new displacement
    // reflects the change in destination and momentum appears to be conserved across multiple
    // animations.
    //
    // Non-additive animations should try to read from the presentation layer's current value
    // because we'll be interrupting whatever animation previously existed and immediately moving
    // toward the new destination.
    BOOL wantsPresentationValue = self.beginFromCurrentState && !animation.additive;
    animation.fromValue = initialValueBlock(wantsPresentationValue);

    NSString *key = animation.additive ? nil : keyPath;

    GTMConfigureAnimation(animation, traits);

    if (traits.delay != 0) {
        animation.beginTime = ([layer convertTime:CACurrentMediaTime() fromLayer:nil]
                               + traits.delay * timeScaleFactor);
        animation.fillMode = kCAFillModeBackwards;
    }

    [_registrar addAnimation:animation toLayer:layer forKey:key completion:completion];
}

@end

