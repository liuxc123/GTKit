//
//  GTCButtonTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTButtons.h"
#import "GTTypographyScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design typography system's themer for instances of GTCButton.
 */
@interface GTCButtonTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCButton.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param button A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                     toButton:(nonnull GTCButton *)button;

@end
