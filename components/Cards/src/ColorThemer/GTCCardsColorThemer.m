//
//  GTCCardsColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCardsColorThemer.h"


static const CGFloat kStrokeVariantBorderOpacity = 0.37f;

@implementation GTCCardsColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                          toCard:(nonnull GTCCard *)card {
    card.backgroundColor = colorScheme.surfaceColor;
}

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                      toCardCell:(nonnull GTCCardCollectionCell *)cardCell {
    cardCell.backgroundColor = colorScheme.surfaceColor;
}

+ (void)applyOutlinedVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                     toCard:(nonnull GTCCard *)card {
    NSUInteger maximumStateValue =
    UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted |
    UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [card setBorderColor:nil forState:state];
    }

    card.backgroundColor = colorScheme.surfaceColor;
    UIColor *borderColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kStrokeVariantBorderOpacity];
    [card setBorderColor:borderColor forState:UIControlStateNormal];
}

+ (void)applyOutlinedVariantWithColorScheme:(id<GTCColorScheming>)colorScheme
                                 toCardCell:(GTCCardCollectionCell *)cardCell {
    NSUInteger maximumStateValue =
    UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted |
    UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [cardCell setBorderColor:nil forState:state];
    }

    cardCell.backgroundColor = colorScheme.surfaceColor;
    UIColor *borderColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kStrokeVariantBorderOpacity];
    [cardCell setBorderColor:borderColor forState:GTCCardCellStateNormal];
}

@end
