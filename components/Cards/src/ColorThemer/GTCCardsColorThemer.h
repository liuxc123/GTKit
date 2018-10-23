//
//  GTCCardsColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTCards.h"
#import "GTColorScheme.h"

/**
 The Material Design color system's themer for instances of GTCCard and GTCCardCollectionCell.
 */
@interface GTCCardsColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCCard.

 @param colorScheme The color scheme to apply to the component instance.
 @param card A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                          toCard:(nonnull GTCCard *)card;

/**
 Applies a color scheme's properties to an GTCCardCollectionCell.

 @param colorScheme The color scheme to apply to the component instance.
 @param cardCell A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                      toCardCell:(nonnull GTCCardCollectionCell *)cardCell;

/**
 Applies a color scheme's properties to an GTCCard and styles it with a border stroke.

 @param colorScheme The color scheme to apply to GTCCard.
 @param card An GTCCard instance to which the color scheme should be applied.
 */
+ (void)applyOutlinedVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                     toCard:(nonnull GTCCard *)card;

/**
 Applies a color scheme's properties to an GTCCardCollectionCell and styles it with a border stroke.

 @param colorScheme The color scheme to apply to GTCCardCollectionCell.
 @param cardCell An GTCCardCollectionCell instance to which the color scheme should be applied.
 */
+ (void)applyOutlinedVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                 toCardCell:(nonnull GTCCardCollectionCell *)cardCell;

@end

