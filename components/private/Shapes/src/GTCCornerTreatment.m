//
//  GTCCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCCornerTreatment.h"

#import "GTCPathGenerator.h"

@implementation GTCCornerTreatment

- (instancetype)init {
    _valueType = GTCCornerTreatmentValueTypeAbsolute;
    return [super init];
}

- (instancetype)initWithCoder:(NSCoder *)__unused aDecoder {
    if (self = [super init]) {
        // GTCCornerTreatment has no params so nothing to decode here.
    }
    return self;
}

- (GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle {
    return [GTCPathGenerator pathGeneratorWithStartPoint:CGPointZero];
}

- (GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle
                                          forViewSize:(CGSize)__unused viewSize {
    return [GTCPathGenerator pathGeneratorWithStartPoint:CGPointZero];
}

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // GTCCornerTreatment has no params, so nothing to encode here.
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    GTCCornerTreatment *copy = [[[self class] alloc] init];
    copy.valueType = _valueType;
    return copy;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (!object || ![[object class] isEqual:[self class]]) {
        return NO;
    }
    GTCCornerTreatment *otherCorner = (GTCCornerTreatment *)object;
    return self.valueType == otherCorner.valueType;
}


@end

