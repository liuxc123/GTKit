//
//  GTCChipViewColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipViewColorThemer.h"

@implementation GTCChipViewColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                      toChipView:(nonnull GTCChipView *)chipView {
    [GTCChipViewColorThemer resetUIControlStatesForChipTheming:chipView];
    UIColor *onSurface12Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.12f];
    UIColor *onSurface87Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.87f];
    UIColor *onSurface16Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.16f];

    UIColor *backgroundColor =
    [GTCSemanticColorScheme blendColor:onSurface12Opacity
                   withBackgroundColor:colorScheme.surfaceColor];
    UIColor *selectedBackgroundColor =
    [GTCSemanticColorScheme blendColor:onSurface12Opacity
                   withBackgroundColor:backgroundColor];
    UIColor *textColor =
    [GTCSemanticColorScheme blendColor:onSurface87Opacity
                   withBackgroundColor:backgroundColor];
    UIColor *selectedTextColor =
    [GTCSemanticColorScheme blendColor:onSurface87Opacity
                   withBackgroundColor:selectedBackgroundColor];

    [chipView setInkColor:onSurface16Opacity forState:UIControlStateNormal];
    [chipView setTitleColor:textColor forState:UIControlStateNormal];
    [chipView setBackgroundColor:backgroundColor forState:UIControlStateNormal];

    [chipView setTitleColor:selectedTextColor forState:UIControlStateSelected];
    [chipView setBackgroundColor:selectedBackgroundColor forState:UIControlStateSelected];

    [chipView setTitleColor:[textColor colorWithAlphaComponent:0.38f]
                   forState:UIControlStateDisabled];
    [chipView setBackgroundColor:[backgroundColor colorWithAlphaComponent:0.38f]
                        forState:UIControlStateDisabled];
}

+ (void)applyOutlinedVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                 toChipView:(nonnull GTCChipView *)chipView {
    [GTCChipViewColorThemer resetUIControlStatesForChipTheming:chipView];
    UIColor *onSurface12Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.12f];
    UIColor *onSurface87Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.87f];
    UIColor *onSurface16Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.16f];
    UIColor *selectedBackgroundColor =
    [GTCSemanticColorScheme blendColor:onSurface12Opacity
                   withBackgroundColor:colorScheme.surfaceColor];
    UIColor *borderColor =
    [GTCSemanticColorScheme blendColor:onSurface12Opacity
                   withBackgroundColor:colorScheme.surfaceColor];
    UIColor *textColor =
    [GTCSemanticColorScheme blendColor:onSurface87Opacity
                   withBackgroundColor:colorScheme.surfaceColor];
    UIColor *selectedTextColor =
    [GTCSemanticColorScheme blendColor:onSurface87Opacity
                   withBackgroundColor:selectedBackgroundColor];

    [chipView setInkColor:onSurface16Opacity forState:UIControlStateNormal];
    [chipView setTitleColor:textColor forState:UIControlStateNormal];
    [chipView setBackgroundColor:colorScheme.surfaceColor forState:UIControlStateNormal];
    [chipView setBorderColor:borderColor forState:UIControlStateNormal];

    [chipView setTitleColor:selectedTextColor forState:UIControlStateSelected];
    [chipView setBackgroundColor:selectedBackgroundColor forState:UIControlStateSelected];
    [chipView setBorderColor:[UIColor clearColor] forState:UIControlStateSelected];

    [chipView setTitleColor:[textColor colorWithAlphaComponent:0.38f]
                   forState:UIControlStateDisabled];
    [chipView setBackgroundColor:[colorScheme.surfaceColor colorWithAlphaComponent:0.38f]
                        forState:UIControlStateDisabled];
    [chipView setBorderColor:[borderColor colorWithAlphaComponent:0.38f]
                    forState:UIControlStateDisabled];
}

+ (void)resetUIControlStatesForChipTheming:(nonnull GTCChipView *)chipView {
    NSUInteger maximumStateValue = UIControlStateNormal | UIControlStateSelected |
    UIControlStateHighlighted | UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [chipView setBackgroundColor:nil forState:state];
        [chipView setTitleColor:nil forState:state];
        [chipView setBorderColor:nil forState:state];
    }
}

@end
