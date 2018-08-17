//
//  GTCSlantedRectShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCSlantedRectShapeGenerator.h"

static NSString *const GTCSlantedRectShapeGeneratorSlantKey =
@"GTCSlantedRectShapeGeneratorSlantKey";

@implementation GTCSlantedRectShapeGenerator {
    GTCRectangleShapeGenerator *_rectangleGenerator;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonGTCSlantedRectShapeGeneratorInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self commonGTCSlantedRectShapeGeneratorInit];

        _slant = (CGFloat)[aDecoder decodeDoubleForKey:GTCSlantedRectShapeGeneratorSlantKey];
    }
    return self;
}

- (void)commonGTCSlantedRectShapeGeneratorInit {
    _rectangleGenerator = [[GTCRectangleShapeGenerator alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_slant forKey:GTCSlantedRectShapeGeneratorSlantKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    GTCSlantedRectShapeGenerator *copy = [[[self class] alloc] init];
    copy.slant = self.slant;
    return copy;
}

- (void)setSlant:(CGFloat)slant {
    _slant = slant;

    _rectangleGenerator.topLeftCornerOffset     = CGPointMake( slant, 0);
    _rectangleGenerator.topRightCornerOffset    = CGPointMake( slant, 0);
    _rectangleGenerator.bottomLeftCornerOffset  = CGPointMake(-slant, 0);
    _rectangleGenerator.bottomRightCornerOffset = CGPointMake(-slant, 0);
}

- (CGPathRef)pathForSize:(CGSize)size {
    return [_rectangleGenerator pathForSize:size];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
