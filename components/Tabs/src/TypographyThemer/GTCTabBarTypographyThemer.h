//
//  GTCTabBarTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTTabs.h"
#import "GTTypographyScheme.h"

/**
 The Material Design typography system's themer for instances of GTCTabBar.
 */
@interface GTCTabBarTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCTabBar.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param tabBar A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                     toTabBar:(nonnull GTCTabBar *)tabBar;

@end
