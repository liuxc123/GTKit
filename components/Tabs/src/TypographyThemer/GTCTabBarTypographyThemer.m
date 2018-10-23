//
//  GTCTabBarTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCTabBarTypographyThemer.h"

@implementation GTCTabBarTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                     toTabBar:(nonnull GTCTabBar *)tabBar {
    tabBar.selectedItemTitleFont = typographyScheme.button;
    tabBar.unselectedItemTitleFont = typographyScheme.button;
}

@end
