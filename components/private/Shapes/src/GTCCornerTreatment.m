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

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // GTCCornerTreatment has no params, so nothing to encode here.
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    return [[[self class] alloc] init];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

