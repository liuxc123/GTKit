//
//  GTCRoundedCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A rounded corner treatment.
 */
@interface GTCRoundedCornerTreatment : GTCCornerTreatment

/**
 The radius of the corner.
 */
@property(nonatomic, assign) CGFloat radius;

/**
 Initializes an GTCRoundedCornerTreatment instance with a given radius.
 */
- (nonnull instancetype)initWithRadius:(CGFloat)radius NS_DESIGNATED_INITIALIZER;

/**
 Initializes an GTCRoundedCornerTreatment instance with a radius of zero.
 */
- (nonnull instancetype)init;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

