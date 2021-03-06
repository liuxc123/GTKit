//
//  GTMath.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/16.
//

#import <math.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

static inline CGFloat GTCSin(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return sin(value);
#else
    return sinf(value);
#endif
}

static inline CGFloat GTCCos(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return cos(value);
#else
    return cosf(value);
#endif
}

static inline CGFloat GTCAtan2(CGFloat y, CGFloat x) {
#if CGFLOAT_IS_DOUBLE
    return atan2(y, x);
#else
    return atan2f(y, x);
#endif
}

static inline CGFloat GTCCeil(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return ceil(value);
#else
    return ceilf(value);
#endif
}

static inline CGFloat GTCFabs(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return fabs(value);
#else
    return fabsf(value);
#endif
}

static inline CGFloat GTCDegreesToRadians(CGFloat degrees) {
#if CGFLOAT_IS_DOUBLE
    return degrees * (CGFloat)M_PI / 180.0;
#else
    return degrees * (CGFloat)M_PI / 180.f;
#endif
}

static inline BOOL GTCCGFloatEqual(CGFloat a, CGFloat b) {
    const CGFloat constantK = 3;
#if CGFLOAT_IS_DOUBLE
    const CGFloat epsilon = DBL_EPSILON;
    const CGFloat min = DBL_MIN;
#else
    const CGFloat epsilon = FLT_EPSILON;
    const CGFloat min = FLT_MIN;
#endif
    return (GTCFabs(a - b) < constantK * epsilon * GTCFabs(a + b) || GTCFabs(a - b) < min);
}

static inline CGFloat GTCFloor(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return floor(value);
#else
    return floorf(value);
#endif
}

static inline CGFloat GTCHypot(CGFloat x, CGFloat y) {
#if CGFLOAT_IS_DOUBLE
    return hypot(x, y);
#else
    return hypotf(x, y);
#endif
}

// Checks whether the provided floating point number is exactly zero.
static inline BOOL GTCCGFloatIsExactlyZero(CGFloat value) {
    return (value == 0.f);
}

static inline CGFloat GTCPow(CGFloat value, CGFloat power) {
#if CGFLOAT_IS_DOUBLE
    return pow(value, power);
#else
    return powf(value, power);
#endif
}

static inline CGFloat GTCRint(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return rint(value);
#else
    return rintf(value);
#endif
}

static inline CGFloat GTCRound(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return round(value);
#else
    return roundf(value);
#endif
}

static inline CGFloat GTCSqrt(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return sqrt(value);
#else
    return sqrtf(value);
#endif
}

/**
 Expand `rect' to the smallest standardized rect containing it with pixel-aligned origin and size.
 If @c scale is zero, then a scale of 1 will be used instead.

 @param rect the rectangle to align.
 @param scale the scale factor to use for pixel alignment.

 @return the input rectangle aligned to the nearest pixels using the provided scale factor.

 @see CGRectIntegral
 */
static inline CGRect GTCRectAlignToScale(CGRect rect, CGFloat scale) {
    if (CGRectIsNull(rect)) {
        return CGRectNull;
    }
    if (GTCCGFloatEqual(scale, 0)) {
        scale = 1;
    }

    if (GTCCGFloatEqual(scale, 1)) {
        return CGRectIntegral(rect);
    }

    CGPoint originalMinimumPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint newOrigin = CGPointMake(GTCFloor(originalMinimumPoint.x * scale) / scale,
                                    GTCFloor(originalMinimumPoint.y * scale) / scale);
    CGSize adjustWidthHeight =
    CGSizeMake(originalMinimumPoint.x - newOrigin.x, originalMinimumPoint.y - newOrigin.y);
    return CGRectMake(newOrigin.x, newOrigin.y,
                      GTCCeil((CGRectGetWidth(rect) + adjustWidthHeight.width) * scale) / scale,
                      GTCCeil((CGRectGetHeight(rect) + adjustWidthHeight.height) * scale) / scale);
}

static inline CGPoint GTCPointRoundWithScale(CGPoint point, CGFloat scale) {
    if (GTCCGFloatEqual(scale, 0)) {
        return CGPointZero;
    }

    return CGPointMake(GTCRound(point.x * scale) / scale, GTCRound(point.y * scale) / scale);
}

/**
 Expand `size' to the closest larger pixel-aligned value.
 If @c scale is zero, then a CGSizeZero will be returned.

 @param size the size to align.
 @param scale the scale factor to use for pixel alignment.

 @return the size aligned to the closest larger pixel-aligned value using the provided scale factor.
 */
static inline CGSize GTCSizeCeilWithScale(CGSize size, CGFloat scale) {
    if (GTCCGFloatEqual(scale, 0)) {
        return CGSizeZero;
    }

    return CGSizeMake(GTCCeil(size.width * scale) / scale, GTCCeil(size.height * scale) / scale);
}

/**
 Align the centerPoint of a view so that its origin is pixel-aligned to the nearest pixel.
 Returns @c CGRectZero if @c scale is zero or @c bounds is @c CGRectNull.

 @param center the unaligned center of the view.
 @param bounds the bounds of the view.
 @param scale the native scaling factor for pixel alignment.

 @return the center point of the view such that its origin will be pixel-aligned.
 */
static inline CGPoint GTCRoundCenterWithBoundsAndScale(CGPoint center,
                                                       CGRect bounds,
                                                       CGFloat scale) {
    if (GTCCGFloatEqual(scale, 0) || CGRectIsNull(bounds)) {
        return CGPointZero;
    }

    CGFloat halfWidth = CGRectGetWidth(bounds) / 2;
    CGFloat halfHeight = CGRectGetHeight(bounds) / 2;
    CGPoint origin = CGPointMake(center.x - halfWidth, center.y - halfHeight);
    origin = GTCPointRoundWithScale(origin, scale);
    return CGPointMake(origin.x + halfWidth, origin.y + halfHeight);
}
