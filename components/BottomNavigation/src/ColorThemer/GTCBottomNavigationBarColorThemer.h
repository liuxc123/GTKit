//
//  GTCBottomNavigationBarColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTColorScheme.h"
#import "GTBottomNavigation.h"

/**
 The Material Design color system's themer for instances of GTCBottomNavigationBar.
 */
@interface GTCBottomNavigationBarColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCBottomNavigationBar.

 @param colorScheme The color scheme to apply to the component instance.
 @param bottomNavigation A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
              toBottomNavigation:(nonnull GTCBottomNavigationBar *)bottomNavigation;

@end
