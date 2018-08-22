//
//  GTCLegacyInkLayer+Testing.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/20.
//

#import "GTCLegacyInkLayer.h"

@protocol GTCLegacyInkLayerRippleDelegate <NSObject>

@optional

- (void)animationDidStop:(CAAnimation *)anim
              shapeLayer:(CAShapeLayer *)shapeLayer
                finished:(BOOL)finished;

@end

@interface GTCLegacyInkLayer ()  <GTCLegacyInkLayerRippleDelegate>
@end

@interface GTCLegacyInkLayerRipple : CAShapeLayer
@end

@interface GTCLegacyInkLayerForegroundRipple : GTCLegacyInkLayerRipple
- (void)exit:(BOOL)animated;
@end

@interface GTCLegacyInkLayerBackgroundRipple : GTCLegacyInkLayerRipple
- (void)exit:(BOOL)animated;
@end
