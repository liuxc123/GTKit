//
//  GTCActivityIndicatorMotionSpec.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import "GTCActivityIndicatorMotionSpec.h"

@implementation GTCActivityIndicatorMotionSpec

+ (NSTimeInterval)pointCycleDuration {
    return 4.0 / 3.0;
}

+ (NSTimeInterval)pointCycleMinimumVariableDuration {
    return self.pointCycleDuration / 8;
}

+ (GTCActivityIndicatorMotionSpecIndeterminate)loopIndeterminate {
    NSTimeInterval pointCycleDuration = self.pointCycleDuration;
    GTMMotionCurve linear = GTMMotionCurveMakeBezier(0, 0, 1, 1);
    return (GTCActivityIndicatorMotionSpecIndeterminate){
        .outerRotation = {
            .duration = pointCycleDuration, .curve = linear,
        },
        .innerRotation = {
            .duration = pointCycleDuration, .curve = linear,
        },
        .strokeStart = {
            .delay = pointCycleDuration / 2,
            .duration = pointCycleDuration / 2,
            .curve = GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f),
        },
        .strokeEnd = {
            .duration = pointCycleDuration,
            .curve = GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f),
        },
    };
}

+ (GTCActivityIndicatorMotionSpecTransitionToDeterminate)willChangeToDeterminate {
    GTMMotionCurve linear = GTMMotionCurveMakeBezier(0, 0, 1, 1);
    return (GTCActivityIndicatorMotionSpecTransitionToDeterminate) {
        // Transition timing is calculated at runtime - any duration/delay values provided here will
        // by scaled by the calculated duration.
        .innerRotation = {
            .duration = 1, .curve = linear,
        },
        .strokeEnd = {
            .duration = 1, .curve = GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f),
        },
    };
}

+ (GTCActivityIndicatorMotionSpecTransitionToIndeterminate)willChangeToIndeterminate {
    return (GTCActivityIndicatorMotionSpecTransitionToIndeterminate){
        // Transition timing is calculated at runtime.
        .strokeStart = {
            .curve = GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f),
        },
        .strokeEnd = {
            .curve = GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f),
        },
    };
}

+ (GTCActivityIndicatorMotionSpecProgress)willChangeProgress {
    return (GTCActivityIndicatorMotionSpecProgress){
        .strokeEnd = {
            .duration = self.pointCycleDuration / 2,
            .curve = GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f),
        }
    };
}

@end
