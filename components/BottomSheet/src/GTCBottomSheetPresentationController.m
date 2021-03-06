//
//  GTCBottomSheetPresentationController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "GTCBottomSheetPresentationController.h"
#import "GTMath.h"
#import "private/GTCSheetContainerView.h"

static UIScrollView *GTCBottomSheetGetPrimaryScrollView(UIViewController *viewController) {
    UIScrollView *scrollView = nil;

    // Ensure the view is loaded - occasionally during non-animated transitions the view may not be
    // loaded yet (but the scrollview is still needed for scroll-tracking to work properly).
    if (![viewController isViewLoaded]) {
        (void)viewController.view;
    }

    if ([viewController isKindOfClass:[GTCBottomSheetController class]]) {
        viewController = ((GTCBottomSheetController *)viewController).contentViewController;
    }

    if ([viewController.view isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)viewController.view;
    } else if ([viewController.view isKindOfClass:[UIWebView class]]) {
        scrollView = ((UIWebView *)viewController.view).scrollView;
    } else if ([viewController isKindOfClass:[UICollectionViewController class]]) {
        scrollView = ((UICollectionViewController *)viewController).collectionView;
    }
    return scrollView;
}

@interface GTCBottomSheetPresentationController () <GTCSheetContainerViewDelegate>
@end


@implementation GTCBottomSheetPresentationController{
    UIView *_dimmingView;
    GTCSheetContainerView *_sheetView;
@private BOOL _scrimIsAccessibilityElement;
@private NSString *_scrimAccessibilityLabel;
@private NSString *_scrimAccessibilityHint;
@private UIAccessibilityTraits _scrimAccessibilityTraits;
}

@synthesize delegate;

- (UIView *)presentedView {
    return _sheetView;
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize containerSize = self.containerView.frame.size;
    CGSize preferredSize = self.presentedViewController.preferredContentSize;

    if (preferredSize.width > 0 && preferredSize.width < containerSize.width) {
        // We only customize the width and not the height here. GTCSheetContainerView lays out the
        // presentedView taking the preferred height in to account.
        CGFloat width = preferredSize.width;
        CGFloat leftPad = (containerSize.width - width) / 2;
        return CGRectMake(leftPad, 0, width, containerSize.height);
    } else {
        return [super frameOfPresentedViewInContainerView];
    }
}

- (void)presentationTransitionWillBegin {
    id<GTCBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(prepareForBottomSheetPresentation:)]) {
        [strongDelegate prepareForBottomSheetPresentation:self];
    }

    UIView *containerView = [self containerView];

    _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    _dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    _dimmingView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dimmingView.accessibilityTraits |= UIAccessibilityTraitButton;
    _dimmingView.isAccessibilityElement = _scrimIsAccessibilityElement;
    _dimmingView.accessibilityTraits = _scrimAccessibilityTraits;
    _dimmingView.accessibilityLabel = _scrimAccessibilityLabel;
    _dimmingView.accessibilityHint = _scrimAccessibilityHint;

    UIScrollView *scrollView = self.trackingScrollView;
    if (scrollView == nil) {
        scrollView = GTCBottomSheetGetPrimaryScrollView(self.presentedViewController);
    }
    CGRect sheetFrame = [self frameOfPresentedViewInContainerView];
    _sheetView = [[GTCSheetContainerView alloc] initWithFrame:sheetFrame
                                                  contentView:self.presentedViewController.view
                                                   scrollView:scrollView];
    _sheetView.delegate = self;
    _sheetView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [containerView addSubview:_dimmingView];
    [containerView addSubview:_sheetView];

    [self updatePreferredSheetHeight];

    // Add tap handler to dismiss the sheet.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:
                                          @selector(dismissPresentedControllerIfNecessary:)];
    tapGesture.cancelsTouchesInView = NO;
    containerView.userInteractionEnabled = YES;
    [containerView addGestureRecognizer:tapGesture];

    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [[self presentingViewController] transitionCoordinator];

    // Fade in the dimming view during the transition.
    _dimmingView.alpha = 0.0;
    [transitionCoordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
         self->_dimmingView.alpha = 1.0;
     }                                  completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [_dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [[self presentingViewController] transitionCoordinator];

    [transitionCoordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
         self->_dimmingView.alpha = 0.0;
     }                                  completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [_dimmingView removeFromSuperview];
    }
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    _sheetView.frame = [self frameOfPresentedViewInContainerView];
    [_sheetView layoutIfNeeded];
    [self updatePreferredSheetHeight];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
         self->_sheetView.frame = [self frameOfPresentedViewInContainerView];
         [self->_sheetView layoutIfNeeded];
         [self updatePreferredSheetHeight];
     }                        completion:nil];
}

- (void)updatePreferredSheetHeight {
    CGFloat preferredContentHeight = self.presentedViewController.preferredContentSize.height;

    // If |preferredSheetHeight| has not been specified, use half of the current height.
    if (GTCCGFloatEqual(preferredContentHeight, 0)) {
        preferredContentHeight = GTCRound(_sheetView.frame.size.height / 2);
    }
    _sheetView.preferredSheetHeight = preferredContentHeight;
}

- (void)dismissPresentedControllerIfNecessary:(UITapGestureRecognizer *)tapRecognizer {
    if (!_dismissOnBackgroundTap) {
        return;
    }
    // Only dismiss if the tap is outside of the presented view.
    UIView *contentView = self.presentedViewController.view;
    CGPoint pointInContentView = [tapRecognizer locationInView:contentView];
    if ([contentView pointInside:pointInContentView withEvent:nil]) {
        return;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    id<GTCBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:
         @selector(bottomSheetPresentationControllerDidDismissBottomSheet:)]) {
        [strongDelegate bottomSheetPresentationControllerDidDismissBottomSheet:self];
    }
}

#pragma mark - Properties

- (void)setIsScrimAccessibilityElement:(BOOL)isScrimAccessibilityElement {
    _scrimIsAccessibilityElement = isScrimAccessibilityElement;
    _dimmingView.isAccessibilityElement = isScrimAccessibilityElement;
}

- (BOOL)isScrimAccessibilityElement {
    return _scrimIsAccessibilityElement;
}

- (void)setScrimAccessibilityLabel:(NSString *)scrimAccessibilityLabel {
    _scrimAccessibilityLabel = scrimAccessibilityLabel;
    _dimmingView.accessibilityLabel = scrimAccessibilityLabel;
}

- (NSString *)scrimAccessibilityLabel {
    return _scrimAccessibilityLabel;
}

- (void)setScrimAccessibilityHint:(NSString *)scrimAccessibilityHint {
    _scrimAccessibilityHint = scrimAccessibilityHint;
    _dimmingView.accessibilityHint = scrimAccessibilityHint;
}

- (NSString *)scrimAccessibilityHint {
    return _scrimAccessibilityHint;
}

- (void)setScrimAccessibilityTraits:(UIAccessibilityTraits)scrimAccessibilityTraits {
    _scrimAccessibilityTraits = scrimAccessibilityTraits;
    _dimmingView.accessibilityTraits = scrimAccessibilityTraits;
}

- (UIAccessibilityTraits)scrimAccessibilityTraits {
    return _scrimAccessibilityTraits;
}

#pragma mark - GTCSheetContainerViewDelegate

- (void)sheetContainerViewDidHide:(nonnull __unused GTCSheetContainerView *)containerView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    id<GTCBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:
         @selector(bottomSheetPresentationControllerDidDismissBottomSheet:)]) {
        [strongDelegate bottomSheetPresentationControllerDidDismissBottomSheet:self];
    }
}

- (void)sheetContainerViewWillChangeState:(nonnull GTCSheetContainerView *)containerView
                               sheetState:(GTCSheetState)sheetState {
    id<GTCBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:
         @selector(bottomSheetWillChangeState:sheetState:)]) {
        [strongDelegate bottomSheetWillChangeState:self sheetState:sheetState];
    }
}


@end
