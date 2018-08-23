//
//  GTCButtonBarTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCButtonBarTypographyThemer.h"

@implementation GTCButtonBarTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                  toButtonBar:(nonnull GTCButtonBar *)buttonBar {
    NSUInteger maximumStateValue = UIControlStateNormal | UIControlStateSelected |
    UIControlStateHighlighted | UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [buttonBar setButtonsTitleFont:nil forState:state];
    }
    [buttonBar setButtonsTitleFont:typographyScheme.button forState:UIControlStateNormal];
}

@end
