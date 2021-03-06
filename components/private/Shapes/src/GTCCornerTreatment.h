//
//  GTCCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

@class GTCPathGenerator;

/**
 This enum consists of the different types of shape values that can be provided.

 - GTCCornerTreatmentValueTypeAbsolute: If an absolute corner value is provided.
 - GTCCornerTreatmentValueTypePercentage: If a relative corner value is provided.

 See GTCShapeCorner's @c size property for additional details.
 */
typedef NS_ENUM(NSInteger, GTCCornerTreatmentValueType) {
    GTCCornerTreatmentValueTypeAbsolute,
    GTCCornerTreatmentValueTypePercentage,
};

/**
 GTCCornerTreatment is a factory for creating GTCPathGenerators that represent
 the path of a corner.

 GTCCornerTreatments should only generate corners in the top-left quadrant (i.e.
 the top-left corner of a rectangle). GTCShapeModel will translate the generated
 GTCPathGenerator to the expected position and rotation.
 */
@interface GTCCornerTreatment : NSObject <NSCopying, NSSecureCoding>

/**
 The value type of our corner treatment.

 When GTCCornerTreatmentValueType is GTCCornerTreatmentValueTypeAbsolute, then the accepted corner
 values are an absolute size.
 When GTCShapeSizeType is GTCCornerTreatmentValueTypePercentage, values are expected to be in the
 range of 0 to 1 (0% - 100%). These values are percentages based on the height of the surface.
 */
@property(assign, nonatomic) GTCCornerTreatmentValueType valueType;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Creates an GTCPathGenerator object for a corner with the provided angle.

 @param angle The internal angle of the corner in radians. Typically M_PI/2.
 */
- (nonnull GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle;

/**
 Creates an GTCPathGenerator object for a corner with the provided angle.
 Given that the provided valueType is GTCCornerTreatmentValueTypePercentage, we also need
 the size of the view to calculate the corner size percentage relative to the view height.

 @param angle the internal angle of the corner in radius. Typically M_PI/2.
 @param size the size of the view.
 @return returns an GTCPathGenerator.
 */
- (nonnull GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle
                                                  forViewSize:(CGSize)size;


@end

