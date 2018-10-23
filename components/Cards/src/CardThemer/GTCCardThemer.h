//
//  GTCCardThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCardScheme.h"

#import "GTCards.h"

#import <Foundation/Foundation.h>

/** Applies material style to GTCCard objects. */
@interface GTCCardThemer : NSObject

/**
 Applies the material card style using the card scheme data.

 @param scheme The card style data that should be used to change the @c card.
 @param card A GTCCard instance to apply the @c scheme
 */
+ (void)applyScheme:(nonnull id<GTCCardScheming>)scheme
             toCard:(nonnull GTCCard *)card;

/**
 Applies the material card style using the card scheme data.

 @param scheme The card style data that should be used to change the @c card.
 @param cardCell A GTCCardCollectionCell instance to apply the @c scheme
 */
+ (void)applyScheme:(nonnull id<GTCCardScheming>)scheme
         toCardCell:(nonnull GTCCardCollectionCell *)cardCell;

/**
 Applies the material outlined card style using the card scheme data.

 @param scheme The card style data that should be used to change the @c card.
 @param card A GTCCard instance to apply the @c scheme
 */
+ (void)applyOutlinedVariantWithScheme:(nonnull id<GTCCardScheming>)scheme
                                toCard:(nonnull GTCCard *)card;

/**
 Applies the material outlined card style using the card scheme data.

 @param scheme The card style data that should be used to change the @c card.
 @param cardCell A GTCCardCollectionCell instance to apply the @c scheme
 */
+ (void)applyOutlinedVariantWithScheme:(nonnull id<GTCCardScheming>)scheme
                            toCardCell:(nonnull GTCCardCollectionCell *)cardCell;

@end

