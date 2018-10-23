//
//  GTCTabBarColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCTabBarColorThemer.h"

static const CGFloat kUnselectedTitleOpacity = 0.6f;
static const CGFloat kUnselectedImageOpacity = 0.54f;
static const CGFloat kBottomDividerOpacity = 0.12f;

@implementation GTCTabBarColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                          toTabs:(nonnull GTCTabBar *)tabBar {
    tabBar.barTintColor = colorScheme.primaryColor;
    tabBar.tintColor = colorScheme.onPrimaryColor;
    [tabBar setTitleColor:colorScheme.onPrimaryColor forState:GTCTabBarItemStateSelected];
    [tabBar setImageTintColor:colorScheme.onPrimaryColor forState:GTCTabBarItemStateSelected];
    UIColor *unselectedTitleColor =
    [colorScheme.onPrimaryColor colorWithAlphaComponent:kUnselectedTitleOpacity];
    UIColor *unselectedImageColor =
    [colorScheme.onPrimaryColor colorWithAlphaComponent:kUnselectedImageOpacity];
    [tabBar setTitleColor:unselectedTitleColor forState:GTCTabBarItemStateNormal];
    [tabBar setImageTintColor:unselectedImageColor forState:GTCTabBarItemStateNormal];
    tabBar.bottomDividerColor =
    [colorScheme.onPrimaryColor colorWithAlphaComponent:kBottomDividerOpacity];
}

+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                    toTabs:(nonnull GTCTabBar *)tabBar {
    tabBar.barTintColor = colorScheme.surfaceColor;
    tabBar.tintColor = colorScheme.primaryColor;
    [tabBar setTitleColor:colorScheme.primaryColor forState:GTCTabBarItemStateSelected];
    [tabBar setImageTintColor:colorScheme.primaryColor forState:GTCTabBarItemStateSelected];
    UIColor *unselectedTitleColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kUnselectedTitleOpacity];
    UIColor *unselectedImageColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kUnselectedImageOpacity];
    [tabBar setTitleColor:unselectedTitleColor forState:GTCTabBarItemStateNormal];
    [tabBar setImageTintColor:unselectedImageColor forState:GTCTabBarItemStateNormal];
    tabBar.bottomDividerColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kBottomDividerOpacity];
}

@end
