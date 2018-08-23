//
//  GTCButtonBarColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCButtonBarColorThemer.h"

@implementation GTCButtonBarColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                     toButtonBar:(nonnull GTCButtonBar *)buttonBar {
    buttonBar.backgroundColor = colorScheme.primaryColor;
    buttonBar.tintColor = colorScheme.onPrimaryColor;
}

@end
