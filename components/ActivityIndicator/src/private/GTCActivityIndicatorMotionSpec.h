//
//  GTCActivityIndicatorMotionSpec.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import <Foundation/Foundation.h>
#import <GTMotionInterchange/GTMotionInterchange.h>

#ifndef GTC_SUBCLASSING_RESTRICTED
#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#define GTC_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))
#else
#define GTC_SUBCLASSING_RESTRICTED
#endif
#endif  // #ifndef GTC_SUBCLASSING_RESTRICTED

typedef struct GTCActivityIndicatorMotionSpecIndeterminate {
    GTMMotionTiming outerRotation;
    GTMMotionTiming innerRotation;
    GTMMotionTiming strokeStart;
    GTMMotionTiming strokeEnd;
} GTCActivityIndicatorMotionSpecIndeterminate;

typedef struct GTCActivityIndicatorMotionSpecTransitionToDeterminate {
    GTMMotionTiming innerRotation;
    GTMMotionTiming strokeEnd;
} GTCActivityIndicatorMotionSpecTransitionToDeterminate;

typedef struct GTCActivityIndicatorMotionSpecTransitionToIndeterminate {
    GTMMotionTiming strokeStart;
    GTMMotionTiming strokeEnd;
} GTCActivityIndicatorMotionSpecTransitionToIndeterminate;

typedef struct GTCActivityIndicatorMotionSpecProgress {
    GTMMotionTiming strokeEnd;
} GTCActivityIndicatorMotionSpecProgress;

GTC_SUBCLASSING_RESTRICTED
@interface GTCActivityIndicatorMotionSpec: NSObject

@property(nonatomic, class, readonly) NSTimeInterval pointCycleDuration;
@property(nonatomic, class, readonly) NSTimeInterval pointCycleMinimumVariableDuration;

@property(nonatomic, class, readonly) GTCActivityIndicatorMotionSpecIndeterminate loopIndeterminate;
@property(nonatomic, class, readonly)
GTCActivityIndicatorMotionSpecTransitionToDeterminate willChangeToDeterminate;
@property(nonatomic, class, readonly)
GTCActivityIndicatorMotionSpecTransitionToIndeterminate willChangeToIndeterminate;
@property(nonatomic, class, readonly) GTCActivityIndicatorMotionSpecProgress willChangeProgress;

// This object is not meant to be instantiated.
- (instancetype)init NS_UNAVAILABLE;

@end
