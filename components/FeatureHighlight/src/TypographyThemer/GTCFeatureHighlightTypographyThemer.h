//
//  GTCFeatureHighlightTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

#import "GTFeatureHighlight.h"
#import "GTTypographyScheme.h"

/**
 The Material Design typography system's themer for instances of GTCFeatureHighlightViewController.
 */
@interface GTCFeatureHighlightTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCFeatureHighlightViewController.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param featureHighlightViewController A component instance to which the typography scheme should be
 applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
toFeatureHighlightViewController:
(nonnull GTCFeatureHighlightViewController *)featureHighlightViewController;

@end
