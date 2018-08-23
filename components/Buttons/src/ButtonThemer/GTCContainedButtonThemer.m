//
//  GTCContainedButtonThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCContainedButtonThemer.h"

#import "GTButtons+ColorThemer.h"
#import "GTButtons+TypographyThemer.h"

@implementation GTCContainedButtonThemer

+ (void)applyScheme:(nonnull id<GTCButtonScheming>)scheme
           toButton:(nonnull GTCButton *)button {
    [GTCContainedButtonColorThemer applySemanticColorScheme:scheme.colorScheme toButton:button];
    [GTCButtonTypographyThemer applyTypographyScheme:scheme.typographyScheme toButton:button];
    button.minimumSize = CGSizeMake(0, scheme.minimumHeight);
    button.layer.cornerRadius = scheme.cornerRadius;
    [button setElevation:(CGFloat)2 forState:UIControlStateNormal];
    [button setElevation:(CGFloat)8 forState:UIControlStateHighlighted];
    [button setElevation:(CGFloat)0 forState:UIControlStateDisabled];
}

@end
