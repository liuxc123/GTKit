//
//  GTCChipViewShapeThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTChips.h"
#import "GTShapeLibrary.h"
#import "GTShapeScheme.h"
#import "GTShapes.h"

/**
 The Material Design shape system's themer for instances of GTCChipView.
 */
@interface GTCChipViewShapeThemer : NSObject

/**
 Applies a shape scheme's properties to an GTCChipView.

 @param shapeScheme The shape scheme to apply to the component instance.
 @param chipView A component instance to which the shape scheme should be applied.
 */
+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
              toChipView:(nonnull GTCChipView *)chipView;

@end
