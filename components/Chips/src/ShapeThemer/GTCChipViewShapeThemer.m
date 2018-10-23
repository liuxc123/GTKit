//
//  GTCChipViewShapeThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipViewShapeThemer.h"

static const CGFloat kChipViewBaselineShapePercentageValue = 0.5f;

@implementation GTCChipViewShapeThemer

+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
              toChipView:(nonnull GTCChipView *)chipView {
    // This is an override of the default scheme to fit the baseline values.
    GTCRectangleShapeGenerator *rectangleShape = [[GTCRectangleShapeGenerator alloc] init];
    GTCCornerTreatment *cornerTreatment =
    [GTCCornerTreatment cornerWithRadius:kChipViewBaselineShapePercentageValue
                               valueType:GTCCornerTreatmentValueTypePercentage];
    [rectangleShape setCorners:cornerTreatment];
    chipView.shapeGenerator = rectangleShape;
}

@end
