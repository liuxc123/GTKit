//
//  GTCButtonBarColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTButtonBar.h"
#import "GTColorScheme.h"

/**
 The Material Design color system's themer for instances of GTCButtonBar.
 */
@interface GTCButtonBarColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCButtonBar.

 @param colorScheme The color scheme to apply to the component instance.
 @param buttonBar A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                     toButtonBar:(nonnull GTCButtonBar *)buttonBar;

@end
