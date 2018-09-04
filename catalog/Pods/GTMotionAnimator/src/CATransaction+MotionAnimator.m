//
//  CATransaction+MotionAnimator.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "CATransaction+MotionAnimator.h"

static NSString *const kTimeScaleFactorKey = @"gtm_timeScaleFactor";

@implementation CATransaction (MotionAnimator)

+ (NSNumber *)gtm_timeScaleFactor {
    return [CATransaction valueForKey:kTimeScaleFactorKey];
}

+ (void)gtm_setTimeScaleFactor:(nullable NSNumber *)timeScaleFactor {
    return [CATransaction setValue:timeScaleFactor forKey:kTimeScaleFactorKey];
}

@end
