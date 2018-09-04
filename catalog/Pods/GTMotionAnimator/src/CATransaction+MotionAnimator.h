//
//  CATransaction+MotionAnimator.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CATransaction (MotionAnimator)

/**
 Accessor for the "timeScaleFactor" per-thread transaction property.

 Returns the transaction-specific time scale factor to be applied to animator animations.
 */
+ (nullable NSNumber *)gtm_timeScaleFactor;

/**
 Setter for the "timeScaleFactor" per-thread transaction property.

 Sets a transaction-specific time scale factor to be applied to animator animations.

 @param timeScaleFactor If nil, the animator's `timeScaleFactor` will be used instead. Should be a
 CGFloat value type.
 */
+ (void)gtm_setTimeScaleFactor:(nullable NSNumber *)timeScaleFactor;

@end
