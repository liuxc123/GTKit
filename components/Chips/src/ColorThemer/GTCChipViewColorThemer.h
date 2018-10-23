//
//  GTCChipViewColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTChips.h"
#import "GTColorScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design color system's themer for instances of GTCChipView.
 */
@interface GTCChipViewColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCChipView.

 @param colorScheme The color scheme to apply to the component instance.
 @param chipView A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                      toChipView:(nonnull GTCChipView *)chipView;

/**
 Applies a color scheme's properties to the component instance with the outlined style.

 @param colorScheme The color scheme to apply to the component instance.
 @param chipView @c A component instance to which the color scheme should be applied.
 */
+ (void)applyOutlinedVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                 toChipView:(nonnull GTCChipView *)chipView;

@end
