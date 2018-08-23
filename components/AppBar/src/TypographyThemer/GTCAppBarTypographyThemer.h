//
//  GTCAppBarTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTAppBar.h"
#import "GTTypographyScheme.h"

/**
 The Material Design typography system's themer for instances of GTCAppBar.
 */
@interface GTCAppBarTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCAppBar.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param appBarViewController A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
       toAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController;

@end
