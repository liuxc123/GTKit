//
//  GTCCurvedCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCCurvedCornerTreatment.h"

static NSString *const GTCCurvedCornerTreatmentSizeKey = @"GTCCurvedCornerTreatmentSizeKey";

@implementation GTCCurvedCornerTreatment

- (instancetype)init {
    return [self initWithSize:CGSizeZero];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super init]) {
        _size = size;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _size = [aDecoder decodeCGSizeForKey:GTCCurvedCornerTreatmentSizeKey];
    }
    return self;
}

- (GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle {
    GTCPathGenerator *path =
    [GTCPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, self.size.height)];
    [path addQuadCurveWithControlPoint:CGPointZero toPoint:CGPointMake(self.size.width, 0)];
    return path;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeCGSize:_size forKey:GTCCurvedCornerTreatmentSizeKey];
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    GTCCurvedCornerTreatment *copy = [[[self class] alloc] init];
    copy.size = self.size;
    return copy;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
