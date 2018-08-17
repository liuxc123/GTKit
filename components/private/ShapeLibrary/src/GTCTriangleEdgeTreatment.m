//
//  GTCTriangleEdgeTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCTriangleEdgeTreatment.h"

static NSString *const GTCTriangleEdgeTreatmentSizeKey = @"GTCTriangleEdgeTreatmentSizeKey";
static NSString *const GTCTriangleEdgeTreatmentStyleKey = @"GTCTriangleEdgeTreatmentStyleKey";

@implementation GTCTriangleEdgeTreatment

- (instancetype)initWithSize:(CGFloat)size style:(GTCTriangleEdgeStyle)style {
    if (self = [super init]) {
        _size = size;
        _style = style;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _size = (CGFloat)[aDecoder decodeDoubleForKey:GTCTriangleEdgeTreatmentSizeKey];
        _style = [aDecoder decodeIntegerForKey:GTCTriangleEdgeTreatmentStyleKey];
    }
    return self;
}

- (GTCPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
    BOOL isCut = (self.style == GTCTriangleEdgeStyleCut);
    GTCPathGenerator *path = [GTCPathGenerator pathGeneratorWithStartPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(length/2 - _size, 0)];
    [path addLineToPoint:CGPointMake(length/2, isCut ? _size : -_size)];
    [path addLineToPoint:CGPointMake(length/2 + _size, 0)];
    [path addLineToPoint:CGPointMake(length, 0)];
    return path;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_size forKey:GTCTriangleEdgeTreatmentSizeKey];
    [aCoder encodeInteger:_style forKey:GTCTriangleEdgeTreatmentStyleKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] initWithSize:_size style:_style];
}

@end
