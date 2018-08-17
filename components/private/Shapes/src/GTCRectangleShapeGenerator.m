//
//  GTCRectangleShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCRectangleShapeGenerator.h"

#import "GTCCornerTreatment.h"
#import "GTCEdgeTreatment.h"
#import "GTCPathGenerator.h"
#import "GTMath.h"

static NSString *const GTCRectangleShapeGeneratorTopLeftCornerKey =
@"GTCRectangleShapeGeneratorTopLeftCornerKey";
static NSString *const GTCRectangleShapeGeneratorTopRightCornerKey =
@"GTCRectangleShapeGeneratorTopRightCornerKey";
static NSString *const GTCRectangleShapeGeneratorBottomRightCornerKey =
@"GTCRectangleShapeGeneratorBottomRightCornerKey";
static NSString *const GTCRectangleShapeGeneratorBottomLeftCornerKey =
@"GTCRectangleShapeGeneratorBottomLeftCornerKey";

static NSString *const GTCRectangleShapeGeneratorTopLeftCornerOffsetKey =
@"GTCRectangleShapeGeneratorTopLeftCornerOffsetKey";
static NSString *const GTCRectangleShapeGeneratorTopRightCornerOffsetKey =
@"GTCRectangleShapeGeneratorTopRightCornerOffsetKey";
static NSString *const GTCRectangleShapeGeneratorBottomRightCornerOffsetKey =
@"GTCRectangleShapeGeneratorBottomRightCornerOffsetKey";
static NSString *const GTCRectangleShapeGeneratorBottomLeftCornerOffsetKey =
@"GTCRectangleShapeGeneratorBottomLeftCornerOffsetKey";

static NSString *const GTCRectangleShapeGeneratorTopEdgeKey =
@"GTCRectangleShapeGeneratorTopEdgeKey";
static NSString *const GTCRectangleShapeGeneratorRightEdgeKey =
@"GTCRectangleShapeGeneratorRightEdgeKey";
static NSString *const GTCRectangleShapeGeneratorBottomEdgeKey =
@"GTCRectangleShapeGeneratorBottomEdgeKey";
static NSString *const GTCRectangleShapeGeneratorLeftEdgeKey =
@"GTCRectangleShapeGeneratorLeftEdgeKey";

static inline CGFloat CGPointDistanceToPoint(CGPoint a, CGPoint b) {
    return GTCHypot(a.x - b.x, a.y - b.y);
}

// Edges in clockwise order
typedef enum : NSUInteger {
    GTCShapeEdgeTop = 0,
    GTCShapeEdgeRight,
    GTCShapeEdgeBottom,
    GTCShapeEdgeLeft,
} GTCShapeEdgePosition;

// Corners in clockwise order
typedef enum : NSUInteger {
    GTCShapeCornerTopLeft = 0,
    GTCShapeCornerTopRight,
    GTCShapeCornerBottomRight,
    GTCShapeCornerBottomLeft,
} GTCShapeCornerPosition;

@implementation GTCRectangleShapeGenerator

- (instancetype)init {
    if (self = [super init]) {
        [self setEdges:[[GTCEdgeTreatment alloc] init]];
        [self setCorners:[[GTCCornerTreatment alloc] init]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.topLeftCorner =
        [aDecoder decodeObjectOfClass:[GTCCornerTreatment class]
                               forKey:GTCRectangleShapeGeneratorTopLeftCornerKey];
        self.topRightCorner =
        [aDecoder decodeObjectOfClass:[GTCCornerTreatment class]
                               forKey:GTCRectangleShapeGeneratorTopRightCornerKey];
        self.bottomRightCorner =
        [aDecoder decodeObjectOfClass:[GTCCornerTreatment class]
                               forKey:GTCRectangleShapeGeneratorBottomRightCornerKey];
        self.bottomLeftCorner =
        [aDecoder decodeObjectOfClass:[GTCCornerTreatment class]
                               forKey:GTCRectangleShapeGeneratorBottomLeftCornerKey];

        self.topLeftCornerOffset =
        [aDecoder decodeCGPointForKey:GTCRectangleShapeGeneratorTopLeftCornerOffsetKey];
        self.topRightCornerOffset =
        [aDecoder decodeCGPointForKey:GTCRectangleShapeGeneratorTopRightCornerOffsetKey];
        self.bottomRightCornerOffset =
        [aDecoder decodeCGPointForKey:GTCRectangleShapeGeneratorBottomRightCornerOffsetKey];
        self.bottomLeftCornerOffset =
        [aDecoder decodeCGPointForKey:GTCRectangleShapeGeneratorBottomLeftCornerOffsetKey];

        self.topEdge = [aDecoder decodeObjectOfClass:[GTCEdgeTreatment class]
                                              forKey:GTCRectangleShapeGeneratorTopEdgeKey];
        self.rightEdge = [aDecoder decodeObjectOfClass:[GTCEdgeTreatment class]
                                                forKey:GTCRectangleShapeGeneratorRightEdgeKey];
        self.bottomEdge = [aDecoder decodeObjectOfClass:[GTCEdgeTreatment class]
                                                 forKey:GTCRectangleShapeGeneratorBottomEdgeKey];
        self.leftEdge = [aDecoder decodeObjectOfClass:[GTCEdgeTreatment class]
                                               forKey:GTCRectangleShapeGeneratorLeftEdgeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.topLeftCorner
                  forKey:GTCRectangleShapeGeneratorTopLeftCornerKey];
    [aCoder encodeObject:self.topRightCorner
                  forKey:GTCRectangleShapeGeneratorTopRightCornerKey];
    [aCoder encodeObject:self.bottomRightCorner
                  forKey:GTCRectangleShapeGeneratorBottomRightCornerKey];
    [aCoder encodeObject:self.bottomLeftCorner
                  forKey:GTCRectangleShapeGeneratorBottomLeftCornerKey];

    [aCoder encodeCGPoint:self.topLeftCornerOffset
                   forKey:GTCRectangleShapeGeneratorTopLeftCornerOffsetKey];
    [aCoder encodeCGPoint:self.topRightCornerOffset
                   forKey:GTCRectangleShapeGeneratorTopRightCornerOffsetKey];
    [aCoder encodeCGPoint:self.bottomRightCornerOffset
                   forKey:GTCRectangleShapeGeneratorBottomRightCornerOffsetKey];
    [aCoder encodeCGPoint:self.bottomLeftCornerOffset
                   forKey:GTCRectangleShapeGeneratorBottomLeftCornerOffsetKey];

    [aCoder encodeObject:self.topEdge forKey:GTCRectangleShapeGeneratorTopEdgeKey];
    [aCoder encodeObject:self.rightEdge forKey:GTCRectangleShapeGeneratorRightEdgeKey];
    [aCoder encodeObject:self.bottomEdge forKey:GTCRectangleShapeGeneratorBottomEdgeKey];
    [aCoder encodeObject:self.leftEdge forKey:GTCRectangleShapeGeneratorLeftEdgeKey];
}

- (id)copyWithZone:(NSZone *)zone {
    GTCRectangleShapeGenerator *copy = [[[self class] alloc] init];

    copy.topLeftCorner = [copy.topLeftCorner copyWithZone:zone];
    copy.topRightCorner = [copy.topRightCorner copyWithZone:zone];
    copy.bottomRightCorner = [copy.bottomRightCorner copyWithZone:zone];
    copy.bottomLeftCorner = [copy.bottomLeftCorner copyWithZone:zone];

    copy.topLeftCornerOffset = copy.topLeftCornerOffset;
    copy.topRightCornerOffset = copy.topRightCornerOffset;
    copy.bottomRightCornerOffset = copy.bottomRightCornerOffset;
    copy.bottomLeftCornerOffset = copy.bottomLeftCornerOffset;

    copy.topEdge = [copy.topEdge copyWithZone:zone];
    copy.rightEdge = [copy.rightEdge copyWithZone:zone];
    copy.bottomEdge = [copy.bottomEdge copyWithZone:zone];
    copy.leftEdge = [copy.leftEdge copyWithZone:zone];

    return copy;
}

- (void)setCorners:(GTCCornerTreatment *)cornerShape {
    self.topLeftCorner = [cornerShape copy];
    self.topRightCorner = [cornerShape copy];
    self.bottomRightCorner = [cornerShape copy];
    self.bottomLeftCorner = [cornerShape copy];
}

- (void)setEdges:(GTCEdgeTreatment *)edgeShape {
    self.topEdge = [edgeShape copy];
    self.rightEdge = [edgeShape copy];
    self.bottomEdge = [edgeShape copy];
    self.leftEdge = [edgeShape copy];
}

- (GTCCornerTreatment *)cornerTreatmentForPosition:(GTCShapeCornerPosition)position {
    switch (position) {
        case GTCShapeCornerTopLeft:
            return self.topLeftCorner;
        case GTCShapeCornerTopRight:
            return self.topRightCorner;
        case GTCShapeCornerBottomLeft:
            return self.bottomLeftCorner;
        case GTCShapeCornerBottomRight:
            return self.bottomRightCorner;
    }
}

- (CGPoint)cornerOffsetForPosition:(GTCShapeCornerPosition)position {
    switch (position) {
        case GTCShapeCornerTopLeft:
            return self.topLeftCornerOffset;
        case GTCShapeCornerTopRight:
            return self.topRightCornerOffset;
        case GTCShapeCornerBottomLeft:
            return self.bottomLeftCornerOffset;
        case GTCShapeCornerBottomRight:
            return self.bottomRightCornerOffset;
    }
}

- (GTCEdgeTreatment *)edgeTreatmentForPosition:(GTCShapeEdgePosition)position {
    switch (position) {
        case GTCShapeEdgeTop:
            return self.topEdge;
        case GTCShapeEdgeLeft:
            return self.leftEdge;
        case GTCShapeEdgeRight:
            return self.rightEdge;
        case GTCShapeEdgeBottom:
            return self.bottomEdge;
    }
}

- (CGPathRef)pathForSize:(CGSize)size {
    CGMutablePathRef path = CGPathCreateMutable();
    GTCPathGenerator *cornerPaths[4];
    CGAffineTransform cornerTransforms[4];
    CGAffineTransform edgeTransforms[4];
    CGFloat edgeAngles[4];
    CGFloat edgeLengths[4];

    // Start by getting the path of each corner and calculating edge angles.
    for (NSInteger i = 0; i < 4; i++) {
        GTCCornerTreatment *cornerShape = [self cornerTreatmentForPosition:i];
        CGFloat cornerAngle = [self angleOfCorner:i forViewSize:size];
        cornerPaths[i] = [cornerShape pathGeneratorForCornerWithAngle:cornerAngle];
        edgeAngles[i] = [self angleOfEdge:i forViewSize:size];
    }

    // Create transformation matrices for each corner and edge
    for (NSInteger i = 0; i < 4; i++) {
        CGPoint cornerCoords = [self cornerCoordsForPosition:i forViewSize:size];
        CGAffineTransform cornerTransform = CGAffineTransformMakeTranslation(cornerCoords.x,
                                                                             cornerCoords.y);
        CGFloat prevEdgeAngle = edgeAngles[(i + 4 - 1) % 4];
        // We add 90 degrees (M_PI_2) here because the corner starts rotated from the edge.
        cornerTransform = CGAffineTransformRotate(cornerTransform, prevEdgeAngle + (CGFloat)M_PI_2);
        cornerTransforms[i] = cornerTransform;

        CGPoint edgeStartPoint = CGPointApplyAffineTransform(cornerPaths[i].endPoint,
                                                             cornerTransforms[i]);
        CGAffineTransform edgeTransform = CGAffineTransformMakeTranslation(edgeStartPoint.x,
                                                                           edgeStartPoint.y);
        CGFloat edgeAngle = edgeAngles[i];
        edgeTransform = CGAffineTransformRotate(edgeTransform, edgeAngle);
        edgeTransforms[i] = edgeTransform;
    }

    // Calculate the length of each edge using the transformed corner paths.
    for (NSInteger i = 0; i < 4; i++) {
        NSInteger next = (i + 1) % 4;
        CGPoint edgeStartPoint = CGPointApplyAffineTransform(cornerPaths[i].endPoint,
                                                             cornerTransforms[i]);
        CGPoint edgeEndPoint = CGPointApplyAffineTransform(cornerPaths[next].startPoint,
                                                           cornerTransforms[next]);
        edgeLengths[i] = CGPointDistanceToPoint(edgeStartPoint, edgeEndPoint);
    }

    // Draw the first corner manually because we have to MoveToPoint to start the path.
    CGPathMoveToPoint(path,
                      &cornerTransforms[0],
                      cornerPaths[0].startPoint.x,
                      cornerPaths[0].startPoint.y);
    [cornerPaths[0] appendToCGPath:path transform:&cornerTransforms[0]];

    // Draw the remaining three corners joined by edges.
    for (NSInteger i = 1; i < 4; i++) {
        // draw the edge from the previous point to the current point
        GTCEdgeTreatment *edge = [self edgeTreatmentForPosition:(i - 1)];
        GTCPathGenerator *edgePath = [edge pathGeneratorForEdgeWithLength:edgeLengths[i - 1]];
        [edgePath appendToCGPath:path transform:&edgeTransforms[i - 1]];

        GTCPathGenerator *cornerPath = cornerPaths[i];
        [cornerPath appendToCGPath:path transform:&cornerTransforms[i]];
    }

    // Draw final edge back to first point.
    GTCEdgeTreatment *edge = [self edgeTreatmentForPosition:3];
    GTCPathGenerator *edgePath = [edge pathGeneratorForEdgeWithLength:edgeLengths[3]];
    [edgePath appendToCGPath:path transform:&edgeTransforms[3]];

    CGPathCloseSubpath(path);

    return path;
}

- (CGFloat)angleOfCorner:(GTCShapeCornerPosition)cornerPosition forViewSize:(CGSize)size {
    CGPoint prevCornerCoord = [self cornerCoordsForPosition:(cornerPosition - 1 + 4) % 4
                                                forViewSize:size];
    CGPoint nextCornerCoord = [self cornerCoordsForPosition:(cornerPosition + 1) % 4
                                                forViewSize:size];
    CGPoint cornerCoord = [self cornerCoordsForPosition:cornerPosition forViewSize:size];
    CGPoint prevVector = CGPointMake(prevCornerCoord.x - cornerCoord.x,
                                     prevCornerCoord.y - cornerCoord.y);
    CGPoint nextVector = CGPointMake(nextCornerCoord.x - cornerCoord.x,
                                     nextCornerCoord.y - cornerCoord.y);
    CGFloat prevAngle = GTCAtan2(prevVector.y, prevVector.x);
    CGFloat nextAngle = GTCAtan2(nextVector.y, nextVector.x);
    CGFloat angle = prevAngle - nextAngle;
    if (angle < 0) angle += 2 * M_PI;
    return angle;
}

- (CGFloat)angleOfEdge:(GTCShapeEdgePosition)edgePosition forViewSize:(CGSize)size {
    GTCShapeCornerPosition startCornerPosition = (GTCShapeCornerPosition)edgePosition;
    GTCShapeCornerPosition endCornerPosition = (startCornerPosition + 1) % 4;
    CGPoint startCornerCoord = [self cornerCoordsForPosition:startCornerPosition forViewSize:size];
    CGPoint endCornerCoord = [self cornerCoordsForPosition:endCornerPosition forViewSize:size];

    CGPoint edgeVector = CGPointMake(endCornerCoord.x - startCornerCoord.x,
                                     endCornerCoord.y - startCornerCoord.y);
    return GTCAtan2(edgeVector.y, edgeVector.x);
}

- (CGPoint)cornerCoordsForPosition:(GTCShapeCornerPosition)cornerPosition
                       forViewSize:(CGSize)viewSize {
    CGPoint offset = [self cornerOffsetForPosition:cornerPosition];
    CGPoint translation;
    switch (cornerPosition) {
        case GTCShapeCornerTopLeft:
            translation = CGPointMake(0, 0);
            break;
        case GTCShapeCornerTopRight:
            translation = CGPointMake(viewSize.width, 0);
            break;
        case GTCShapeCornerBottomLeft:
            translation = CGPointMake(0, viewSize.height);
            break;
        case GTCShapeCornerBottomRight:
            translation = CGPointMake(viewSize.width, viewSize.height);
            break;
    }

    return CGPointMake(offset.x + translation.x,
                       offset.y + translation.y);
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

