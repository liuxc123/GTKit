//
//  GTCSelfSizingStereoCellTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCSelfSizingStereoCellTypographyThemer.h"

@implementation GTCSelfSizingStereoCellTypographyThemer

+ (void)applyTypographyScheme:(id<GTCTypographyScheming>)typographyScheme
       toSelfSizingStereoCell:(GTCSelfSizingStereoCell *)cell {
    cell.titleLabel.font = typographyScheme.subtitle1;
    cell.detailLabel.font = typographyScheme.body2;
}

@end
