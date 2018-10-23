//
//  GTCChipViewThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipViewScheme.h"

#import "GTChips.h"

#import <Foundation/Foundation.h>

/**
 The Material Design themer for instances of GTCChipView.
 */
@interface GTCChipViewThemer : NSObject

/**
 Applies a chip view scheme's properties to an GTCChipView.

 @param scheme The chip view scheme to apply to the component instance.
 @param chip A component instance to which the scheme should be applied.
 */
+ (void)applyScheme:(nonnull id<GTCChipViewScheming>)scheme
         toChipView:(nonnull GTCChipView *)chip;

/**
 Applies a chip view scheme's properties to an GTCChipView using the outlined style.

 @param scheme The chip view scheme to apply to the component instance.
 @param chip A component instance to which the scheme should be applied.
 */
+ (void)applyOutlinedVariantWithScheme:(nonnull id<GTCChipViewScheming>)scheme
                            toChipView:(nonnull GTCChipView *)chip;

@end

