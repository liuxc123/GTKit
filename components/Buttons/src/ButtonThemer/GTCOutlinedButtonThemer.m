//
//  GTCOutlinedButtonThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCOutlinedButtonThemer.h"

#import "GTButtons+ColorThemer.h"
#import "GTButtons+TypographyThemer.h"

@implementation GTCOutlinedButtonThemer

+ (void)applyScheme:(nonnull id<GTCButtonScheming>)scheme
           toButton:(nonnull GTCButton *)button {
    [GTCOutlinedButtonColorThemer applySemanticColorScheme:scheme.colorScheme toButton:button];
    [GTCButtonTypographyThemer applyTypographyScheme:scheme.typographyScheme toButton:button];
    button.minimumSize = CGSizeMake(0, scheme.minimumHeight);
    button.layer.cornerRadius = scheme.cornerRadius;

    NSUInteger maximumStateValue =
    UIControlStateNormal | UIControlStateSelected | UIControlStateHighlighted |
    UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [button setBorderWidth:1.f forState:state];
    }
}

@end
