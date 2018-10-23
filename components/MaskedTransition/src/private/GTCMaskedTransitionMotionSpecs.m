//
//  GTCMaskedTransitionMotionSpecs.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import "GTCMaskedTransitionMotionSpecs.h"

@implementation GTCMaskedTransitionMotionSpecs

+ (GTMMotionCurve)easeInEaseOut {
    return GTMMotionCurveMakeBezier(0.4f, 0.0f, 0.2f, 1.0f);
}

+ (GTMMotionCurve)easeIn {
    return GTMMotionCurveMakeBezier(0.4f, 0.0f, 1.0f, 1.0f);
}

+ (GTMMotionCurve)easeOut {
    return GTMMotionCurveMakeBezier(0.0f, 0.0f, 0.2f, 1.0f);
}

+ (GTCMaskedTransitionMotionSpec)fullscreen {
    GTMMotionCurve easeInEaseOut = [self easeInEaseOut];
    GTMMotionCurve easeIn = [self easeIn];
    return (GTCMaskedTransitionMotionSpec){
        .expansion = {
            .iconFade = {
                .delay = 0.000, .duration = 0.075, .curve = easeInEaseOut,
            },
            .contentFade = {
                .delay = 0.150, .duration = 0.225, .curve = easeInEaseOut,
            },
            .floodBackgroundColor = {
                .delay = 0.000, .duration = 0.075, .curve = easeInEaseOut,
            },
            .maskTransformation = {
                .delay = 0.000, .duration = 0.105, .curve = easeIn,
            },
            .horizontalMovement = {.curve = { .type = GTMMotionCurveTypeInstant }},
            .verticalMovement = {
                .delay = 0.045, .duration = 0.330, .curve = easeInEaseOut,
            },
            .scrimFade = {
                .delay = 0.000, .duration = 0.150, .curve = easeInEaseOut,
            },
            .overallDuration = 0.375
        },
        .shouldSlideWhenCollapsed = true,
        .isCentered = false
    };
}

+ (GTCMaskedTransitionMotionSpec)bottomSheet {
    GTMMotionCurve easeInEaseOut = [self easeInEaseOut];
    GTMMotionCurve easeIn = [self easeIn];
    return (GTCMaskedTransitionMotionSpec){
        .expansion = {
            .iconFade = {
                .delay = 0.000, .duration = 0.075, .curve = easeInEaseOut, // No spec
            },
            .contentFade = { // No spec for this
                .delay = 0.100, .duration = 0.200, .curve = easeInEaseOut,
            },
            .floodBackgroundColor = {
                .delay = 0.000, .duration = 0.075, .curve = easeInEaseOut,
            },
            .maskTransformation = {
                .delay = 0.000, .duration = 0.105, .curve = easeIn,
            },
            .horizontalMovement = {.curve = { .type = GTMMotionCurveTypeInstant }},
            .verticalMovement = {
                .delay = 0.045, .duration = 0.330, .curve = easeInEaseOut,
            },
            .scrimFade = {
                .delay = 0.000, .duration = 0.150, .curve = easeInEaseOut,
            },
            .overallDuration = 0.375
        },
        .shouldSlideWhenCollapsed = true,
        .isCentered = false
    };
}

+ (GTCMaskedTransitionMotionSpec)bottomCard {
    GTMMotionCurve easeInEaseOut = [self easeInEaseOut];
    GTMMotionCurve easeIn = [self easeIn];
    GTMMotionCurve easeOut = [self easeOut];
    return (GTCMaskedTransitionMotionSpec){
        .expansion = {
            .iconFade = {
                .delay = 0.000, .duration = 0.120, .curve = easeInEaseOut,
            },
            .contentFade = {
                .delay = 0.150, .duration = 0.150, .curve = easeInEaseOut,
            },
            .floodBackgroundColor = {
                .delay = 0.075, .duration = 0.075, .curve = easeInEaseOut,
            },
            .maskTransformation = {
                .delay = 0.045, .duration = 0.225, .curve = easeIn,
            },
            .horizontalMovement = {
                .delay = 0.000, .duration = 0.150, .curve = easeInEaseOut,
            },
            .verticalMovement = {
                .delay = 0.000, .duration = 0.345, .curve = easeInEaseOut,
            },
            .scrimFade = {
                .delay = 0.075, .duration = 0.150, .curve = easeInEaseOut,
            },
            .overallDuration = 0.345
        },
        .collapse = {
            .iconFade = {
                .delay = 0.150, .duration = 0.150, .curve = easeInEaseOut,
            },
            .contentFade = {
                .delay = 0.000, .duration = 0.075, .curve = easeIn,
            },
            .floodBackgroundColor = {
                .delay = 0.060, .duration = 0.150, .curve = easeInEaseOut,
            },
            .maskTransformation = {
                .delay = 0.000, .duration = 0.180, .curve = easeOut,
            },
            .horizontalMovement = {
                .delay = 0.045, .duration = 0.255, .curve = easeInEaseOut,
            },
            .verticalMovement = {
                .delay = 0.000, .duration = 0.255, .curve = easeInEaseOut,
            },
            .scrimFade = {
                .delay = 0.000, .duration = 0.150, .curve = easeInEaseOut,
            },
            .overallDuration = 0.300
        },
        .shouldSlideWhenCollapsed = false,
        .isCentered = true
    };
}

+ (GTCMaskedTransitionMotionSpec)toolbar {
    GTMMotionCurve easeInEaseOut = [self easeInEaseOut];
    GTMMotionCurve easeIn = [self easeIn];
    GTMMotionCurve easeOut = [self easeOut];
    return (GTCMaskedTransitionMotionSpec){
        .expansion = {
            .iconFade = {
                .delay = 0.000, .duration = 0.120, .curve = easeInEaseOut,
            },
            .contentFade = {
                .delay = 0.150, .duration = 0.150, .curve = easeInEaseOut,
            },
            .floodBackgroundColor = {
                .delay = 0.075, .duration = 0.075, .curve = easeInEaseOut,
            },
            .maskTransformation = {
                .delay = 0.045, .duration = 0.225, .curve = easeIn,
            },
            .horizontalMovement = {
                .delay = 0.000, .duration = 0.300, .curve = easeInEaseOut,
            },
            .verticalMovement = {
                .delay = 0.000, .duration = 0.120, .curve = easeInEaseOut,
            },
            .scrimFade = {
                .delay = 0.075, .duration = 0.150, .curve = easeInEaseOut,
            },
            .overallDuration = 0.300
        },
        .collapse = {
            .iconFade = {
                .delay = 0.150, .duration = 0.150, .curve = easeInEaseOut,
            },
            .contentFade = {
                .delay = 0.000, .duration = 0.075, .curve = easeIn,
            },
            .floodBackgroundColor = {
                .delay = 0.060, .duration = 0.150, .curve = easeInEaseOut,
            },
            .maskTransformation = {
                .delay = 0.000, .duration = 0.180, .curve = easeOut,
            },
            .horizontalMovement = {
                .delay = 0.105, .duration = 0.195, .curve = easeInEaseOut,
            },
            .verticalMovement = {
                .delay = 0.000, .duration = 0.255, .curve = easeInEaseOut,
            },
            .scrimFade = {
                .delay = 0.000, .duration = 0.150, .curve = easeInEaseOut,
            },
            .overallDuration = 0.300
        },
        .shouldSlideWhenCollapsed = false,
        .isCentered = true
    };
}


@end
