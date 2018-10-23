//
//  GTCProgressViewMotionSpec.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCProgressViewMotionSpec.h"

@implementation GTCProgressViewMotionSpec

+ (GTMMotionTiming)willChangeProgress {
    return (GTMMotionTiming){
        .duration = 0.250, .curve = GTMMotionCurveMakeBezier(0, 0, 1, 1),
    };
}

+ (GTMMotionTiming)willChangeHidden {
    return (GTMMotionTiming){
        .duration = 0.250, .curve = GTMMotionCurveMakeBezier(0, 0, 1, 1),
    };
}

@end
