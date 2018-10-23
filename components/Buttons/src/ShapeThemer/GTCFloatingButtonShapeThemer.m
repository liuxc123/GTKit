//
//  GTCFloatingButtonShapeThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCFloatingButtonShapeThemer.h"

static const CGFloat kFloatingButtonBaselineShapePercentageValue = 0.5f;

@implementation GTCFloatingButtonShapeThemer

+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
                toButton:(nonnull GTCFloatingButton *)button {
    // This is an override of the default scheme to fit the baseline values.
    GTCRectangleShapeGenerator *rectangleShape = [[GTCRectangleShapeGenerator alloc] init];
    GTCCornerTreatment *cornerTreatment =
    [GTCCornerTreatment cornerWithRadius:kFloatingButtonBaselineShapePercentageValue
                               valueType:GTCCornerTreatmentValueTypePercentage];
    [rectangleShape setCorners:cornerTreatment];
    button.shapeGenerator = rectangleShape;
}

@end
