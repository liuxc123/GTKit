//
//  GTCAnimatorMotionSpecs.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <Foundation/Foundation.h>

#import <GTMotionInterchange/GTMotionInterchange.h>

#import "GTCAnimationType.h"

struct GTCAnimatorTimingFuntionType {
    GTMMotionTiming linear;
    GTMMotionTiming easeIn;
    GTMMotionTiming easeOut;
    GTMMotionTiming easeInOut;

    // from http://easings.net/
    GTMMotionTiming easeInSine;
    GTMMotionTiming easeOutSine;
    GTMMotionTiming easeInOutSine;

    GTMMotionTiming easeInCubic;
    GTMMotionTiming easeOutCubic;
    GTMMotionTiming easeInOutCubic;

    GTMMotionTiming easeInQuad;
    GTMMotionTiming easeOutQuad;
    GTMMotionTiming easeInOutQuad;

    GTMMotionTiming easeInQuart;
    GTMMotionTiming easeOutQuart;
    GTMMotionTiming easeInOutQuart;

    GTMMotionTiming easeInQuint;
    GTMMotionTiming easeOutQuint;
    GTMMotionTiming easeInOutQuint;

    GTMMotionTiming easeInExpo;
    GTMMotionTiming easeOutExpo;
    GTMMotionTiming easeInOutExpo;

    GTMMotionTiming easeInCirc;
    GTMMotionTiming easeOutCirc;
    GTMMotionTiming easeInOutCirc;

    GTMMotionTiming easeInBack;
    GTMMotionTiming easeOutBack;
    GTMMotionTiming easeInOutBack;

} NS_SWIFT_NAME(AnimatorTimingFuntionType);
typedef struct GTCAnimatorTimingFuntionType GTCAnimatorTimingFuntionType;

struct GTCAnimatorMotionSpec {
    GTCWay way;
    GTCDirection direction;
    GTCFadeWay fadeway;
    GTCAxis along;
    GTCRotationDirection rotationDirection;
    GTCRun run;

    NSInteger repeatCount;
    double x;
    double y;
    double fromX;
    double fromY;
    double toX;
    double toY;

} NS_SWIFT_NAME(AnimatorMotionSpec);;
typedef struct GTCAnimatorMotionSpec GTCAnimatorMotionSpec;

@interface GTCAnimatorMotionSpecs : NSObject

+ (GTCAnimatorMotionSpec)slide:(GTCWay)way direction:(GTCDirection)direction;

+ (GTCAnimatorMotionSpec)squeeze:(GTCWay)way direction:(GTCDirection)direction;

+ (GTCAnimatorMotionSpec)slideFade:(GTCWay)way direction:(GTCDirection)direction;

+ (GTCAnimatorMotionSpec)squeezeFade:(GTCWay)way direction:(GTCDirection)direction;

+ (GTCAnimatorMotionSpec)fade:(GTCFadeWay)way;

+ (GTCAnimatorMotionSpec)zoom:(GTCWay)way;

+ (GTCAnimatorMotionSpec)zoomInvert:(GTCWay)way;

+ (GTCAnimatorMotionSpec)shake:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)pop:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)squash:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)flip:(GTCAxis)along;

+ (GTCAnimatorMotionSpec)morph:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)flash:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)wobble:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)swing:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)rotate:(GTCRotationDirection)direction repeatCount:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)moveTo:(double)x y:(double)y;

+ (GTCAnimatorMotionSpec)moveBy:(double)x y:(double)y;

+ (GTCAnimatorMotionSpec)scale:(double)fromX fromY:(double)fromY toX:(double)toX toY:(double)toY;

+ (GTCAnimatorMotionSpec)spin:(NSInteger)repeatCount;

+ (GTCAnimatorMotionSpec)none;

// This object is not meant to be instantiated.
- (instancetype)init NS_UNAVAILABLE;

@end
