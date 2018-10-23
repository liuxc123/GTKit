//
//  GTCAnimationTimingCurves.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/19.
//

#import "GTCAnimationTimingCurves.h"

@implementation GTCAnimationTimingCurves

+ (GTMMotionCurve)linear
{
    return GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f);
}

+ (GTMMotionCurve)easeIn
{
    return GTMMotionCurveMakeBezier(0.4f, 0.0f, 1.0f, 1.0f);
}

+ (GTMMotionCurve)easeOut
{
    return GTMMotionCurveMakeBezier(0.0f, 0.0f, 0.2f, 1.0f);
}

+ (GTMMotionCurve)easeInOut
{
    return GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f);
}

+ (GTMMotionCurve)easeInSine
{
    return GTMMotionCurveMakeBezier(0.47f, 0.0f, 0.745f, 0.715f);
}

+ (GTMMotionCurve)easeOutSine
{
    return GTMMotionCurveMakeBezier(0.39f, 0.575f, 0.565f, 1.0f);
}

+ (GTMMotionCurve)easeInOutSine
{
    return GTMMotionCurveMakeBezier(0.445f, 0.05f, 0.55f, 0.95f);
}

+ (GTMMotionCurve)easeInQuad
{
    return GTMMotionCurveMakeBezier(0.55f, 0.085f, 0.68f, 0.53f);
}

+ (GTMMotionCurve)easeOutQuad
{
    return GTMMotionCurveMakeBezier(0.25f, 0.46f, 0.45f, 0.94f);
}

+ (GTMMotionCurve)easeInOutQuad
{
    return GTMMotionCurveMakeBezier(0.455f, 0.03f, 0.515f, 0.955f);
}

+ (GTMMotionCurve)easeInCubic
{
    return GTMMotionCurveMakeBezier(0.55f, 0.055f, 0.675f, 0.19f);
}

+ (GTMMotionCurve)easeOutCubic
{
    return GTMMotionCurveMakeBezier(0.215f, 0.61f, 0.355f, 1.0f);
}

+ (GTMMotionCurve)easeInOutCubic
{
    return GTMMotionCurveMakeBezier(0.645f, 0.045f, 0.355f, 1.0f);
}

+ (GTMMotionCurve)easeInQuart
{
    return GTMMotionCurveMakeBezier(0.895f, 0.03f, 0.685f, 0.22f);
}

+ (GTMMotionCurve)easeOutQuart
{
    return GTMMotionCurveMakeBezier(0.165f, 0.84f, 0.44f, 1.0f);
}

+ (GTMMotionCurve)easeInOutQuart
{
    return GTMMotionCurveMakeBezier(0.77f, 0.0f, 0.175f, 1.0f);
}

+ (GTMMotionCurve)easeInQuint
{
    return GTMMotionCurveMakeBezier(0.755f, 0.05f, 0.855f, 0.06f);
}

+ (GTMMotionCurve)easeOutQuint
{
    return GTMMotionCurveMakeBezier(0.23f, 1.0f, 0.32f, 1.0f);
}

+ (GTMMotionCurve)easeInOutQuint
{
    return GTMMotionCurveMakeBezier(0.86f, 0.0f, 0.07f, 1.0f);
}

+ (GTMMotionCurve)easeInExpo
{
    return GTMMotionCurveMakeBezier(0.95f, 0.05f, 0.795f, 0.035f);
}

+ (GTMMotionCurve)easeOutExpo
{
    return GTMMotionCurveMakeBezier(0.19f, 1.0f, 0.22f, 1.0f);
}

+ (GTMMotionCurve)easeInOutExpo
{
    return GTMMotionCurveMakeBezier(1.0f, 0.0f, 0.0f, 1.0f);
}

+ (GTMMotionCurve)easeInCirc
{
    return GTMMotionCurveMakeBezier(0.6f, 0.04f, 0.98f, 0.335f);
}

+ (GTMMotionCurve)easeOutCirc
{
    return GTMMotionCurveMakeBezier(0.075f, 0.82f, 0.165f, 1.0f);
}

+ (GTMMotionCurve)easeInOutCirc
{
    return GTMMotionCurveMakeBezier(0.785f, 0.135f, 0.15f, 0.86f);
}

+ (GTMMotionCurve)easeInBack
{
    return GTMMotionCurveMakeBezier(0.6f, -0.28f, 0.735f, 0.045f);
}

+ (GTMMotionCurve)easeOutBack
{
    return GTMMotionCurveMakeBezier(0.175f, 0.885f, 0.32f, 1.275f);
}

+ (GTMMotionCurve)easeInOutBack
{
    return GTMMotionCurveMakeBezier(0.68f, -0.55f, 0.265f, 1.55f);
}

+ (GTMMotionCurve)spring:(CGFloat)mass tension:(CGFloat)tension friction:(CGFloat)friction
{
    return GTMMotionCurveMakeSpring(mass, tension, friction);
}

+ (GTMMotionCurve)custom:(CGFloat)p1x p1y:(CGFloat)p1y p2x:(CGFloat)p2x p2y:(CGFloat)p2y
{
    return GTMMotionCurveMakeBezier(p1x, p1y, p2x, p2y);
}

@end
