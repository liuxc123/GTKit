//
//  GTCNavigationBarColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTColorScheme.h"
#import "GTNavigationBar.h"

#import <Foundation/Foundation.h>

/**
 The Material Design color system's themer for instances of GTCNavigationBar.
 */
@interface GTCNavigationBarColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCNavigationBar using the primary mapping.

 Uses the primary color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param navigationBar A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                 toNavigationBar:(nonnull GTCNavigationBar *)navigationBar;

/**
 Applies a color scheme's properties to an GTCNavigationBar using the surface mapping.

 Uses the surface color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param navigationBar A component instance to which the color scheme should be applied.
 */
+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                           toNavigationBar:(nonnull GTCNavigationBar *)navigationBar;
@end
