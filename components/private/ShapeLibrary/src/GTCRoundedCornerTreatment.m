//
//  GTCRoundedCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCRoundedCornerTreatment.h"

#import "GTMath.h"

static NSString *const GTCRoundedCornerTreatmentRadiusKey = @"GTCRoundedCornerTreatmentRadiusKey";

@implementation GTCRoundedCornerTreatment

- (instancetype)init {
    return [self initWithRadius:0];
}

- (instancetype)initWithRadius:(CGFloat)radius {
    if (self = [super init]) {
        _radius = radius;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _radius = (CGFloat)[aDecoder decodeDoubleForKey:GTCRoundedCornerTreatmentRadiusKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_radius forKey:GTCRoundedCornerTreatmentRadiusKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] initWithRadius:_radius];
}

- (GTCPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
    GTCPathGenerator *path = [GTCPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, _radius)];
    [path addArcWithTangentPoint:CGPointZero
                         toPoint:CGPointMake(GTCSin(angle) * _radius, GTCCos(angle) * _radius)
                          radius:_radius];
    return path;
}

@end

