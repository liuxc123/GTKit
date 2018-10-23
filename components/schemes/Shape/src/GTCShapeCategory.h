//
//  GTCShapeCategory.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <Foundation/Foundation.h>
#import "GTShapes.h"

/**
 This enum consists of the different types of shape corners.

 - GTCShapeCornerFamilyRounded: A rounded corner.
 - GTCShapeCornerFamilyAngled: An angled/cut corner.
 */
typedef NS_ENUM(NSInteger, GTCShapeCornerFamily) {
    GTCShapeCornerFamilyRounded,
    GTCShapeCornerFamilyCut,
};

/**
 The GTCShapeCategory is the class containing the shape value as part of our shape scheme,
 GTCShapeScheme.

 GTCShapeCategory is built from 4 corners, that can be set to alter the shape value.
 */
@interface GTCShapeCategory : NSObject

/**
 This property represents the shape of the top left corner of the shape.
 */
@property(strong, nonatomic) GTCCornerTreatment *topLeftCorner;

/**
 This property represents the shape of the top right corner of the shape.
 */
@property(strong, nonatomic) GTCCornerTreatment *topRightCorner;

/**
 This property represents the shape of the bottom left corner of the shape.
 */
@property(strong, nonatomic) GTCCornerTreatment *bottomLeftCorner;

/**
 This property represents the shape of the bottom right corner of the shape.
 */
@property(strong, nonatomic) GTCCornerTreatment *bottomRightCorner;

/**
 The default init of the class. It sets all 4 corners with a corner family of
 GTCShapeCornerFamilyRounded and size of 0. This is equivalent to a "sharp" corner, or in terms of
 Apple's API it is the same as setting the cornerRadius to 0.

 @return returns an initialized GTCShapeCategory instance.
 */
- (instancetype)init;

/**
 This method is a convenience initializer of setting the shape value of all our corners at once
 to the provided cornerFamily and cornerSize.

 The outcome is a symmetrical shape that has the same values for all its corners.

 @param cornerFamily The family of our corner (rounded or angled).
 @param cornerSize The shape value of the corner.
 @return returns an GTCShapeCategory with the initialized values.
 */
- (instancetype)initCornersWithFamily:(GTCShapeCornerFamily)cornerFamily
                              andSize:(CGFloat)cornerSize;

@end
