//
//  GTCFloatingButtonColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCFloatingButtonColorThemer.h"

@implementation GTCFloatingButtonColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toButton:(nonnull GTCFloatingButton *)button {
    [self resetUIControlStatesForButtonTheming:button];
    [button setBackgroundColor:colorScheme.secondaryColor forState:UIControlStateNormal];
    [button setImageTintColor:colorScheme.onSecondaryColor forState:UIControlStateNormal];

    button.disabledAlpha = 1.f;
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
