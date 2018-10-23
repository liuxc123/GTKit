//
//  GTCFeatureHighlightLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <QuartzCore/QuartzCore.h>

@interface GTCFeatureHighlightLayer : CAShapeLayer

- (void)setPosition:(CGPoint)position animated:(BOOL)animated;

- (void)setRadius:(CGFloat)radius animated:(BOOL)animated;

- (void)setFillColor:(CGColorRef)fillColor animated:(BOOL)animated;

- (void)animateRadiusOverKeyframes:(NSArray *)radii
                          keyTimes:(NSArray *)keyTimes;

- (void)animateFillColorOverKeyframes:(NSArray *)colors keyTimes:(NSArray *)keyTimes;

@end
