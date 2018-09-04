#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CATransaction+MotionAnimator.h"
#import "GTMAnimatableKeyPaths.h"
#import "GTMCoreAnimationTraceable.h"
#import "GTMMotionAnimator.h"
#import "GTMotionAnimator.h"

FOUNDATION_EXPORT double GTMotionAnimatorVersionNumber;
FOUNDATION_EXPORT const unsigned char GTMotionAnimatorVersionString[];

