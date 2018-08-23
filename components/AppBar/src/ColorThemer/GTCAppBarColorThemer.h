//
//  GTCAppBarColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTAppBar.h"
#import "GTColorScheme.h"

/**
 The Material Design color system's themer for instances of GTCAppBar.
 */
@interface GTCAppBarColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCAppBarViewController instance using the primary
 mapping.

 Uses the primary color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param appBarViewController A component instance to which the color scheme should be applied.
 */
+ (void)applyColorScheme:(nonnull id<GTCColorScheming>)colorScheme
  toAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController;

/**
 Applies a color scheme's properties to an GTCAppBarViewController instance using the surface
 mapping.

 Uses the surface color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param appBarViewController A component instance to which the color scheme should be applied.
 */
+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                    toAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController;

/**
 Applies a color scheme's properties to an GTCAppBar using the primary mapping.

 Uses the primary color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param appBar A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toAppBar:(nonnull GTCAppBar *)appBar;

/**
 Applies a color scheme's properties to an GTCAppBar using the surface mapping.

 Uses the surface color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param appBar A component instance to which the color scheme should be applied.
 */
+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                  toAppBar:(nonnull GTCAppBar *)appBar;

@end

