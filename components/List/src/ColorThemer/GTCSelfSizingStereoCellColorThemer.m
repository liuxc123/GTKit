//
//  GTCSelfSizingStereoCellColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCSelfSizingStereoCellColorThemer.h"

static const CGFloat kHighAlpha = 0.87f;
static const CGFloat kInkAlpha = 0.16f;

@implementation GTCSelfSizingStereoCellColorThemer

+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
          toSelfSizingStereoCell:(GTCSelfSizingStereoCell *)cell {
    cell.titleLabel.textColor = colorScheme.onSurfaceColor;
    cell.detailLabel.textColor = colorScheme.onSurfaceColor;
    cell.leadingImageView.tintColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:kHighAlpha];
    cell.trailingImageView.tintColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kHighAlpha];
    cell.inkColor = [colorScheme.onSurfaceColor colorWithAlphaComponent:kInkAlpha];
}

@end
