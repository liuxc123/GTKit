//
//  CAMediaTimingFunction+MotionAnimator.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "CAMediaTimingFunction+MotionAnimator.h"

CAMediaTimingFunction* GTMTimingFunctionWithControlPoints(CGFloat controlPoints[4]) {
    return [CAMediaTimingFunction functionWithControlPoints:(float)controlPoints[0]
                                                           :(float)controlPoints[1]
                                                           :(float)controlPoints[2]
                                                           :(float)controlPoints[3]];
}
