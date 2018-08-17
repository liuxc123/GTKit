//
//  GTCTriangleEdgeTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

typedef enum : NSUInteger {
    GTCTriangleEdgeStyleHandle,
    GTCTriangleEdgeStyleCut,
} GTCTriangleEdgeStyle;

/**
 An edge treatment that adds a triangle-shaped cut or handle to the edge.
 */
@interface GTCTriangleEdgeTreatment : GTCEdgeTreatment

/**
 The size of the triangle shape.
 */
@property(nonatomic, assign) CGFloat size;

/**
 The style of the triangle shape.
 */
@property(nonatomic, assign) GTCTriangleEdgeStyle style;

/**
 Initializes an GTCTriangleEdgeTreatment with a given size and style.
 */
- (nonnull instancetype)initWithSize:(CGFloat)size style:(GTCTriangleEdgeStyle)style
NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

