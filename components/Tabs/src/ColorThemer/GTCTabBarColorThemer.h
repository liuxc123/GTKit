//
//  GTCTabBarColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTColorScheme.h"
#import "GTTabs.h"

/**
 The Material Design color system's themer for instances of GTCTabBar.
 */
@interface GTCTabBarColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCTabBar using the primary mapping.

 Uses the primary color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param tabBar A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                          toTabs:(nonnull GTCTabBar *)tabBar;

/**
 Applies a color scheme's properties to an GTCTabBar using the surface mapping.

 Uses the surface color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param tabBar A component instance to which the color scheme should be applied.
 */
+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                    toTabs:(nonnull GTCTabBar *)tabBar;

@end
