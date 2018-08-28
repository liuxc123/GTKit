//
//  GTCPageControlIndicator.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/27.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 This shape layer provides a circular indicator denoting a page in a page control.

 @internal
 */
@interface GTCPageControlIndicator : CAShapeLayer

/** The color of the indicator. */
@property(nonatomic, strong) UIColor *color;

/**
 Default initializer.

 @param center The layer position for this indicator.
 @param radius The radius of this indicator circle.
 */
- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius NS_DESIGNATED_INITIALIZER;

/** Reveals the indicator by scaling from zero to full size while fading in. */
- (void)revealIndicator;

/**
 Updates the indicator transform.x property along the track by the designated percentage.

 @param transformX The transform.x value.
 */
- (void)updateIndicatorTransformX:(CGFloat)transformX;

/**
 Updates the indicator transform.x property along the track by the designated percentage.

 @param transformX The transform.x value.
 @param animated The whether to animate the change.
 @param duration The duration of the animation.
 @param timingFunction The timing function to use when animating the value.
 */
- (void)updateIndicatorTransformX:(CGFloat)transformX
                         animated:(BOOL)animated
                         duration:(NSTimeInterval)duration
              mediaTimingFunction:(CAMediaTimingFunction *)timingFunction;

@end
