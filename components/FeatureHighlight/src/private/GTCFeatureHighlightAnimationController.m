//
//  GTCFeatureHighlightAnimationController.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightAnimationController.h"

#import "GTCFeatureHighlightView+Private.h"

const NSTimeInterval kGTCFeatureHighlightPresentationDuration = 0.35f;
const NSTimeInterval kGTCFeatureHighlightDismissalDuration = 0.2f;

@implementation GTCFeatureHighlightAnimationController

- (NSTimeInterval)transitionDuration:
(nullable __unused id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
        return kGTCFeatureHighlightPresentationDuration;
    } else {
        return kGTCFeatureHighlightDismissalDuration;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    GTCFeatureHighlightView *highlightView = nil;
    if ([fromView isKindOfClass:[GTCFeatureHighlightView class]]) {
        highlightView = (GTCFeatureHighlightView *)fromView;
    } else if ([toView isKindOfClass:[GTCFeatureHighlightView class]]) {
        highlightView = (GTCFeatureHighlightView *)toView;
    }

    if (self.presenting) {
        [transitionContext.containerView addSubview:toView];
        toView.frame = [transitionContext finalFrameForViewController:toViewController];
    }

    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];

    [highlightView layoutIfNeeded];
    if (self.presenting) {
        [highlightView animateDiscover:transitionDuration];
    } else {
        switch (self.dismissStyle) {
            case GTCFeatureHighlightDismissAccepted:
                [highlightView animateAccepted:transitionDuration];
                break;

            case GTCFeatureHighlightDismissRejected:
                [highlightView animateRejected:transitionDuration];
                break;
        }
    }
    [UIView animateWithDuration:transitionDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         // We have to perform an animation on highlightView in this block or else UIKit
                         // will not know we are performing an animation and will call the completion block
                         // immediately, causing our CAAnimations to be cut short.
                         if (self.presenting) {
                             [highlightView layoutAppearing];
                         } else {
                             [highlightView layoutDisappearing];
                         }
                     }
                     completion:^(__unused BOOL finished) {
                         // If we're dismissing, remove the highlight view from the hierarchy
                         if (!self.presenting) {
                             [fromView removeFromSuperview];
                         }
                         [transitionContext completeTransition:YES];
                     }];
}

@end
