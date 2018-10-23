//
//  GTCButtonScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//
#import "GTColorScheme.h"
#import "GTShapeScheme.h"
#import "GTTypographyScheme.h"

#import <Foundation/Foundation.h>
/**
 GTCButtonScheming represents the design parameters for an GTCButton.

 An instance of this protocol can be applied to an instance of GTCButton using any of the
 GTC*ButtonThemer APIs.
 */
@protocol GTCButtonScheming

/**
 The color scheme to be applied to a button.
 */
@property(nonnull, readonly, nonatomic) id<GTCColorScheming> colorScheme;

/**
 The typography scheme to be applied to a button.
 */
@property(nonnull, readonly, nonatomic) id<GTCTypographyScheming> typographyScheme;

/**
 The corner radius to be applied to a button.
 */
@property(readonly, nonatomic) CGFloat cornerRadius;

/**
 The minimum height to be applied to a button.
 */
@property(readonly, nonatomic) CGFloat minimumHeight;

@end

/**
 An GTCButtonScheme is a mutable representation of the design parameters for an GTCButton.
 */
@interface GTCButtonScheme : NSObject <GTCButtonScheming>

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

/**
 A mutable representation of corner radius.

 By default, this is 4.
 */
@property(readwrite, nonatomic) CGFloat cornerRadius;

/**
 A mutable representation of minimum height.

 By default, this is 36.
 */
@property(readwrite, nonatomic) CGFloat minimumHeight;

@end
