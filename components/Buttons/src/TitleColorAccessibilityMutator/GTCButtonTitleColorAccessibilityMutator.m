//
//  GTCButtonTitleColorAccessibilityMutator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCButtonTitleColorAccessibilityMutator.h"

#import <GTFTextAccessibility/GTFTextAccessibility.h>
#import "GTButtons.h"
#import "GTTypography.h"

@implementation GTCButtonTitleColorAccessibilityMutator

+ (void)changeTitleColorOfButton:(GTCButton *)button {
    // This ensures title colors will be accessible against the buttons backgrounds.
    UIControlState allControlStates = UIControlStateNormal | UIControlStateHighlighted |
    UIControlStateDisabled | UIControlStateSelected;
    GTFTextAccessibilityOptions options = 0;
    if ([GTFTextAccessibility isLargeForContrastRatios:button.titleLabel.font]) {
        options = GTFTextAccessibilityOptionsLargeFont;
    }
    for (NSUInteger controlState = 0; controlState <= allControlStates; ++controlState) {
        UIColor *backgroundColor = [button backgroundColorForState:controlState];
        if ([self isTransparentColor:backgroundColor]) {
            // TODO(randallli): We could potentially traverse the view heirarchy instead.
            backgroundColor = button.underlyingColorHint;
        }
        if (backgroundColor) {
            UIColor *existingColor = [button titleColorForState:controlState];
            if (![GTFTextAccessibility textColor:existingColor
                         passesOnBackgroundColor:backgroundColor
                                         options:options]) {
                UIColor *color =
                [GTFTextAccessibility textColorOnBackgroundColor:backgroundColor
                                                 targetTextAlpha:[GTCTypography buttonFontOpacity]
                                                         options:options];
                [button setTitleColor:color forState:controlState];
            }
        }
    }
}

/** Returns YES if the color is transparent (including a nil color). */
+ (BOOL)isTransparentColor:(UIColor *)color {
    return !color || [color isEqual:[UIColor clearColor]] || CGColorGetAlpha(color.CGColor) == 0.0f;
}

@end
