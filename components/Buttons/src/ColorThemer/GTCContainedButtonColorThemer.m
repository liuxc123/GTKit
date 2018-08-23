//
//  GTCContainedButtonColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCContainedButtonColorThemer.h"

@implementation GTCContainedButtonColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toButton:(nonnull GTCButton *)button {
    [self resetUIControlStatesForButtonTheming:button];
    [button setBackgroundColor:colorScheme.primaryColor forState:UIControlStateNormal];
    [button setBackgroundColor:[colorScheme.onSurfaceColor colorWithAlphaComponent:0.12f]
                      forState:UIControlStateDisabled];
    [button setTitleColor:colorScheme.onPrimaryColor forState:UIControlStateNormal];
    [button setTitleColor:[colorScheme.onSurfaceColor colorWithAlphaComponent:0.38f]
                 forState:UIControlStateDisabled];
    [button setImageTintColor:colorScheme.onPrimaryColor forState:UIControlStateNormal];
    [button setImageTintColor:[colorScheme.onSurfaceColor colorWithAlphaComponent:0.38f]
                     forState:UIControlStateDisabled];
    button.disabledAlpha = 1.f;
    button.inkColor = [colorScheme.onPrimaryColor colorWithAlphaComponent:0.32f];
}

+ (void)resetUIControlStatesForButtonTheming:(nonnull GTCButton *)button {
    NSUInteger maximumStateValue = UIControlStateNormal | UIControlStateSelected |
    UIControlStateHighlighted | UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [button setBackgroundColor:nil forState:state];
        [button setTitleColor:nil forState:state];
        [button setImageTintColor:nil forState:state];
    }
}

@end
