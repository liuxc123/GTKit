//
//  GTCBottomNavigationBarColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCBottomNavigationBarColorThemer.h"

static const CGFloat kUnselectedOpacity = 0.6f;

@implementation GTCBottomNavigationBarColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
              toBottomNavigation:(nonnull GTCBottomNavigationBar *)bottomNavigation {
    bottomNavigation.barTintColor = colorScheme.primaryColor;
    bottomNavigation.selectedItemTintColor = colorScheme.onPrimaryColor;
    CGFloat opacity = kUnselectedOpacity;
    bottomNavigation.unselectedItemTintColor =
    [colorScheme.onPrimaryColor colorWithAlphaComponent:opacity];
}

@end
