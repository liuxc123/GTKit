//
//  GTCEdgeTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

@class GTCPathGenerator;

/**
 GTCEdgeTreatment is a factory for creating GTCPathGenerators that represent the
 path of a edge.

 GTCEdgeTreaments only generate in the top quadrant (i.e. the top edge of a
 rectangle). GTCShapeModel will transform the generated GTCPathGenerator to the
 expected position and rotation.
 */
@interface GTCEdgeTreatment : NSObject <NSCopying, NSSecureCoding>

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 Generates an GTCPathGenerator object for an edge with the provided length.

 @param length The length of the edge.
 */
- (nonnull GTCPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length;

@end


