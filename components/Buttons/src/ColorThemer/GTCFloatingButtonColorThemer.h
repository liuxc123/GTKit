//
//  GTCFloatingButtonColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTButtons.h"
#import "GTColorScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design color system's contained button themer for instances of GTCButton.
 */
@interface GTCFloatingButtonColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCFloatingButton using the floating button style.

 @param colorScheme The color scheme to apply to the component instance.
 @param button A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                        toButton:(nonnull GTCFloatingButton *)button;

@end
