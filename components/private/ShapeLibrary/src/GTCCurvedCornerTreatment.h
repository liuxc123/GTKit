//
//  GTCCurvedCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A curved corner treatment. Distinct from GTCRoundedCornerTreatment in that GTCurvedCornerTreatment
 also supports asymmetric curved corners.
 */
@interface GTCCurvedCornerTreatment : GTCCornerTreatment

/**
 The size of the curve.
 */
@property(nonatomic, assign) CGSize size;

/**
 Initializes an GTCCurvedCornerTreatment instance with a given corner size.
 */
- (nonnull instancetype)initWithSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

/**
 Initializes an GTCCurvedCornerTreatment instance with a corner size of zero.
 */
- (nonnull instancetype)init;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

