//
//  GTCAnimationTimingCurves.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/19.
//

#import <Availability.h>
#import <Foundation/Foundation.h>

#import <GTMotionInterchange/GTMotionInterchange.h>


// This macro is introduced in Xcode 9.
#ifndef CF_TYPED_ENUM // What follows is backwards compat for Xcode 8 and below.
#if __has_attribute(swift_wrapper)
#define CF_TYPED_ENUM __attribute__((swift_wrapper(enum)))
#else
#define CF_TYPED_ENUM
#endif
#endif

@interface GTCAnimationTimingCurves : NSObject

@property(nonatomic, class, readonly) GTMMotionCurve linear;
@property(nonatomic, class, readonly) GTMMotionCurve easeIn;
@property(nonatomic, class, readonly) GTMMotionCurve easeOut;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOut;

// from http://easings.net/
@property(nonatomic, class, readonly) GTMMotionCurve easeInSine;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutSine;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutSine;

@property(nonatomic, class, readonly) GTMMotionCurve easeInCubic;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutCubic;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutCubic;

@property(nonatomic, class, readonly) GTMMotionCurve easeInQuad;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutQuad;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutQuad;

@property(nonatomic, class, readonly) GTMMotionCurve easeInQuart;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutQuart;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutQuart;

@property(nonatomic, class, readonly) GTMMotionCurve easeInQuint;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutQuint;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutQuint;

@property(nonatomic, class, readonly) GTMMotionCurve easeInExpo;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutExpo;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutExpo;

@property(nonatomic, class, readonly) GTMMotionCurve easeInCirc;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutCirc;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutCirc;

@property(nonatomic, class, readonly) GTMMotionCurve easeInBack;
@property(nonatomic, class, readonly) GTMMotionCurve easeOutBack;
@property(nonatomic, class, readonly) GTMMotionCurve easeInOutBack;

+ (GTMMotionCurve)spring:(CGFloat)mass tension:(CGFloat)tension friction:(CGFloat)friction;

+ (GTMMotionCurve)custom:(CGFloat)p1x p1y:(CGFloat)p1y p2x:(CGFloat)p2x p2y:(CGFloat)p2y;

@end
