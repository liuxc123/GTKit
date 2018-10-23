//
//  GTCCardsShapeThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCardsShapeThemer.h"

@implementation GTCCardsShapeThemer

+ (void)applyShapeScheme:(id<GTCShapeScheming>)shapeScheme toCard:(GTCCard *)card {
    card.shapeGenerator = [self cardShapeGeneratorFromScheme:shapeScheme];
}

+ (void)applyShapeScheme:(id<GTCShapeScheming>)shapeScheme
              toCardCell:(GTCCardCollectionCell *)cardCell {
    cardCell.shapeGenerator = [self cardShapeGeneratorFromScheme:shapeScheme];
}

+ (id<GTCShapeGenerating>)cardShapeGeneratorFromScheme:(id<GTCShapeScheming>)shapeScheme {
    GTCRectangleShapeGenerator *rectangleShape = [[GTCRectangleShapeGenerator alloc] init];
    rectangleShape.topLeftCorner = shapeScheme.mediumComponentShape.topLeftCorner;
    rectangleShape.topRightCorner = shapeScheme.mediumComponentShape.topRightCorner;
    rectangleShape.bottomLeftCorner = shapeScheme.mediumComponentShape.bottomLeftCorner;
    rectangleShape.bottomRightCorner = shapeScheme.mediumComponentShape.bottomRightCorner;
    return rectangleShape;
}

@end
