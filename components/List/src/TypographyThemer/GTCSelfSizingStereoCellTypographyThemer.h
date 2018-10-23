//
//  GTCSelfSizingStereoCellTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCSelfSizingStereoCell.h"
#import "GTTypographyScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design typography system's themer for instances of
 GTCSelfSizingStereoCellTypographyThemer.
 */
@interface GTCSelfSizingStereoCellTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to an GTCSelfSizingStereoCell.

 @param typographyScheme The typography scheme to apply to the component instance.
 @param cell A component instance to which the typography scheme should be applied.
 */
+ (void)applyTypographyScheme:(id<GTCTypographyScheming>)typographyScheme
       toSelfSizingStereoCell:(GTCSelfSizingStereoCell *)cell;

@end
