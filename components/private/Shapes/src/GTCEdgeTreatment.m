//
//  GTCEdgeTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCEdgeTreatment.h"

#import "GTCPathGenerator.h"

@implementation GTCEdgeTreatment

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithCoder:(NSCoder *)__unused aDecoder {
    if (self = [super init]) {
        // GTCEdgeTreatment has no params so nothing to decode here.
    }
    return self;
}

- (GTCPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
    GTCPathGenerator *path = [GTCPathGenerator pathGeneratorWithStartPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(length, 0)];
    return path;
}

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // GTCEdgeTreatment has no params, so nothing to encode here.
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    return [[[self class] alloc] init];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

