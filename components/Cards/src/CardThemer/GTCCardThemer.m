//
//  GTCCardThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCardThemer.h"

#import "GTCards+ColorThemer.h"
#import "GTCards+ShapeThemer.h"

static const GTCShadowElevation kNormalElevation = 1.f;
static const GTCShadowElevation kHighlightedElevation = 4.f;
static const GTCShadowElevation kSelectedElevation = 4.f;
static const CGFloat kBorderWidth = 1.f;

@implementation GTCCardThemer

+ (void)applyScheme:(nonnull id<GTCCardScheming>)scheme
             toCard:(nonnull GTCCard *)card {
    [card setShadowElevation:kNormalElevation forState:UIControlStateNormal];
    [card setShadowElevation:kHighlightedElevation forState:UIControlStateHighlighted];
    card.interactable = YES;
    [GTCCardsColorThemer applySemanticColorScheme:scheme.colorScheme toCard:card];
    [GTCCardsShapeThemer applyShapeScheme:scheme.shapeScheme toCard:card];
}

+ (void)applyScheme:(nonnull id<GTCCardScheming>)scheme
         toCardCell:(nonnull GTCCardCollectionCell *)cardCell {
    [cardCell setShadowElevation:kNormalElevation forState:GTCCardCellStateNormal];
    [cardCell setShadowElevation:kHighlightedElevation forState:GTCCardCellStateHighlighted];
    [cardCell setShadowElevation:kSelectedElevation forState:GTCCardCellStateSelected];
    cardCell.interactable = YES;
    [GTCCardsColorThemer applySemanticColorScheme:scheme.colorScheme toCardCell:cardCell];
    [GTCCardsShapeThemer applyShapeScheme:scheme.shapeScheme toCardCell:cardCell];
}

+ (void)applyOutlinedVariantWithScheme:(nonnull id<GTCCardScheming>)scheme
                                toCard:(nonnull GTCCard *)card {
    NSUInteger maximumStateValue =
    UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted |
    UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [card setBorderWidth:kBorderWidth forState:state];
    }
    [card setShadowElevation:kHighlightedElevation forState:UIControlStateHighlighted];
    [GTCCardsColorThemer applyOutlinedVariantWithColorScheme:scheme.colorScheme toCard:card];
    [GTCCardsShapeThemer applyShapeScheme:scheme.shapeScheme toCard:card];
}

+ (void)applyOutlinedVariantWithScheme:(nonnull id<GTCCardScheming>)scheme
                            toCardCell:(nonnull GTCCardCollectionCell *)cardCell {
    for (GTCCardCellState state = GTCCardCellStateNormal; state <= GTCCardCellStateSelected;
         state++) {
        [cardCell setBorderWidth:kBorderWidth forState:state];
    }
    [cardCell setShadowElevation:kHighlightedElevation forState:GTCCardCellStateHighlighted];
    [cardCell setShadowElevation:kSelectedElevation forState:GTCCardCellStateSelected];


    [GTCCardsColorThemer applyOutlinedVariantWithColorScheme:scheme.colorScheme toCardCell:cardCell];
    [GTCCardsShapeThemer applyShapeScheme:scheme.shapeScheme toCardCell:cardCell];
}

@end


