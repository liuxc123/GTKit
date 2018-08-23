//
//  GTCOutlinedButtonColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCOutlinedButtonColorThemer.h"

@implementation GTCOutlinedButtonColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toButton:(nonnull GTCButton *)button {
    [self resetUIControlStatesForButtonTheming:button];
    [button setBackgroundColor:UIColor.clearColor forState:UIControlStateNormal];
    [button setTitleColor:colorScheme.primaryColor forState:UIControlStateNormal];
    [button setTitleColor:[colorScheme.onSurfaceColor colorWithAlphaComponent:0.38f]
                 forState:UIControlStateDisabled];
    button.disabledAlpha = 1.f;
    button.inkColor = [colorScheme.primaryColor colorWithAlphaComponent:0.16f];
    UIColor *borderColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.12f];
    [button setBorderColor:borderColor forState:UIControlStateNormal];
}

+ (void)resetUIControlStatesForButtonTheming:(nonnull GTCButton *)button {
    NSUInteger maximumStateValue = UIControlStateNormal | UIControlStateSelected |
    UIControlStateHighlighted | UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [button setBackgroundColor:nil forState:state];
        [button setTitleColor:nil forState:state];
        [button setBorderColor:nil forState:state];
    }
}

@end
