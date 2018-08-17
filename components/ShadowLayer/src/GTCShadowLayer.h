//
//  GTCShadowLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>
#import "GTShadowElevations.h"

/**
 Metrics of the Material shadow effect.

 These can be used if you require your own shadow implementation but want to match the material
 spec.
 */
@interface GTCShadowMetrics : NSObject
@property(nonatomic, readonly) CGFloat topShadowRadius;
@property(nonatomic, readonly) CGSize topShadowOffset;
@property(nonatomic, readonly) float topShadowOpacity;
@property(nonatomic, readonly) CGFloat bottomShadowRadius;
@property(nonatomic, readonly) CGSize bottomShadowOffset;
@property(nonatomic, readonly) float bottomShadowOpacity;

/**
 The shadow metrics for manually creating shadows given an elevation.

 @param elevation The shadow's elevation in points.
 @return The shadow metrics.
 */
+ (nonnull GTCShadowMetrics *)metricsWithElevation:(CGFloat)elevation;
@end

/**
 The Material shadow effect.

 @see
 https://material.io/guidelines/what-is-material/elevation-shadows.html#elevation-shadows-shadows

 Consider rasterizing your GTCShadowLayer if your view will not generally be animating or
 changing size. If you need to animate a rasterized GTCShadowLayer, disable rasterization first.

 For example, if self's layerClass is GTCShadowLayer, you might introduce the following code:

 self.layer.shouldRasterize = YES;
 self.layer.rasterizationScale = [UIScreen mainScreen].scale;
 */
@interface GTCShadowLayer : CALayer

/**
 The elevation of the layer in points.

 The higher the elevation, the more spread out the shadow is. This is distinct from the layer's
 zPosition which can be used to order overlapping layers, but will have no affect on the size of
 the shadow.

 Negative values act as if zero were specified.

 The default value is 0.
 */
@property(nonatomic, assign) GTCShadowElevation elevation;

/**
 Whether to apply the "cutout" shadow layer mask.

 If enabled, then a mask is created to ensure the interior, non-shadow part of the layer is visible.

 Default is YES. Not animatable.
 */
@property(nonatomic, getter=isShadowMaskEnabled, assign) BOOL shadowMaskEnabled;

@end

/**
 Subclasses can depend on GTCShadowLayer implementing CALayerDelegate actionForLayer:forKey: in
 order to implicitly animate 'path' or 'shadowPath' on sublayers.
 */
@interface GTCShadowLayer (Subclassing) <CALayerDelegate>
@end

