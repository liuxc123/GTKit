//
//  GTCBottomAppBarAttributes.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

// The height of the bottom app bar navigation area in collapsed state.
static const CGFloat kGTCBottomAppBarHeight = 96.f;

// The offset from the top of the navigation view of the bottom app bar to the
// bottom app bar position
static const CGFloat kGTCBottomAppBarNavigationViewYOffset = 38.f;

// The horizontal position of the center of the floating button when in leading or trailing state.
static const CGFloat kGTCBottomAppBarFloatingButtonPositionX = 64.f;

// The delta radius of the path cut for the floating button to the floating button's radius.
static const CGFloat kGTCBottomAppBarFloatingButtonRadiusOffset = 4.f;

// The duration of the enter animation of the path cut, same as floating button enter animation.
static const NSTimeInterval kGTCFloatingButtonEnterDuration = 0.270f;

// The duration of the exit animation of the path cut, same as floating button exit animation.
static const NSTimeInterval kGTCFloatingButtonExitDuration = 0.180f;

