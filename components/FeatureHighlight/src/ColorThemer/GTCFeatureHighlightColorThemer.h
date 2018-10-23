//
//  GTCFeatureHighlightColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

#import "GTFeatureHighlight.h"
#import "GTThemes.h"

/**
 The Material Design color system's themer for instances of GTCFeatureHighlightViewController.
 */
@interface GTCFeatureHighlightColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCFeatureHighlightViewController.

 @param colorScheme The color scheme to apply to the component instance.
 @param featureHighlightViewController A component instance to which the color scheme should be
 applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
toFeatureHighlightViewController:
(nonnull GTCFeatureHighlightViewController *)featureHighlightViewController;

@end


