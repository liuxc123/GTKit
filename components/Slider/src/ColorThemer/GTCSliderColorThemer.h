//
//  GTCSliderColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTColorScheme.h"
#import "GTSlider.h"

#import <Foundation/Foundation.h>

/**
 The Material Design color system's themer for instances of GTCSlider.
 */
@interface GTCSliderColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCSlider.

 @param colorScheme The color scheme to apply to the component instance.
 @param slider A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toSlider:(nonnull GTCSlider *)slider;
@end
