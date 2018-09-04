//
//  CABasicAnimation+MotionAnimator.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#ifdef IS_BAZEL_BUILD
#import "GTMotionInterchange.h"
#else
#import <GTMotionInterchange/GTMotionInterchange.h>
#endif

// Returns a basic animation configured with the provided traits and scale factor.
FOUNDATION_EXPORT
CABasicAnimation *GTMAnimationFromTraits(GTMAnimationTraits *traits, CGFloat timeScaleFactor);

// Returns a Boolean indicating whether or not an animation with the given key path and toValue
// can be animated additively.
FOUNDATION_EXPORT BOOL GTMCanAnimationBeAdditive(NSString *keyPath, id toValue);

// If the animation's additive property is enabled, then its from/to values will be transformed into
// additive equivalents.
//
// Not all animation value types support being additive. If an animation's value type was not
// supported, the animation's values will not be modified.
FOUNDATION_EXPORT void GTMConfigureAnimation(CABasicAnimation *animation, GTMAnimationTraits *traits);
