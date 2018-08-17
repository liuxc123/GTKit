//
//  GTCPillShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTCPillShapeGenerator.h"

#import "GTMath.h"
#import "GTCRoundedCornerTreatment.h"

@implementation GTCPillShapeGenerator {
    GTCRectangleShapeGenerator *_rectangleGenerator;
    GTCRoundedCornerTreatment *_cornerShape;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)__unused aDecoder {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] init];
}

- (void)commonInit {
    _cornerShape = [[GTCRoundedCornerTreatment alloc] init];
    _rectangleGenerator = [[GTCRectangleShapeGenerator alloc] init];
    [_rectangleGenerator setCorners:_cornerShape];
}

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // no-op, we have no params
}

- (CGPathRef)pathForSize:(CGSize)size {
    CGFloat radius = 0.5f * MIN(GTCFabs(size.width), GTCFabs(size.height));
    if (radius > 0) {
        [_rectangleGenerator setCorners:[[GTCRoundedCornerTreatment alloc] initWithRadius:radius]];
    }
    return [_rectangleGenerator pathForSize:size];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
