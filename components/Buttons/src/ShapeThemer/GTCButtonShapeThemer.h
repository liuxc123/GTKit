//
//  GTCButtonShapeThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTButtons.h"
#import "GTShapeScheme.h"

/**
 The Material Design shape system's themer for instances of GTCButton.
 */
@interface GTCButtonShapeThemer : NSObject

/**
 Applies a shape scheme's properties to an GTCButton.

 @param shapeScheme The shape scheme to apply to the component instance.
 @param button A component instance to which the shape scheme should be applied.
 */
+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
                toButton:(nonnull GTCButton *)button;

@end
