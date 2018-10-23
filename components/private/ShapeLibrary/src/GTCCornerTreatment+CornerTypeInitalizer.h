//
//  GTCCornerTreatment+CornerTypeInitalizer.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "GTShapes.h"

#import "GTCCurvedCornerTreatment.h"
#import "GTCCutCornerTreatment.h"
#import "GTCRoundedCornerTreatment.h"

@interface GTCCornerTreatment (CornerTypeInitalizer)


/**
 Initialize and return an GTCCornerTreatment as an GTCRoundedCornerTreatment.

 @param value The radius to set the rounded corner to.
 @return an GTCRoundedCornerTreatment.
 */
+ (GTCRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value;

/**
 Initialize and return an GTCCornerTreatment as an GTCRoundedCornerTreatment.

 @param value The radius to set the rounded corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an GTCRoundedCornerTreatment.
 */
+ (GTCRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value
                                      valueType:(GTCCornerTreatmentValueType)valueType;

/**
 Initialize and return an GTCCornerTreatment as an GTCCutCornerTreatment.

 @param value The cut to set the cut corner to.
 @return an GTCCutCornerTreatment.
 */
+ (GTCCutCornerTreatment *)cornerWithCut:(CGFloat)value;

/**
 Initialize and return an GTCCornerTreatment as an GTCRoundedCornerTreatment.

 @param value The cut to set the cut corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an GTCCutCornerTreatment.
 */
+ (GTCCutCornerTreatment *)cornerWithCut:(CGFloat)value
                               valueType:(GTCCornerTreatmentValueType)valueType;

/**
 Initialize and return an GTCCornerTreatment as an GTCCurvedCornerTreatment.

 @param value The size to set the curved corner to.
 @return an GTCCurvedCornerTreatment.
 */
+ (GTCCurvedCornerTreatment *)cornerWithCurve:(CGSize)value;

/**
 Initialize and return an GTCCornerTreatment as an GTCCurvedCornerTreatment.

 @param value The curve to set the curved corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an GTCCurvedCornerTreatment.
 */
+ (GTCCurvedCornerTreatment *)cornerWithCurve:(CGSize)value
                                    valueType:(GTCCornerTreatmentValueType)valueType;


@end
