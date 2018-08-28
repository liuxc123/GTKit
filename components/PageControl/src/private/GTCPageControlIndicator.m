//
//  GTCPageControlIndicator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/27.
//

#import "GTCPageControlIndicator.h"

static const NSTimeInterval kPageControlIndicatorAnimationDuration = 0.3;
static NSString *const kPageControlIndicatorAnimationKey = @"fadeInScaleUp";

@implementation GTCPageControlIndicator
{
    BOOL _isAnimating;
}

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
        self.path = [self circlePathWithRadius:radius];
        self.zPosition = 1;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    // Override here to disable implicit layer animation.
    _color = color;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGColorRef cgColor = _color.CGColor;
    self.fillColor = cgColor;
    [super setOpacity:(float)CGColorGetAlpha(cgColor)];
    [CATransaction commit];
}

- (void)setOpacity:(float)opacity {
    // Override here to disable implicit layer animation.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setOpacity:opacity];
    [CATransaction commit];
}

- (void)revealIndicator {
    // Scale indicator from zero to full size while fading in.
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];

    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(0);
    fadeAnimation.toValue = @(self.opacity);

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = kPageControlIndicatorAnimationDuration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    group.animations = @[ scaleAnimation, fadeAnimation ];
    [self addAnimation:group forKey:kPageControlIndicatorAnimationKey];

    // Default value.
    self.hidden = NO;
}

- (void)updateIndicatorTransformX:(CGFloat)transformX
                         animated:(BOOL)animated
                         duration:(NSTimeInterval)duration
              mediaTimingFunction:(CAMediaTimingFunction *)timingFunction {
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:timingFunction];
    self.transform = CATransform3DMakeTranslation(transformX, 0, 0);
    [CATransaction commit];
}

- (void)updateIndicatorTransformX:(CGFloat)transformX {
    // Disable animation of this transform.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.transform = CATransform3DMakeTranslation(transformX, 0, 0);
    [CATransaction commit];
}

#pragma mark - Private

- (CGPathRef)circlePathWithRadius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, radius * 2, radius * 2)
                                      cornerRadius:radius]
    .CGPath;
}
@end
