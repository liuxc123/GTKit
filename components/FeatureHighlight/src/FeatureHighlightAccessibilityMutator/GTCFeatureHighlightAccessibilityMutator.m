//
//  GTCFeatureHighlightAccessibilityMutator.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightAccessibilityMutator.h"

#import "GTFeatureHighlight.h"
#import "GTTypography.h"

@implementation GTCFeatureHighlightAccessibilityMutator


+ (void)mutate:(GTCFeatureHighlightViewController *)featureHighlightViewController {
    [GTCFeatureHighlightAccessibilityMutator mutateTitleColor:featureHighlightViewController];
    [GTCFeatureHighlightAccessibilityMutator mutateBodyColor:featureHighlightViewController];
}

+ (void)mutateTitleColor:(GTCFeatureHighlightViewController *)featureHighlightViewController{
    GTFTextAccessibilityOptions options = GTFTextAccessibilityOptionsPreferLighter;
    if ([GTFTextAccessibility isLargeForContrastRatios:featureHighlightViewController.titleFont]) {
        options |= GTFTextAccessibilityOptionsLargeFont;
    }

    UIColor *textColor = featureHighlightViewController.titleColor;
    UIColor *backgroundColor =
    [featureHighlightViewController.outerHighlightColor colorWithAlphaComponent:1.0f];
    UIColor *titleColor =
    [GTCFeatureHighlightAccessibilityMutator accessibleColorForTextColor:textColor
                                                     withBackgroundColor:backgroundColor
                                                                 options:options];
    // no change needed.
    if ([titleColor isEqual:textColor]) {
        return;
    }

    // Make title alpha the maximum it can be.
    CGFloat titleAlpha =
    [GTFTextAccessibility minAlphaOfTextColor:titleColor
                            onBackgroundColor:backgroundColor
                                      options:options];
    titleAlpha = MAX([GTCTypography titleFontOpacity], titleAlpha);
    featureHighlightViewController.titleColor = [titleColor colorWithAlphaComponent:titleAlpha];
}

+ (void)mutateBodyColor:(GTCFeatureHighlightViewController *)featureHighlightViewController {
    GTFTextAccessibilityOptions options = GTFTextAccessibilityOptionsPreferLighter;
    if ([GTFTextAccessibility isLargeForContrastRatios:featureHighlightViewController.bodyFont]) {
        options |= GTFTextAccessibilityOptionsLargeFont;
    }

    UIColor *textColor = featureHighlightViewController.bodyColor;
    UIColor *backgroundColor =
    [featureHighlightViewController.outerHighlightColor colorWithAlphaComponent:1.0f];
    featureHighlightViewController.bodyColor =
    [GTCFeatureHighlightAccessibilityMutator accessibleColorForTextColor:textColor
                                                     withBackgroundColor:backgroundColor
                                                                 options:options];
}

#pragma mark - Private

+ (UIColor *)accessibleColorForTextColor:(UIColor *)textColor
                     withBackgroundColor:(UIColor *)backgroundColor
                                 options:(GTFTextAccessibilityOptions)options {
    if (textColor && [GTFTextAccessibility textColor:textColor
                             passesOnBackgroundColor:backgroundColor
                                             options:options]) {
        return textColor;
    }
    return [GTFTextAccessibility textColorOnBackgroundColor:backgroundColor
                                            targetTextAlpha:[GTCTypography captionFontOpacity]
                                                    options:options];
}

@end

