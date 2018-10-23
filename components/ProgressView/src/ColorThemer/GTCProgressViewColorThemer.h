//
//  GTCProgressViewColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTColorScheme.h"
#import "GTProgressView.h"

#import <Foundation/Foundation.h>

/**
 Used to apply a color scheme to theme MDCProgressView. This API does not yet implement the Material
 Design color system.
 */
@interface GTCProgressViewColorThemer : NSObject


/**
 Applies a color scheme's properties to an GTCProgressView using the primary mapping.

 Uses the primary color as the most important color for the component.

 @param colorScheme The color scheme to apply to the component instance.
 @param progressView A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                          toProgressView:(nonnull GTCProgressView *)progressView;

@end
