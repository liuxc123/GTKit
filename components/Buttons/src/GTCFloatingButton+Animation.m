//
//  GTCFloatingButton+Animation.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/21.
//

#import "GTCFloatingButton+Animation.h"
#if TARGET_IPHONE_SIMULATOR
float UIAnimationDragCoefficient(void);  // Private API for simulator animation speed
#endif

static NSString *const kGTCFloatingButtonTransformKey = @"kGTCFloatingButtonTransformKey";
static NSString *const kGTCFloatingButtonOpacityKey = @"kGTCFloatingButtonOpacityKey";

// By using a power of 2 (2^-12), we can reduce rounding errors during transform multiplication
static const CGFloat kGTCFloatingButtonTransformScale = (CGFloat)0.000244140625;

static const NSTimeInterval kGTCFloatingButtonEnterDuration = 0.270f;
static const NSTimeInterval kGTCFloatingButtonExitDuration = 0.180f;

static const NSTimeInterval kGTCFloatingButtonEnterIconDuration = 0.180f;
static const NSTimeInterval kGTCFloatingButtonEnterIconOffset = 0.090f;
static const NSTimeInterval kGTCFloatingButtonExitIconDuration = 0.135f;
static const NSTimeInterval kGTCFloatingButtonExitIconOffset = 0.000f;

static const NSTimeInterval kGTCFloatingButtonOpacityDuration = 0.015f;
static const NSTimeInterval kGTCFloatingButtonOpacityEnterOffset = 0.030f;
static const NSTimeInterval kGTCFloatingButtonOpacityExitOffset = 0.150f;

@implementation GTCFloatingButton (Animation)

+ (CATransform3D)collapseTransform {
    return CATransform3DMakeScale(kGTCFloatingButtonTransformScale, kGTCFloatingButtonTransformScale,
                                  1);
}

+ (CATransform3D)expandTransform {
    return CATransform3DInvert([GTCFloatingButton collapseTransform]);
}

+ (CABasicAnimation *)animationWithKeypath:(nonnull NSString *)keyPath
                                   toValue:(nonnull id)toValue
                                 fromValue:(nullable id)fromValue
                            timingFunction:(nonnull CAMediaTimingFunction *)timingFunction
                                  fillMode:(nonnull NSString *)fillMode
                                  duration:(NSTimeInterval)duration
                               beginOffset:(NSTimeInterval)beginOffset {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.toValue = toValue;
    animation.fromValue = fromValue;
    animation.timingFunction = timingFunction;
    animation.fillMode = fillMode;
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    if (fabs(beginOffset) > DBL_EPSILON) {
        animation.beginTime = CACurrentMediaTime() + beginOffset;
    }

#if TARGET_IPHONE_SIMULATOR
    animation.duration *= [self fab_dragCoefficient];
    if (fabs(beginOffset) > DBL_EPSILON) {
        animation.beginTime = CACurrentMediaTime() + (beginOffset * [self fab_dragCoefficient]);
    }
#endif

    return animation;
}

#if TARGET_IPHONE_SIMULATOR
+ (float)fab_dragCoefficient {
    if (&UIAnimationDragCoefficient) {
        float coeff = UIAnimationDragCoefficient();
        if (coeff > 1) {
            return coeff;
        }
    }
    return 1;
}
#endif

- (void)expand:(BOOL)animated completion:(void (^_Nullable)(void))completion {
    void (^expandActions)(void) = ^{
        self.layer.transform =
        CATransform3DConcat(self.layer.transform, [GTCFloatingButton expandTransform]);
        self.layer.opacity = 1;
        self.imageView.layer.transform =
        CATransform3DConcat(self.imageView.layer.transform, [GTCFloatingButton expandTransform]);
        [self.layer removeAnimationForKey:kGTCFloatingButtonTransformKey];
        [self.layer removeAnimationForKey:kGTCFloatingButtonOpacityKey];
        [self.imageView.layer removeAnimationForKey:kGTCFloatingButtonTransformKey];
        if (completion) {
            completion();
        }
    };

    if (animated) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:expandActions];

        CABasicAnimation *overallScaleAnimation = [GTCFloatingButton
                                                   animationWithKeypath:@"transform"
                                                   toValue:[NSValue
                                                            valueWithCATransform3D:CATransform3DConcat(
                                                                                                       self.layer.transform,
                                                                                                       [GTCFloatingButton expandTransform])]
                                                   fromValue:nil
                                                   timingFunction:[[CAMediaTimingFunction alloc]
                                                                   initWithControlPoints:0.0f:0.0f:0.2f:1.0f]
                                                   fillMode:kCAFillModeForwards
                                                   duration:kGTCFloatingButtonEnterDuration
                                                   beginOffset:0];
        [self.layer addAnimation:overallScaleAnimation forKey:kGTCFloatingButtonTransformKey];

        CALayer *iconPresentationLayer = self.imageView.layer.presentationLayer;
        if (iconPresentationLayer) {
            // Transform from a scale of 0, up to the icon view's current (animated) transform
            CALayer *presentationLayer = self.layer.presentationLayer;
            NSValue *fromValue =
            presentationLayer ? [NSValue valueWithCATransform3D:CATransform3DConcat(
                                                                                    presentationLayer.transform,
                                                                                    CATransform3DMakeScale(0, 0, 1))]
            : nil;
            CABasicAnimation *iconScaleAnimation = [GTCFloatingButton
                                                    animationWithKeypath:@"transform"
                                                    toValue:[NSValue valueWithCATransform3D:iconPresentationLayer.transform]
                                                    fromValue:fromValue
                                                    timingFunction:[[CAMediaTimingFunction alloc]
                                                                    initWithControlPoints:0.0f:0.0f:0.2f:1.0f]
                                                    fillMode:kCAFillModeBoth
                                                    duration:kGTCFloatingButtonEnterIconDuration
                                                    beginOffset:kGTCFloatingButtonEnterIconOffset];
            [self.imageView.layer addAnimation:iconScaleAnimation forKey:kGTCFloatingButtonTransformKey];
        }

        CABasicAnimation *opacityAnimation = [GTCFloatingButton
                                              animationWithKeypath:@"opacity"
                                              toValue:[NSNumber numberWithInt:1]
                                              fromValue:nil
                                              timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]
                                              fillMode:kCAFillModeForwards
                                              duration:kGTCFloatingButtonOpacityDuration
                                              beginOffset:kGTCFloatingButtonOpacityEnterOffset];
        [self.layer addAnimation:opacityAnimation forKey:kGTCFloatingButtonOpacityKey];

        [CATransaction commit];
    } else {
        expandActions();
    }
}

- (void)collapse:(BOOL)animated completion:(void (^_Nullable)(void))completion {
    void (^collapseActions)(void) = ^{
        self.layer.transform =
        CATransform3DConcat(self.layer.transform, [GTCFloatingButton collapseTransform]);
        self.layer.opacity = 0;
        self.imageView.layer.transform =
        CATransform3DConcat(self.imageView.layer.transform, [GTCFloatingButton collapseTransform]);
        [self.layer removeAnimationForKey:kGTCFloatingButtonTransformKey];
        [self.layer removeAnimationForKey:kGTCFloatingButtonOpacityKey];
        [self.imageView.layer removeAnimationForKey:kGTCFloatingButtonTransformKey];
        if (completion) {
            completion();
        }
    };

    if (animated) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:collapseActions];

        CABasicAnimation *overallScaleAnimation = [GTCFloatingButton
                                                   animationWithKeypath:@"transform"
                                                   toValue:[NSValue
                                                            valueWithCATransform3D:CATransform3DConcat(
                                                                                                       self.layer.transform,
                                                                                                       [GTCFloatingButton collapseTransform])]
                                                   fromValue:nil
                                                   timingFunction:[[CAMediaTimingFunction alloc]
                                                                   initWithControlPoints:0.4f:0.0f:1.0f:1.0f]
                                                   fillMode:kCAFillModeForwards
                                                   duration:kGTCFloatingButtonExitDuration
                                                   beginOffset:0];
        [self.layer addAnimation:overallScaleAnimation forKey:kGTCFloatingButtonTransformKey];

        CABasicAnimation *iconScaleAnimation = [GTCFloatingButton
                                                animationWithKeypath:@"transform"
                                                toValue:[NSValue
                                                         valueWithCATransform3D:CATransform3DConcat(
                                                                                                    self.imageView.layer.transform,
                                                                                                    [GTCFloatingButton collapseTransform])]
                                                fromValue:nil
                                                timingFunction:[[CAMediaTimingFunction alloc]
                                                                initWithControlPoints:0.4f:0.0f:1.0f:1.0f]
                                                fillMode:kCAFillModeForwards
                                                duration:kGTCFloatingButtonExitIconDuration
                                                beginOffset:kGTCFloatingButtonExitIconOffset];
        [self.imageView.layer addAnimation:iconScaleAnimation forKey:kGTCFloatingButtonTransformKey];

        CABasicAnimation *opacityAnimation = [GTCFloatingButton
                                              animationWithKeypath:@"opacity"
                                              toValue:[NSNumber numberWithFloat:0]
                                              fromValue:nil
                                              timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]
                                              fillMode:kCAFillModeForwards
                                              duration:kGTCFloatingButtonOpacityDuration
                                              beginOffset:kGTCFloatingButtonOpacityExitOffset];
        [self.layer addAnimation:opacityAnimation forKey:kGTCFloatingButtonOpacityKey];

        [CATransaction commit];
    } else {
        collapseActions();
    }
}

@end
