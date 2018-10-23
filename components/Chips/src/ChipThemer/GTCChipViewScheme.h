//
//  GTCChipViewScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTChips.h"
#import "GTColorScheme.h"
#import "GTShapeScheme.h"
#import "GTTypographyScheme.h"

#import <Foundation/Foundation.h>

/**
 GTCChipViewScheming represents the design parameters for an GTCChipView.

 An instance of this protocol can be applied to an instance of GTCChipView using any of the
 GTCChipViewThemer APIs.
 */
@protocol GTCChipViewScheming

/**
 The color scheme to apply to a chip view.
 */
@property(nonnull, readonly, nonatomic) id<GTCColorScheming> colorScheme;

/**
 The shape scheme to apply to a chip view.
 */
@property(nonnull, readonly, nonatomic) id<GTCShapeScheming> shapeScheme;

/**
 The typography scheme to apply to a chip view.
 */
@property(nonnull, readonly, nonatomic) id<GTCTypographyScheming> typographyScheme;

@end

/**
 An GTCChipViewScheme is a mutable representation of the design parameters for an GTCChipView.
 */
@interface GTCChipViewScheme : NSObject <GTCChipViewScheming>

/**
 A mutable representation of a color scheme.

 By default, this is initialized with the latest color scheme defaults.
 */
@property(nonnull, readwrite, nonatomic) id<GTCColorScheming> colorScheme;

/**
 A mutable representation of a shape scheme.

 By default, this is initialized with the latest shape scheme defaults.
 */
@property(nonnull, readwrite, nonatomic) id<GTCShapeScheming> shapeScheme;

/**
 A mutable representation of a typography scheme.

 By default, this is initialized with the latest typography scheme defaults.
 */
@property(nonnull, readwrite, nonatomic) id<GTCTypographyScheming> typographyScheme;

@end

