//
//  GTCChipViewThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipViewThemer.h"
#import "GTChips+ChipThemer.h"

#import "GTChips+ColorThemer.h"
#import "GTChips+ShapeThemer.h"
#import "GTChips+TypographyThemer.h"

@implementation GTCChipViewThemer

+ (void)applyScheme:(nonnull id<GTCChipViewScheming>)scheme
         toChipView:(nonnull GTCChipView *)chip {
    NSUInteger maximumStateValue =
    UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted |
    UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [chip setBorderWidth:0 forState:state];
    }
    [GTCChipViewColorThemer applySemanticColorScheme:scheme.colorScheme toChipView:chip];
    [GTCChipViewShapeThemer applyShapeScheme:scheme.shapeScheme toChipView:chip];
    [GTCChipViewTypographyThemer applyTypographyScheme:scheme.typographyScheme toChipView:chip];
}

+ (void)applyOutlinedVariantWithScheme:(nonnull id<GTCChipViewScheming>)scheme
                            toChipView:(nonnull GTCChipView *)chip {
    NSUInteger maximumStateValue =
    UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted |
    UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [chip setBorderWidth:1 forState:state];
    }
    [GTCChipViewColorThemer applyOutlinedVariantWithColorScheme:scheme.colorScheme toChipView:chip];
    [GTCChipViewShapeThemer applyShapeScheme:scheme.shapeScheme toChipView:chip];
    [GTCChipViewTypographyThemer applyTypographyScheme:scheme.typographyScheme toChipView:chip];
}

@end



