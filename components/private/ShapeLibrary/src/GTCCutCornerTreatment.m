//
//  GTCCutCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCCutCornerTreatment.h"

static NSString *const GTCCutCornerTreatmentCutKey = @"GTCCutCornerTreatmentCutKey";

@implementation GTCCutCornerTreatment

- (instancetype)init {
    return [self initWithCut:0];
}

- (instancetype)initWithCut:(CGFloat)cut {
    if (self = [super init]) {
        _cut = cut;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _cut = (CGFloat)[aDecoder decodeDoubleForKey:GTCCutCornerTreatmentCutKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_cut forKey:GTCCutCornerTreatmentCutKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] initWithCut:_cut];
}

- (GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
    GTCPathGenerator *path = [GTCPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, _cut)];
    [path addLineToPoint:CGPointMake(_cut, 0)];
    return path;
}

@end


