//
//  CAMediaTimingFunction+GTCAnimationTiming.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import "CAMediaTimingFunction+GTCAnimationTiming.h"

@implementation CAMediaTimingFunction (GTCAnimationTiming)

+ (CAMediaTimingFunction *)gtc_functionWithType:(GTCAnimationTimingFunction)type {
    switch (type) {
        case GTCAnimationTimingFunctionStandard:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:0.2f:1.0f];
        case GTCAnimationTimingFunctionDeceleration:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.0f:0.0f:0.2f:1.0f];
        case GTCAnimationTimingFunctionAcceleration:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:1.0f:1.0f];
        case GTCAnimationTimingFunctionSharp:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:0.6f:1.0f];
    }
    NSAssert(NO, @"Invalid GTCAnimationTimingFunction value %i.", (int)type);
    // Reasonable default to use in Release mode for garbage input.
    return nil;
}

@end
