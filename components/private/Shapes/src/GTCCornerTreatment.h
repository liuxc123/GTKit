//
//  GTCCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

@class GTCPathGenerator;

/**
 GTCCornerTreatment is a factory for creating GTCPathGenerators that represent
 the path of a corner.

 GTCCornerTreatments should only generate corners in the top-left quadrant (i.e.
 the top-left corner of a rectangle). GTCShapeModel will translate the generated
 GTCPathGenerator to the expected position and rotation.
 */
@interface GTCCornerTreatment : NSObject <NSCopying, NSSecureCoding>

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Generates an GTCPathGenerator object for a corner with the provided angle.

 @param angle The internal angle of the corner in radians. Typically M_PI/2.
 */
- (nonnull GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle;

@end

