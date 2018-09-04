//
//  CAMediaTimingFunction+GTCAnimationTiming.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Material Design easing curve animation values.

 Use these easing curves to create smooth and consistent motion that conforms to Material Design.
 */
typedef NS_ENUM(NSUInteger, GTCAnimationTimingFunction) {
    /**
     This is the most frequently used interpolation curve for Material Design animations. This curve
     is slow both at the beginning and end. It has similar characteristics to the system's EaseInOut.
     This is known as Standard in the Material Design spec.
     */
    GTCAnimationTimingFunctionStandard,

    /**
     This curve should be used for motion when entering frame or when fading in from 0% opacity. This
     curve is slow at the end. It has similar characteristics to the system's EaseOut. This is known
     as Deceleration in the Material Design spec.
     */
    GTCAnimationTimingFunctionDeceleration,

    /**
     This curve should be used for motion when exiting frame or when fading out to 0% opacity. This
     curve is slow at the beginning. It has similar characteristics to the system's EaseIn. This
     is known as Acceleration in the Material Design spec.
     */
    GTCAnimationTimingFunctionAcceleration,

    /**
     This curve should be used for motion when elements quickly accelerate and decelerate. It is
     used by exiting elements that may return to the screen at any time. The deceleration is
     faster than the standard curve since it doesn't follow an exact path to the off-screen point.
     */
    GTCAnimationTimingFunctionSharp,

    /**
     Aliases for depreciated names
     */
    GTCAnimationTimingFunctionEaseInOut = GTCAnimationTimingFunctionStandard,
    GTCAnimationTimingFunctionEaseOut = GTCAnimationTimingFunctionDeceleration,
    GTCAnimationTimingFunctionEaseIn = GTCAnimationTimingFunctionAcceleration,

    /**
     Aliases for various specific timing curve recommendations.
     */
    GTCAnimationTimingFunctionTranslate = GTCAnimationTimingFunctionStandard,
    GTCAnimationTimingFunctionTranslateOnScreen = GTCAnimationTimingFunctionDeceleration,
    GTCAnimationTimingFunctionTranslateOffScreen = GTCAnimationTimingFunctionAcceleration,
    GTCAnimationTimingFunctionFadeIn = GTCAnimationTimingFunctionDeceleration,
    GTCAnimationTimingFunctionFadeOut = GTCAnimationTimingFunctionAcceleration,
};

/**
 Material Design animation curves.
 */
@interface CAMediaTimingFunction (GTCAnimationTiming)

/**
 Returns the corresponding CAMediaTimingFunction for the given curve specified by an enum. The most
 common curve is GTCAnimationTimingFunctionEaseInOut.

 @param type A Material Design media timing function.
 */
+ (nullable CAMediaTimingFunction *)gtc_functionWithType:(GTCAnimationTimingFunction)type;

@end
