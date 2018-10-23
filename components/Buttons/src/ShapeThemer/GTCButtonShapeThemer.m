//
//  GTCButtonShapeThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCButtonShapeThemer.h"

@implementation GTCButtonShapeThemer

+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
                toButton:(nonnull GTCButton *)button {

    GTCRectangleShapeGenerator *rectangleShape = [[GTCRectangleShapeGenerator alloc] init];
    rectangleShape.topLeftCorner = shapeScheme.smallComponentShape.topLeftCorner;
    rectangleShape.topRightCorner = shapeScheme.smallComponentShape.topRightCorner;
    rectangleShape.bottomLeftCorner = shapeScheme.smallComponentShape.bottomLeftCorner;
    rectangleShape.bottomRightCorner = shapeScheme.smallComponentShape.bottomRightCorner;
    button.shapeGenerator = rectangleShape;
}

@end
