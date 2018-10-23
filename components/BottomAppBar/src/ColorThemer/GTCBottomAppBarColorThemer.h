//
//  GTCBottomAppBarColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTBottomAppBar.h"
#import "GTColorScheme.h"

#import <Foundation/Foundation.h>

/**
 A color themer for GTCBottomAppBarView. This API does not fully implement the Material Design color
 system.

 */
@interface GTCBottomAppBarColorThemer : NSObject

/**
 Applies a color scheme to theme an GTCBottomAppBarView using the "surface" variant theming. The
 "surface" variant applies the @c surfaceColor of the color scheme as the @c barTintColor instead
 of @c primaryColor.

 @param colorScheme a color scheme to apply to the bottom app bar.
 @param bottomAppBarView the bottom app bar to theme.
 */
+ (void)applySurfaceVariantWithSemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                toBottomAppBarView:(nonnull GTCBottomAppBarView *)bottomAppBarView;

@end
