//
//  GTCBottomAppBarColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCBottomAppBarColorThemer.h"

#import "GTBottomAppBar.h"
#import "GTThemes.h"

@implementation GTCBottomAppBarColorThemer

+ (void)applySurfaceVariantWithSemanticColorScheme:(id<GTCColorScheming>)colorScheme
                                toBottomAppBarView:(GTCBottomAppBarView *)bottomAppBarView {
    [self resetUIStatesForTheming:bottomAppBarView.floatingButton];

    bottomAppBarView.barTintColor = colorScheme.surfaceColor;
    UIColor *barItemTintColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:(CGFloat)0.6];
    bottomAppBarView.leadingBarItemsTintColor = barItemTintColor;
    bottomAppBarView.trailingBarItemsTintColor = barItemTintColor;
    [bottomAppBarView.floatingButton setBackgroundColor:colorScheme.primaryColor
                                               forState:UIControlStateNormal];
    [bottomAppBarView.floatingButton setTitleColor:colorScheme.onPrimaryColor
                                          forState:UIControlStateNormal];
    [bottomAppBarView.floatingButton setImageTintColor:colorScheme.onPrimaryColor
                                              forState:UIControlStateNormal];
}

#pragma mark - Utility methods

+ (void)resetUIStatesForTheming:(GTCButton *)button {
    UIControlState maxState = UIControlStateNormal | UIControlStateHighlighted |
    UIControlStateDisabled | UIControlStateSelected;
    for (UIControlState state = 0; state <= maxState; ++state) {
        [button setImageTintColor:nil forState:state];
        [button setTitleColor:nil forState:state];
        [button setBackgroundColor:nil forState:state];
    }
}


@end
