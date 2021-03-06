//
//  GTCFlexibleHeaderViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTCFlexibleHeaderViewController.h"

#import "GTApplication.h"
#import "GTUIMetrics.h"
#import "GTCFlexibleHeaderContainerViewController.h"
#import "GTCFlexibleHeaderView.h"
#import "GTCFlexibleHeaderView+ShiftBehavior.h"
#import "private/GTCFlexibleHeaderView+Private.h"
#import <GTFTextAccessibility/GTFTextAccessibility.h>

@interface UIView ()
- (UIEdgeInsets)safeAreaInsets; // For pre-iOS 11 SDK targets.
@end

static inline BOOL ShouldUseLightStatusBarOnBackgroundColor(UIColor *color) {
    if (CGColorGetAlpha(color.CGColor) < 1) {
        return NO;
    }

    // We assume that the light iOS status text is white and not big enough to be considered "large"
    // text according to the W3CAG 2.0 spec.
    return [GTFTextAccessibility textColor:[UIColor whiteColor]
                   passesOnBackgroundColor:color
                                   options:GTFTextAccessibilityOptionsNone];
}

static NSString *const GTCFlexibleHeaderViewControllerHeaderViewKey =
@"GTCFlexibleHeaderViewControllerHeaderViewKey";
static NSString *const GTCFlexibleHeaderViewControllerLayoutDelegateKey =
@"GTCFlexibleHeaderViewControllerLayoutDelegateKey";

// KVO contexts
static char *const kKVOContextGTCFlexibleHeaderViewController =
"kKVOContextGTCFlexibleHeaderViewController";


@interface GTCFlexibleHeaderViewController () <GTCFlexibleHeaderViewDelegate>

/*
 The current height offset of the flexible header controller with the addition of the current status
 bar state at any given time.

 This property is used to determine the bottom point of the |flexibleHeaderView| within the window.
 */
@property(nonatomic) CGFloat flexibleHeaderViewControllerHeightOffset;

/*
 This is the target top layout guide that we will modify such that it includes the flexible header's
 height and any top safe area insets we were able to infer.

 We hold a strong reference to it because on pre-iOS 11 devices UIKit will attempt to reset the
 top layout guide. We observe (using KVO) any changes made to the constraint and reset the
 constraint's length when a modification outside of our awareness occurs.
 */
@property(nonatomic, strong) NSLayoutConstraint *topLayoutGuideConstraint;

/*
 For avoiding re-entrant recursion while modifying the top layout guide.
 */
@property(nonatomic) BOOL isUpdatingTopLayoutGuide;

/*
 On pre-iOS 11 devices, we use this layout constraint to extract the top safe area inset from the
 root ancestor view controller.
 */
@property(nonatomic, strong) NSLayoutConstraint *topSafeAreaConstraint;

/*
 On iOS 11+ devices, we use this view to extract the top safe area inset from the root ancestor view
 controller.
 */
@property(nonatomic, strong) UIView *topSafeAreaView;

@end

@implementation GTCFlexibleHeaderViewController


@synthesize preferredStatusBarStyle = _preferredStatusBarStyle;

- (void)dealloc {
    // Clear KVO observers
    self.topLayoutGuideConstraint = nil;
    self.topSafeAreaConstraint = nil;
    self.topSafeAreaView = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonGTCFlexibleHeaderViewControllerInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([aDecoder containsValueForKey:GTCFlexibleHeaderViewControllerHeaderViewKey]) {
            _headerView = [aDecoder decodeObjectOfClass:[GTCFlexibleHeaderView class]
                                                 forKey:GTCFlexibleHeaderViewControllerHeaderViewKey];
        }

        if ([aDecoder containsValueForKey:GTCFlexibleHeaderViewControllerLayoutDelegateKey]) {
            _layoutDelegate =
            [aDecoder decodeObjectForKey:GTCFlexibleHeaderViewControllerLayoutDelegateKey];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.headerView forKey:GTCFlexibleHeaderViewControllerHeaderViewKey];
    if (_layoutDelegate) {
        [aCoder encodeConditionalObject:self.layoutDelegate
                                 forKey:GTCFlexibleHeaderViewControllerLayoutDelegateKey];
    }
}

- (void)commonGTCFlexibleHeaderViewControllerInit {
    _inferPreferredStatusBarStyle = YES;

    GTCFlexibleHeaderView *headerView =
    [[GTCFlexibleHeaderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerView.delegate = self;
    _headerView = headerView;
}

- (void)loadView {
    self.view = self.headerView;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];

    BOOL shouldDisableAutomaticInsetting = YES;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    // Prior to iOS 11 there was no way to know whether UIKit had injected insets into our
    // UIScrollView, so we disable automatic insetting on these devices. iOS 11 provides
    // the adjustedContentInset API which allows us to respond to changes in the safe area
    // insets, so on iOS 11 we actually expect iOS to manage the safe area insets.
    if (@available(iOS 11.0, *)) {
        shouldDisableAutomaticInsetting = NO;
    }
#endif
    if (shouldDisableAutomaticInsetting) {
        parent.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];

    // The header depends on the tracking scroll view to know how tall it should be.
    // If there is no tracking scroll view then we have to poke the header into sizing itself.
    if (!_headerView.trackingScrollView) {
        [_headerView sizeToFit];
    } else if (!_headerView.observesTrackingScrollViewScrollEvents) {
        [_headerView trackingScrollViewDidScroll];
    }

    if (self.topLayoutGuideAdjustmentEnabled) {
        [self updateTopLayoutGuide];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.inferTopSafeAreaInsetFromViewController) {
        // At this point we can be confident that our view controller ancestry is as complete as
        // possible, so we can now infer our top safe area source view controller.
        [self fhv_inferTopSafeAreaSourceViewController];

        // Querying the top layout guide ensures that the flexible header receives layout event when
        // the status bar visibility changes. This allows the flexible header to animate alongside any
        // status bar visibility changes.
        [self.parentViewController topLayoutGuide];
    }

    if (self.topLayoutGuideAdjustmentEnabled) {
        [self updateTopLayoutGuide];

    } else {
        // Legacy behavior.
        for (NSLayoutConstraint *constraint in self.parentViewController.view.constraints) {
            // Because topLayoutGuide is a readonly property on a viewController we must manipulate
            // the present one via the NSLayoutConstraint attached to it. Thus we keep reference to it.
            if (constraint.firstItem == self.parentViewController.topLayoutGuide &&
                constraint.secondItem == nil) {
                self.topLayoutGuideConstraint = constraint;
            }
        }

        // On moving to parentViewController, we calculate the height
        self.flexibleHeaderViewControllerHeightOffset = [self headerViewControllerHeight];
    }

#if DEBUG
    NSAssert(![self.parentViewController.parentViewController
               isKindOfClass:[GTCFlexibleHeaderContainerViewController class]],
             @"An instance of %@ has been injected into a view controller (%@) that is already"
             @" wrapped by an instance of %@ - this is not allowed and will cause double headers to"
             @" appear. Choose to either wrap or inject your view controller (preferring injection"
             @" where possible).",
             NSStringFromClass([self class]), NSStringFromClass([self.parentViewController class]),
             NSStringFromClass([GTCFlexibleHeaderContainerViewController class]));
#endif
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.inferPreferredStatusBarStyle) {
        UIColor *backgroundColor =
        [GTCFlexibleHeaderView appearance].backgroundColor ?: _headerView.backgroundColor;
        return (ShouldUseLightStatusBarOnBackgroundColor(backgroundColor)
                ? UIStatusBarStyleLightContent
                : UIStatusBarStyleDefault);
    } else {
        return _preferredStatusBarStyle;
    }
}

- (void)setPreferredStatusBarStyle:(UIStatusBarStyle)preferredStatusBarStyle {
    NSAssert(!self.inferPreferredStatusBarStyle,
             @"You must disable inferPreferredStatusBarStyle prior to setting a status bar style.");

    _preferredStatusBarStyle = preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return _headerView.prefersStatusBarHidden;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [_headerView viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (self.topLayoutGuideAdjustmentEnabled) {
        [self updateTopLayoutGuide];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _headerView.trackingScrollView) {
        [_headerView trackingScrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _headerView.trackingScrollView) {
        [_headerView trackingScrollViewDidEndDecelerating];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _headerView.trackingScrollView) {
        [_headerView trackingScrollViewDidEndDraggingWillDecelerate:decelerate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == _headerView.trackingScrollView) {
        [_headerView trackingScrollViewWillEndDraggingWithVelocity:velocity
                                               targetContentOffset:targetContentOffset];
    }
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == kKVOContextGTCFlexibleHeaderViewController) {
        void (^mainThreadWork)(void) = ^{
            if (object == self->_topLayoutGuideConstraint
                && self.topLayoutGuideAdjustmentEnabled) {
                [self updateTopLayoutGuide];
            }
            if (self.inferTopSafeAreaInsetFromViewController
                && (object == self->_topSafeAreaConstraint || object == self->_topSafeAreaView)) {
                [self->_headerView extractTopSafeAreaInset];
            }
        };

        // Ensure that UIKit modifications occur on the main thread.
        if ([NSThread isMainThread]) {
            mainThreadWork();
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:mainThreadWork];
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Top layout guide support

/*
 When the flexible header's height changes, we want to adjust the topLayoutGuide length of the
 content view controller so that its content can adjust accordingly. This is the same behavior that
 UIKit container view controllers provide.

 Unfortunately, topLayoutGuide is a read-only property on UIViewController with no way to
 override it, and no public setter for the length.

 The only known way to modify this property programmatically is to access the view controller's
 view constraints and extract the first constraint that contains the top layout guide (and only
 the top layout guide). Modifying the "constant" property of this constraint has the
 undocumented side effect of also updating the topLayoutGuide's length.
 This approach is discussed here:
 https://stackoverflow.com/questions/19588171/how-to-set-toplayoutguide-position-for-child-view-controller

 Also see this open radar feature request for a mutable top layout guide:
 http://www.openradar.me/19984939
 */
- (void)fhv_extractTopLayoutGuideConstraint {
    UIViewController *topLayoutGuideViewController =
    [self fhv_topLayoutGuideViewControllerWithFallback];
    if (!topLayoutGuideViewController.isViewLoaded) {
        self.topLayoutGuideConstraint = nil;
        return;
    }
    if (self.topLayoutGuideAdjustmentEnabled
        || [topLayoutGuideViewController.view.constraints count] > 0) {
        self.topLayoutGuideConstraint =
        [self fhv_topLayoutGuideConstraintForViewController:topLayoutGuideViewController];
    }
}

- (NSLayoutConstraint *)
fhv_topLayoutGuideConstraintForViewController:(UIViewController *)viewController {
    // Note: accessing topLayoutGuide has the side effect of setting up all of the view controller
    // constraints. We need to access this property before we enter the for loop, otherwise
    // view.constraints will be empty.
    id<UILayoutSupport> topLayoutGuide = viewController.topLayoutGuide;
    NSLayoutConstraint *foundConstraint = nil;
    for (NSLayoutConstraint *constraint in viewController.view.constraints) {
        if (constraint.firstItem == topLayoutGuide && constraint.secondItem == nil) {
            foundConstraint = constraint;
        }
    }
    return foundConstraint;
}

- (void)setTopLayoutGuideConstraint:(NSLayoutConstraint *)topLayoutGuideConstraint {
    if (_topLayoutGuideConstraint == topLayoutGuideConstraint) {
        return;
    }

    /*
     On pre-iOS 11 devices, the top layout guide's constant gets set by UIKit multiple times on
     call stacks that we have no influence over, meaning it's easy for our custom top layout guide
     value to be lost (being reset to UIKit's default of "20" usually). We want to have final say on
     the value though, so we KVO the property and re-apply our calculated top layout guide any time
     the top layout guide is modified.

     We only do this on pre-iOS 11 devices because iOS 11 and above are less aggressive about setting
     the top layout guide constant (and clients should be relying on additionalSafeAreaInsets anyway).
     */
    BOOL shouldObserveLayoutGuideConstant = YES;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        shouldObserveLayoutGuideConstant = NO;
    }
#endif

    if (shouldObserveLayoutGuideConstant) {
        [_topLayoutGuideConstraint removeObserver:self
                                       forKeyPath:NSStringFromSelector(@selector(constant))
                                          context:kKVOContextGTCFlexibleHeaderViewController];
    }

    _topLayoutGuideConstraint = topLayoutGuideConstraint;

    if (shouldObserveLayoutGuideConstant) {
        [_topLayoutGuideConstraint addObserver:self
                                    forKeyPath:NSStringFromSelector(@selector(constant))
                                       options:NSKeyValueObservingOptionNew
                                       context:kKVOContextGTCFlexibleHeaderViewController];
    }
}

- (void)setTopSafeAreaConstraint:(NSLayoutConstraint *)topSafeAreaConstraint {
    if (_topSafeAreaConstraint == topSafeAreaConstraint) {
        return;
    }

    [_topSafeAreaConstraint removeObserver:self
                                forKeyPath:NSStringFromSelector(@selector(constant))
                                   context:kKVOContextGTCFlexibleHeaderViewController];

    _topSafeAreaConstraint = topSafeAreaConstraint;

    [_topSafeAreaConstraint addObserver:self
                             forKeyPath:NSStringFromSelector(@selector(constant))
                                options:NSKeyValueObservingOptionNew
                                context:kKVOContextGTCFlexibleHeaderViewController];
}

- (void)setTopSafeAreaView:(UIView *)topSafeAreaView {
    if (_topSafeAreaView == topSafeAreaView) {
        return;
    }

    [_topSafeAreaView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(safeAreaInsets))
                             context:kKVOContextGTCFlexibleHeaderViewController];

    _topSafeAreaView = topSafeAreaView;

    [_topSafeAreaView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(safeAreaInsets))
                          options:NSKeyValueObservingOptionNew
                          context:kKVOContextGTCFlexibleHeaderViewController];
}

- (UIViewController *)fhv_topLayoutGuideViewControllerWithFallback {
    UIViewController *topLayoutGuideViewController = self.topLayoutGuideViewController;
    if (!topLayoutGuideViewController && !self.topLayoutGuideAdjustmentEnabled) {
        topLayoutGuideViewController = self.parentViewController;
    }
    return topLayoutGuideViewController;
}

- (void)fhv_setTopLayoutGuideConstraintConstant:(CGFloat)constant {
    self.isUpdatingTopLayoutGuide = YES;
    self.topLayoutGuideConstraint.constant = constant;
    self.isUpdatingTopLayoutGuide = NO;
}

- (void)updateTopLayoutGuide {
    NSAssert([NSThread isMainThread],
             @"updateTopLayoutGuide must be called from the main thread.");
    NSAssert(!self.useAdditionalSafeAreaInsetsForWebKitScrollViews
             || (self.topLayoutGuideViewController != nil),
             @"If useAdditionalSafeAreaInsetsForWebKitScrollViews is enabled you must also set a"
             @"topLayoutGuideViewController.");
    // We observe (using KVO) the top layout guide's constant and re-invoke updateTopLayoutGuide
    // whenever it changes. We also change the constant in this method. So, to avoid a recursive
    // infinite loop we bail out early here if we're the ones that initiated the top layout guide
    // constant change.
    if (self.isUpdatingTopLayoutGuide) {
        return;
    }

    if (!self.topLayoutGuideAdjustmentEnabled) {
        // Legacy behavior
        [self fhv_setTopLayoutGuideConstraintConstant:self.flexibleHeaderViewControllerHeightOffset];
        return;
    }

    if (![self isViewLoaded]) {
        return;
    }
    if (!self.topLayoutGuideConstraint) {
        [self fhv_extractTopLayoutGuideConstraint];
    }
    CGFloat topInset = CGRectGetMaxY(_headerView.frame);
    // Avoid excessive re-calculations.
    if (self.topLayoutGuideConstraint.constant != topInset) {
        [self fhv_setTopLayoutGuideConstraintConstant:topInset];
    }

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        BOOL alwaysUseAdditionalSafeAreaInsets = NO;
        if (self.useAdditionalSafeAreaInsetsForWebKitScrollViews
            && [self.headerView trackingScrollViewIsWebKit]) {
            alwaysUseAdditionalSafeAreaInsets = YES;
        }

        UIViewController *topLayoutGuideViewController = [self fhv_topLayoutGuideViewControllerWithFallback];
        // If there is a tracking scroll view then the flexible header will manage safe area insets via
        // the tracking scroll view's contentInsets. Some day - in the long distant future when we only
        // support iOS 11 and up - we can probably drop the content inset adjustment behavior in favor
        // of modifying additionalSafeAreaInsets instead.
        if (self.headerView.trackingScrollView != nil && !alwaysUseAdditionalSafeAreaInsets) {
            // Reset the additional safe area insets if we are now tracking a scroll view.
            if (topLayoutGuideViewController != nil) {
                UIEdgeInsets additionalSafeAreaInsets =
                topLayoutGuideViewController.additionalSafeAreaInsets;
                additionalSafeAreaInsets.top = 0;
                topLayoutGuideViewController.additionalSafeAreaInsets = additionalSafeAreaInsets;
            }

        } else if (topLayoutGuideViewController != nil) {
            UIEdgeInsets additionalSafeAreaInsets = topLayoutGuideViewController.additionalSafeAreaInsets;
            // We need to avoid double-counting any top safe area amount because this will already be
            // taken into account as part of additionalSafeAreaInsets.
            topInset -= self.headerView.topSafeAreaGuideHeight;
            if (self.headerView.minMaxHeightIncludesSafeArea) {
                topInset = MIN(self.headerView.maximumHeight - GTCDeviceTopSafeAreaInset(), topInset);
            } else {
                topInset = MIN(self.headerView.maximumHeight, topInset);
            }
            additionalSafeAreaInsets.top = topInset;
            topLayoutGuideViewController.additionalSafeAreaInsets = additionalSafeAreaInsets;
        }
    }
#endif
}

- (CGFloat)headerViewControllerHeight {
    BOOL shiftEnabledForStatusBar =
    _headerView.shiftBehavior == GTCFlexibleHeaderShiftBehaviorEnabledWithStatusBar;
    CGFloat statusBarHeight =
    [UIApplication gtc_safeSharedApplication].statusBarFrame.size.height;
    CGFloat height =
    MAX(_headerView.frame.origin.y + _headerView.frame.size.height,
        shiftEnabledForStatusBar ? 0 : statusBarHeight);
    return height;
}

- (void)setTopLayoutGuideViewController:(UIViewController *)topLayoutGuideViewController {
    if (topLayoutGuideViewController == _topLayoutGuideViewController) {
        return;
    }
    _topLayoutGuideViewController = topLayoutGuideViewController;
    _topLayoutGuideAdjustmentEnabled = YES;

    if (self.inferTopSafeAreaInsetFromViewController) {
        // Need to re-infer the top safe area source view controller because it may now be a child of
        // the top layout guide view controller.
        [self fhv_inferTopSafeAreaSourceViewController];
    }

    if ([self isViewLoaded]) {
        [self fhv_extractTopLayoutGuideConstraint];
        [self updateTopLayoutGuide];
    }
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    _headerView.inferTopSafeAreaInsetFromViewController = inferTopSafeAreaInsetFromViewController;

    [self fhv_inferTopSafeAreaSourceViewController];
}

- (BOOL)inferTopSafeAreaInsetFromViewController {
    return _headerView.inferTopSafeAreaInsetFromViewController;
}

- (void)setUseAdditionalSafeAreaInsetsForWebKitScrollViews:
(BOOL)useAdditionalSafeAreaInsetsForWebKitScrollViews {
    _headerView.useAdditionalSafeAreaInsetsForWebKitScrollViews =
    useAdditionalSafeAreaInsetsForWebKitScrollViews;
}

- (BOOL)useAdditionalSafeAreaInsetsForWebKitScrollViews {
    return _headerView.useAdditionalSafeAreaInsetsForWebKitScrollViews;
}

#pragma mark - Top safe area inset extraction

- (BOOL)fhv_isViewControllerDescendantOfTopLayoutGuideViewController:(UIViewController *)child {
    // No need to walk the ancestry.
    if (self.topLayoutGuideViewController == nil) {
        return NO;
    }

    UIViewController *ancestorIterator = child;
    while (ancestorIterator != nil) {
        if (ancestorIterator == self.topLayoutGuideViewController) {
            return YES;
        }
        ancestorIterator = ancestorIterator.parentViewController;
    }
    return NO;
}

- (UIViewController *)fhv_rootAncestorOfViewController:(UIViewController *)viewController {
    while (viewController.parentViewController != nil) {
        viewController = viewController.parentViewController;
    }
    return viewController;
}

// This method makes the assumption that the root-most view controller is the best view controller
// to look at when determining the top safe area inset. It's possible that this assumption will not
// hold true in all cases, so we may also need to expose an explicit API for setting the top safe
// area source view controller.
- (void)fhv_inferTopSafeAreaSourceViewController {
    UIViewController *parent = self.parentViewController;
    if (parent == nil || !self.inferTopSafeAreaInsetFromViewController) {
        _headerView.topSafeAreaSourceViewController = nil;
        self.topSafeAreaConstraint = nil;
        self.topSafeAreaView = nil;
        return;
    }

    UIViewController *ancestor = [self fhv_rootAncestorOfViewController:parent];

    // Are we attempting to extract the top safe area inset from our top layout guide view controller?
    if (self.topLayoutGuideAdjustmentEnabled && ancestor == self.topLayoutGuideViewController) {
        // We can't use the provided ancestor because it's a child of the top layout guide view
        // controller. Doing so would result in the top layout guide being infinitely increased.
        // Let's use the top layout guide view controller's ancestor instead.
        ancestor = [self fhv_rootAncestorOfViewController:
                    self.topLayoutGuideViewController.parentViewController];
    }

    // if ancestor == nil at this point, then we're in a bad spot because there's nowhere for us to
    // extract a top safe area inset from. Should we throw an assert?
    NSAssert(ancestor != nil,
             @"inferTopSafeAreaInsetFromViewController is true but we were unable to infer a view controller"
             @" from which we could extract a safe area. Consider placing your view controller inside"
             @" a container view controller.");

    if (_headerView.topSafeAreaSourceViewController != ancestor) {
        _headerView.topSafeAreaSourceViewController = ancestor;

        BOOL shouldObserveLayoutGuide = YES;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
        if (@available(iOS 11.0, *)) {
            shouldObserveLayoutGuide = NO;
        }
#endif
        if (shouldObserveLayoutGuide) {
            self.topSafeAreaConstraint = [self fhv_topLayoutGuideConstraintForViewController:ancestor];
        } else {
            self.topSafeAreaView = ancestor.view;
        }
    }
}

#pragma mark GTCFlexibleHeaderViewDelegate

- (void)flexibleHeaderViewNeedsStatusBarAppearanceUpdate:
(__unused GTCFlexibleHeaderView *)headerView {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)flexibleHeaderViewFrameDidChange:(GTCFlexibleHeaderView *)headerView {
    if (self.topLayoutGuideAdjustmentEnabled) {
        [self updateTopLayoutGuide];

    } else {
        // Legacy behavior
        // Whenever the flexibleHeaderView's frame changes, we update the value of the height offset
        self.flexibleHeaderViewControllerHeightOffset = [self headerViewControllerHeight];

        // We must change the constant of the constraint attached to our parentViewController's
        // topLayoutGuide to trigger the re-layout of its subviews
        [self fhv_setTopLayoutGuideConstraintConstant:self.flexibleHeaderViewControllerHeightOffset];
    }

    [self.layoutDelegate flexibleHeaderViewController:self
                     flexibleHeaderViewFrameDidChange:headerView];
}


@end
