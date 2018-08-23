//
//  GTCTextButtonThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCTextButtonThemer.h"

#import "GTButtons+ColorThemer.h"
#import "GTButtons+TypographyThemer.h"

@implementation GTCTextButtonThemer

+ (void)applyScheme:(nonnull id<GTCButtonScheming>)scheme
           toButton:(nonnull GTCButton *)button {
    [GTCTextButtonColorThemer applySemanticColorScheme:scheme.colorScheme toButton:button];
    [GTCButtonTypographyThemer applyTypographyScheme:scheme.typographyScheme toButton:button];
    button.minimumSize = CGSizeMake(0, scheme.minimumHeight);
    button.layer.cornerRadius = scheme.cornerRadius;
}

@end
