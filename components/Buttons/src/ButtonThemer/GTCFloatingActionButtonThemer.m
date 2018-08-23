//
//  GTCFloatingActionButtonThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCFloatingActionButtonThemer.h"

#import "GTButtons+ColorThemer.h"
#import "GTButtons+TypographyThemer.h"

@implementation GTCFloatingActionButtonThemer

+ (void)applyScheme:(nonnull id<GTCButtonScheming>)scheme
           toButton:(nonnull GTCFloatingButton *)button {
    [GTCFloatingButtonColorThemer applySemanticColorScheme:scheme.colorScheme toButton:button];
    [GTCButtonTypographyThemer applyTypographyScheme:scheme.typographyScheme toButton:button];
    [button setElevation:(CGFloat)6 forState:UIControlStateNormal];
    [button setElevation:(CGFloat)12 forState:UIControlStateHighlighted];
    [button setElevation:(CGFloat)0 forState:UIControlStateDisabled];
}

@end
