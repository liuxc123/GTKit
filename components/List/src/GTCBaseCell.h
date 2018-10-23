//
//  GTCBaseCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import <UIKit/UIKit.h>

#import "GTShadowElevations.h"

@interface GTCBaseCell : UICollectionViewCell

/**
 The current elevation of the cell.
 */
@property (nonatomic, assign) GTCShadowElevation elevation;

/**
 The color of the cell’s underlying Ripple.
 */
@property (nonatomic, strong, nonnull) UIColor *inkColor;

@end
