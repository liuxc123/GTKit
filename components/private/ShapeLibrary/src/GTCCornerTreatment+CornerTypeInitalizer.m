//
//  GTCCornerTreatment+CornerTypeInitalizer.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "GTCCornerTreatment+CornerTypeInitalizer.h"

@implementation GTCCornerTreatment (CornerTypeInitalizer)

+ (GTCRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value {
    return [[GTCRoundedCornerTreatment alloc] initWithRadius:value];
}

+ (GTCRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value
                                      valueType:(GTCCornerTreatmentValueType)valueType {
    GTCRoundedCornerTreatment *roundedCornerTreatment =
    [GTCRoundedCornerTreatment cornerWithRadius:value];
    roundedCornerTreatment.valueType = valueType;
    return roundedCornerTreatment;
}

+ (GTCCutCornerTreatment *)cornerWithCut:(CGFloat)value {
    return [[GTCCutCornerTreatment alloc] initWithCut:value];
}

+ (GTCCutCornerTreatment *)cornerWithCut:(CGFloat)value
                               valueType:(GTCCornerTreatmentValueType)valueType {
    GTCCutCornerTreatment *cutCornerTreatment = [GTCCutCornerTreatment cornerWithCut:value];
    cutCornerTreatment.valueType = valueType;
    return cutCornerTreatment;
}

+ (GTCCurvedCornerTreatment *)cornerWithCurve:(CGSize)value {
    return [[GTCCurvedCornerTreatment alloc] initWithSize:value];
}

+ (GTCCurvedCornerTreatment *)cornerWithCurve:(CGSize)value
                                    valueType:(GTCCornerTreatmentValueType)valueType {
    GTCCurvedCornerTreatment *curvedCornerTreatment =
    [GTCCurvedCornerTreatment cornerWithCurve:value];
    curvedCornerTreatment.valueType = valueType;
    return curvedCornerTreatment;
}

@end
