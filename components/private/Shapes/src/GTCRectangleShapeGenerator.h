//
//  GTCRectangleShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

#import "GTCShapeGenerating.h"

@class GTCCornerTreatment;
@class GTCEdgeTreatment;

/**
 An GTCShapeGenerating for creating shaped rectanglular CGPaths.

 By default GTCRectangleShapeGenerator creates rectanglular CGPaths. Set the corner and edge
 treatments to shape parts of the generated path.
 */
@interface GTCRectangleShapeGenerator : NSObject <GTCShapeGenerating>

/**
 The corner treatments to apply to each corner.
 */
@property(nonatomic, strong) GTCCornerTreatment *topLeftCorner;
@property(nonatomic, strong) GTCCornerTreatment *topRightCorner;
@property(nonatomic, strong) GTCCornerTreatment *bottomLeftCorner;
@property(nonatomic, strong) GTCCornerTreatment *bottomRightCorner;

/**
 The offsets to apply to each corner.
 */
@property(nonatomic, assign) CGPoint topLeftCornerOffset;
@property(nonatomic, assign) CGPoint topRightCornerOffset;
@property(nonatomic, assign) CGPoint bottomLeftCornerOffset;
@property(nonatomic, assign) CGPoint bottomRightCornerOffset;

/**
 The edge treatments to apply to each edge.
 */
@property(nonatomic, strong) GTCEdgeTreatment *topEdge;
@property(nonatomic, strong) GTCEdgeTreatment *rightEdge;
@property(nonatomic, strong) GTCEdgeTreatment *bottomEdge;
@property(nonatomic, strong) GTCEdgeTreatment *leftEdge;

/**
 Convenience to set all corners to the same GTCCornerTreatment instance.
 */
- (void)setCorners:(GTCCornerTreatment *)cornerShape;

/**
 Conveninece to set all edge treatments to the same GTCEdgeTreatment instance.
 */
- (void)setEdges:(GTCEdgeTreatment *)edgeShape;

@end

