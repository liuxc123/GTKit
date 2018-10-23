//
//  GTCFeatureHighlightTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightTypographyThemer.h"

@implementation GTCFeatureHighlightTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
toFeatureHighlightViewController:
(nonnull GTCFeatureHighlightViewController *)featureHighlightViewController {
    featureHighlightViewController.titleFont = typographyScheme.headline6;
    featureHighlightViewController.bodyFont = typographyScheme.body2;
}

@end
