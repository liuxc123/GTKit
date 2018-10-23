//
//  GTCSelfSizingStereoCellColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCSelfSizingStereoCell.h"
#import "GTColorScheme.h"

#import <Foundation/Foundation.h>

/**
 The Material Design color system's themer for instances of GTCSelfSizingStereoCellController.
 */
@interface GTCSelfSizingStereoCellColorThemer : NSObject

/**
 Applies a color scheme's properties to an GTCSelfSizingStereoCellController

 @param colorScheme The color scheme to apply to the component instance.
 @param cell A component instance to which the olor scheme should be applied.
 */
+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
          toSelfSizingStereoCell:(GTCSelfSizingStereoCell *)cell;

@end
