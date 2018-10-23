//
//  GTCChipViewTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTChips.h"
#import "GTTypographyScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design typography system's themer for instances of GTCChipView.
 */
@interface GTCChipViewTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCChipView.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param chipView A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                   toChipView:(nonnull GTCChipView *)chipView;

@end
