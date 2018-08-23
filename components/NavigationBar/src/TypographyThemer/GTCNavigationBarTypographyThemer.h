//
//  GTCNavigationBarTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTNavigationBar.h"
#import "GTTypographyScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design typography system's themer for instances of GTCNavigationBar.
 */
@interface GTCNavigationBarTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCNavigationBar.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param navigationBar A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
              toNavigationBar:(nonnull GTCNavigationBar *)navigationBar;

@end
