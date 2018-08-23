//
//  GTCNavigationBarColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCNavigationBarColorThemer.h"

@implementation GTCNavigationBarColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                 toNavigationBar:(nonnull GTCNavigationBar *)navigationBar {
    navigationBar.backgroundColor = colorScheme.primaryColor;
    navigationBar.titleTextColor = colorScheme.onPrimaryColor;
    navigationBar.tintColor = colorScheme.onPrimaryColor;
}

+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                           toNavigationBar:(nonnull GTCNavigationBar *)navigationBar {
    [self resetUIControlStatesForNavigationBar:navigationBar];

    navigationBar.backgroundColor = colorScheme.surfaceColor;
    // Note that we must set the tint color before setting the buttons title color. Otherwise the
    // button title colors will be set with the tint color.
    navigationBar.tintColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.54];
    navigationBar.titleTextColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.87];
    [navigationBar setButtonsTitleColor:navigationBar.titleTextColor forState:UIControlStateNormal];
}

+ (void)resetUIControlStatesForNavigationBar:(nonnull GTCNavigationBar *)navigationBar {
    NSUInteger maximumStateValue = (UIControlStateNormal | UIControlStateSelected |
                                    UIControlStateHighlighted | UIControlStateDisabled);
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [navigationBar setButtonsTitleColor:nil forState:state];
    }
}
@end
