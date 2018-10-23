//
//  GTCMaskedTransitionMotionForContext.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTCMaskedTransitionMotionForContext.h"

GTCMaskedTransitionMotionSpec
GTCMaskedTransitionMotionSpecForContext(UIView *containerView,
                                        UIViewController *presentedViewController) {
    const CGRect foreBounds = presentedViewController.view.bounds;
    const CGRect foreFrame = presentedViewController.view.frame;
    const CGRect containerBounds = containerView.bounds;

    if (CGRectEqualToRect(presentedViewController.view.frame, containerBounds)) {
        return GTCMaskedTransitionMotionSpecs.fullscreen;

    } else if (foreBounds.size.width == containerBounds.size.width
               && CGRectGetMaxY(foreFrame) == CGRectGetMaxY(containerBounds)) {
        if (foreFrame.size.height > 100) {
            return GTCMaskedTransitionMotionSpecs.bottomSheet;

        } else {
            return GTCMaskedTransitionMotionSpecs.toolbar;
        }

    } else if (foreBounds.size.width < containerBounds.size.width) {
        return GTCMaskedTransitionMotionSpecs.bottomCard;
    }

    return GTCMaskedTransitionMotionSpecs.fullscreen;
}
