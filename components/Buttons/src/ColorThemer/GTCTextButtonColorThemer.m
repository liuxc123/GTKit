//
//  GTCTextButtonColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCTextButtonColorThemer.h"

@implementation GTCTextButtonColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toButton:(nonnull GTCButton *)button {
    [self resetUIControlStatesForButtonTheming:button];
    [button setBackgroundColor:UIColor.clearColor forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.clearColor forState:UIControlStateDisabled];
    [button setTitleColor:colorScheme.primaryColor forState:UIControlStateNormal];
    [button setTitleColor:[colorScheme.onSurfaceColor colorWithAlphaComponent:0.38f]
                 forState:UIControlStateDisabled];
    [button setImageTintColor:colorScheme.primaryColor forState:UIControlStateNormal];
    [button setImageTintColor:[colorScheme.onSurfaceColor colorWithAlphaComponent:0.38f]
                     forState:UIControlStateDisabled];
    button.disabledAlpha = 1.f;
    button.inkColor = [colorScheme.primaryColor colorWithAlphaComponent:0.16f];
}

+ (void)resetUIControlStatesForButtonTheming:(nonnull GTCButton *)button {
    NSUInteger maximumStateValue = UIControlStateNormal | UIControlStateSelected |
    UIControlStateHighlighted | UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [button setBackgroundColor:nil forState:state];
        [button setTitleColor:nil forState:state];
    }
}
@end
