//
//  GTCProgressViewColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCProgressViewColorThemer.h"

static const CGFloat kProgressViewBaselineEnabledBackgroundAlpha = 0.24f;

@implementation GTCProgressViewColorThemer

+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme toProgressView:(GTCProgressView *)progressView
{
    UIColor *enabledBackgroundColor =
    [colorScheme.primaryColor colorWithAlphaComponent:kProgressViewBaselineEnabledBackgroundAlpha];
    progressView.trackTintColor = enabledBackgroundColor;
    progressView.progressTintColor = colorScheme.primaryColor;

}

@end
