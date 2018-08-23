//
//  GTCButtonTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCButtonTypographyThemer.h"

@implementation GTCButtonTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                     toButton:(nonnull GTCButton *)button {
    NSUInteger maximumStateValue = UIControlStateNormal | UIControlStateSelected |
    UIControlStateHighlighted | UIControlStateDisabled;
    for (NSUInteger state = 0; state <= maximumStateValue; ++state) {
        [button setTitleFont:nil forState:state];
    }
    [button setTitleFont:typographyScheme.button forState:UIControlStateNormal];
}

@end
