//
//  GTCFeatureHighlightColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightColorThemer.h"

@implementation GTCFeatureHighlightColorThemer

+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
toFeatureHighlightViewController:
(GTCFeatureHighlightViewController *)featureHighlightViewController {
    featureHighlightViewController.innerHighlightColor = colorScheme.surfaceColor;
    featureHighlightViewController.outerHighlightColor = colorScheme.primaryColor;
    featureHighlightViewController.titleColor = colorScheme.onPrimaryColor;
    featureHighlightViewController.bodyColor = colorScheme.onPrimaryColor;
}


@end
