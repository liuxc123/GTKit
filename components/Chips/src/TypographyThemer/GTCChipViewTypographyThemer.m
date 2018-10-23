//
//  GTCChipViewTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipViewTypographyThemer.h"

@implementation GTCChipViewTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                   toChipView:(nonnull GTCChipView *)chipView {
    chipView.titleFont = typographyScheme.body2;
}

@end
