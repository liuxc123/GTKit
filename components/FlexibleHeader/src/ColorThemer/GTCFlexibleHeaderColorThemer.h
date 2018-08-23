//
//  GTCFlexibleHeaderColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTColorScheme.h"
#import "GTFlexibleHeader.h"

#import <Foundation/Foundation.h>

/**
 The Material Design color system's themer for instances of GTCFlexibleHeaderView.
 */
@interface GTCFlexibleHeaderColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCFlexibleHeaderView using the primary mapping.

 Uses the primary color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param flexibleHeaderView A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
            toFlexibleHeaderView:(nonnull GTCFlexibleHeaderView *)flexibleHeaderView;

/**
 Applies a color scheme's properties to an GTCFlexibleHeaderView using the surface mapping.

 Uses the surface color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param flexibleHeaderView A component instance to which the color scheme should be applied.
 */
+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                      toFlexibleHeaderView:(nonnull GTCFlexibleHeaderView *)flexibleHeaderView;

@end

