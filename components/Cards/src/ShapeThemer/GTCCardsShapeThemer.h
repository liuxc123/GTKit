//
//  GTCCardsShapeThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTCards.h"
#import "GTShapeScheme.h"

/**
 The Material Design shape system's themer for instances of GTCCard and GTCCardCollectionCell.
 */
@interface GTCCardsShapeThemer : NSObject

/**
 Applies a shape scheme's properties to an GTCCard.

 @param shapeScheme The shape scheme to apply to the component instance.
 @param card A component instance to which the shape scheme should be applied.
 */
+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme toCard:(nonnull GTCCard *)card;

/**
 Applies a shape scheme's properties to an GTCCardCollectionCell.

 @param shapeScheme The shape scheme to apply to the component instance.
 @param cardCell A component instance to which the shape scheme should be applied.
 */
+ (void)applyShapeScheme:(nonnull id<GTCShapeScheming>)shapeScheme
              toCardCell:(nonnull GTCCardCollectionCell *)cardCell;

@end

