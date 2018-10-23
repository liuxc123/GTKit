//
//  GTCBottomNavigationBarTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTBottomNavigation.h"
#import "GTTypographyScheme.h"

/**
 The Material Design typography system's themer for instances of GTCBottomNavigationBar.
 */
@interface GTCBottomNavigationBarTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCBottomNavigationBar.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param bottomNavigationBar A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
        toBottomNavigationBar:(nonnull GTCBottomNavigationBar *)bottomNavigationBar;

@end
