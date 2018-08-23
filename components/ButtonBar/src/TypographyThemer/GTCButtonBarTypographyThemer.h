//
//  GTCButtonBarTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTButtonBar.h"
#import "GTTypographyScheme.h"

/**
 The Material Design typography system's themer for instances of GTCButtonBar.
 */
@interface GTCButtonBarTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCButtonBar.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param buttonBar A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                  toButtonBar:(nonnull GTCButtonBar *)buttonBar;

@end
