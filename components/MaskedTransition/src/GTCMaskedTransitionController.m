//
//  GTCMaskedTransitionController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import "GTCMaskedTransitionController.h"

#import "private/GTCMaskedTransition.h"
#import "private/GTCMaskedPresentationController.h"
#import "private/GTCMaskedTransitionMotionForContext.h"

@implementation GTCMaskedTransitionController

- (instancetype)initWithSourceView:(UIView *)sourceView {
    self = [self init];
    if (self) {
        _sourceView = sourceView;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source {
    if (_sourceView == nil) {
        return nil;
    }
    return [[GTCMaskedTransition alloc] initWithSourceView:self.sourceView
                                                 direction:GTMTransitionDirectionForward];
}

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed {
    if (_sourceView == nil) {
        return nil;
    }
    GTCMaskedTransitionMotionSpec motionSpecification =
    GTCMaskedTransitionMotionSpecForContext(dismissed.presentingViewController.view.superview,
                                            dismissed);
    if (motionSpecification.shouldSlideWhenCollapsed) {
        return nil;
    }
    return [[GTCMaskedTransition alloc] initWithSourceView:self.sourceView
                                                 direction:GTMTransitionDirectionBackward];
}

- (UIPresentationController *)
presentationControllerForPresentedViewController:(UIViewController *)presented
presentingViewController:(UIViewController *)presenting
sourceViewController:(UIViewController *)source {
    return
    [[GTCMaskedPresentationController alloc] initWithPresentedViewController:presented
                                                    presentingViewController:presenting
                                               calculateFrameOfPresentedView:self.calculateFrameOfPresentedView
                                                                  sourceView:self.sourceView];
}


@end
