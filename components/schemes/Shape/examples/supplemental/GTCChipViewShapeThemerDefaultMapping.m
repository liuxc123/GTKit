//
//  GTCChipViewShapeThemerDefaultMapping.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipViewShapeThemerDefaultMapping.h"

@implementation GTCChipViewShapeThemerDefaultMapping

+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
              toChipView:(nonnull GTCChipView *)chipView {
    GTCRectangleShapeGenerator *rectangleShape = [[GTCRectangleShapeGenerator alloc] init];
//    rectangleShape.topLeftCorner = shapeScheme.smallComponentShape.topLeftCorner;
//    rectangleShape.topRightCorner = shapeScheme.smallComponentShape.topRightCorner;
//    rectangleShape.bottomLeftCorner = shapeScheme.smallComponentShape.bottomLeftCorner;
//    rectangleShape.bottomRightCorner = shapeScheme.smallComponentShape.bottomRightCorner;
    chipView.shapeGenerator = rectangleShape;
}

@end
