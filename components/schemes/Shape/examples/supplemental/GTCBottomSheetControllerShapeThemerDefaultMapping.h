//
//  GTCBottomSheetControllerShapeThemerDefaultMapping.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTBottomSheet+ShapeThemer.h"

/**
 The Material Design shape system's themer for instances of GTCBottomSheetController.
 */
@interface GTCBottomSheetControllerShapeThemerDefaultMapping : GTCBottomSheetControllerShapeThemer

/**
 Applies a shape scheme's properties to an GTCBottomSheetController.

 @param shapeScheme The shape scheme to apply to the component instance.
 @param bottomSheetController A component instance to which the shape scheme should be applied.
 */
+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
 toBottomSheetController:(nonnull GTCBottomSheetController *)bottomSheetController;

@end
