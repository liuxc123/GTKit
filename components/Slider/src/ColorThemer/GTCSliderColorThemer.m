//
//  GTCSliderColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCSliderColorThemer.h"
#import "GTPalettes.h"

static const CGFloat kSliderBaselineDisabledFillAlpha = 0.32f;
static const CGFloat kSliderBaselineEnabledBackgroundAlpha = 0.24f;
static const CGFloat kSliderBaselineDisabledBackgroundAlpha = 0.12f;
static const CGFloat kSliderBaselineEnabledTicksAlpha = 0.54f;
static const CGFloat kSliderBaselineDisabledTicksAlpha = 0.12f;


@implementation GTCSliderColorThemer


+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toSlider:(nonnull GTCSlider *)slider {
    UIColor *disabledFillColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kSliderBaselineDisabledFillAlpha];
    UIColor *enabledBackgroundColor =
    [colorScheme.primaryColor colorWithAlphaComponent:kSliderBaselineEnabledBackgroundAlpha];

    if (slider.statefulAPIEnabled) {
        [slider setTrackFillColor:colorScheme.primaryColor forState:UIControlStateNormal];
        [slider setTrackFillColor:disabledFillColor forState:UIControlStateDisabled];
        [slider setTrackBackgroundColor:enabledBackgroundColor forState:UIControlStateNormal];
        UIColor *disabledBackgroundColor =
        [colorScheme.onSurfaceColor colorWithAlphaComponent:kSliderBaselineDisabledBackgroundAlpha];
        [slider setTrackBackgroundColor:disabledBackgroundColor forState:UIControlStateDisabled];
        UIColor *enabledTickFillColor =
        [colorScheme.onPrimaryColor colorWithAlphaComponent:kSliderBaselineEnabledTicksAlpha];
        [slider setFilledTrackTickColor:enabledTickFillColor forState:UIControlStateNormal];
        UIColor *disabledTickFillColor =
        [colorScheme.onPrimaryColor colorWithAlphaComponent:kSliderBaselineDisabledTicksAlpha];
        [slider setFilledTrackTickColor:disabledTickFillColor forState:UIControlStateDisabled];
        UIColor *enabledTickBackgroundColor =
        [colorScheme.primaryColor colorWithAlphaComponent:kSliderBaselineEnabledTicksAlpha];
        [slider setBackgroundTrackTickColor:enabledTickBackgroundColor forState:UIControlStateNormal];
        UIColor *disabledTickBackgroundColor =
        [colorScheme.onSurfaceColor colorWithAlphaComponent:kSliderBaselineDisabledTicksAlpha];
        [slider setBackgroundTrackTickColor:disabledTickBackgroundColor
                                   forState:UIControlStateDisabled];
        [slider setThumbColor:colorScheme.primaryColor forState:UIControlStateNormal];
        [slider setThumbColor:disabledFillColor forState:UIControlStateDisabled];
    } else {
        slider.color = colorScheme.primaryColor;
        slider.disabledColor = disabledFillColor;
        slider.trackBackgroundColor = enabledBackgroundColor;
    }

    slider.valueLabelTextColor = colorScheme.onPrimaryColor;
    slider.valueLabelBackgroundColor = colorScheme.primaryColor;
}


@end
