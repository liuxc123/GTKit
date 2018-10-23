//
//  GTCBottomSheetControllerShapeThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "GTCBottomSheetControllerShapeThemer.h"

static const CGFloat kBottomSheetCollapsedBaselineShapeValue = 24.0f;

@implementation GTCBottomSheetControllerShapeThemer

+ (void)applyShapeScheme:(id<GTCShapeScheming>)shapeScheme
 toBottomSheetController:(GTCBottomSheetController *)bottomSheetController {
    // Shape Generator for the Extended state of the Bottom Sheet.
    GTCRectangleShapeGenerator *rectangleShapeExtended = [[GTCRectangleShapeGenerator alloc] init];
    GTCCornerTreatment *cornerTreatmentExtended = shapeScheme.largeComponentShape.topLeftCorner;
    [rectangleShapeExtended setCorners:cornerTreatmentExtended];
    [bottomSheetController setShapeGenerator:rectangleShapeExtended forState:GTCSheetStateExtended];

    // Shape Generator for the Preferred state of the Bottom Sheet.
    // This is an override of the default scheme to fit the baseline values.
    GTCRectangleShapeGenerator *rectangleShapePreferred = [[GTCRectangleShapeGenerator alloc] init];
    GTCCornerTreatment *cornerTreatmentPreferred =
    [[GTCRoundedCornerTreatment alloc] initWithRadius:kBottomSheetCollapsedBaselineShapeValue];
    [rectangleShapePreferred setCorners:cornerTreatmentPreferred];
    [bottomSheetController setShapeGenerator:rectangleShapePreferred forState:GTCSheetStatePreferred];
}

@end
