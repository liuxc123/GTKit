//
//  CAMediaTimingFunction+MotionAnimator.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

// Returns a timing function with the given control points.
FOUNDATION_EXPORT
CAMediaTimingFunction* GTMTimingFunctionWithControlPoints(CGFloat controlPoints[4]);
