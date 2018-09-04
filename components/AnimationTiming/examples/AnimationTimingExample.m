//
//  AnimationTimingExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import "GTAnimationTiming.h"
#import "supplemental/AnimationTimingExampleSupplemental.h"

const NSTimeInterval kAnimationTimeInterval = 1.0f;
const NSTimeInterval kAnimationTimeDelay = 0.5f;

@interface AnimationTimingExample ()

@end

@implementation AnimationTimingExample

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupExampleViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSTimeInterval timeInterval = 2 * (kAnimationTimeInterval + kAnimationTimeDelay);
    [_animationLoop invalidate];
    _animationLoop = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:self
                                                    selector:@selector(playAnimations:)
                                                    userInfo:nil
                                                     repeats:YES];
    [self playAnimations:nil];
}

- (void)playAnimations:(NSTimer *)timer {
    CAMediaTimingFunction *linearTimingCurve =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self applyAnimationToView:_linearView withTimingFunction:linearTimingCurve];

    CAMediaTimingFunction *materialStandardCurve =
    [CAMediaTimingFunction gtc_functionWithType:GTCAnimationTimingFunctionStandard];
    [self applyAnimationToView:_materialStandardView withTimingFunction:materialStandardCurve];

    CAMediaTimingFunction *materialDecelerationCurve =
    [CAMediaTimingFunction gtc_functionWithType:GTCAnimationTimingFunctionDeceleration];
    [self applyAnimationToView:_materialDecelerationView withTimingFunction:materialDecelerationCurve];

    CAMediaTimingFunction *materialAccelerationCurve =
    [CAMediaTimingFunction gtc_functionWithType:GTCAnimationTimingFunctionAcceleration];
    [self applyAnimationToView:_materialAccelerationView withTimingFunction:materialAccelerationCurve];

    CAMediaTimingFunction *materialSharpCurve =
    [CAMediaTimingFunction gtc_functionWithType:GTCAnimationTimingFunctionSharp];
    [self applyAnimationToView:_materialSharpView withTimingFunction:materialSharpCurve];
}

- (void)applyAnimationToView:(UIView *)view
          withTimingFunction:(CAMediaTimingFunction *)timingFunction {
    CGFloat animWidth = self.view.frame.size.width - view.frame.size.width - 32.f;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(animWidth, 0);
    [UIView gtc_animateWithTimingFunction:timingFunction
                                 duration:kAnimationTimeInterval
                                    delay:kAnimationTimeDelay
                                  options:0
                               animations:^{
                                   view.transform = transform;
                               }
                               completion:^(BOOL finished) {
                                   [UIView gtc_animateWithTimingFunction:timingFunction
                                                                duration:kAnimationTimeInterval
                                                                   delay:kAnimationTimeDelay
                                                                 options:0
                                                              animations:^{
                                                                  view.transform = CGAffineTransformIdentity;
                                                              }
                                                              completion:nil];
                               }];
}

@end

