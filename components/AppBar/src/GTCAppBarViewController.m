//
//  GTCAppBarViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTCAppBarViewController.h"

#import "GTCAppBarContainerViewController.h"

#import <GTFInternationalization/GTFInternationalization.h>
#import <GTFTextAccessibility/GTFTextAccessibility.h>
#import "GTApplication.h"
#import "GTFlexibleHeader.h"
#import "GTIcons+ic_arrow_back.h"
#import "GTShadowElevations.h"
#import "GTShadowLayer.h"
#import "GTTypography.h"
#import "GTUIMetrics.h"
#import "private/GTAppBarStrings.h"
#import "private/GTAppBarStrings_table.h"

static NSString *const kBarStackKey = @"barStack";

// The Bundle for string resources.
static NSString *const kGTAppBarBundle = @"GTAppBar.bundle";


@implementation GTCAppBarViewController {
    NSLayoutConstraint *_verticalConstraint;
    NSLayoutConstraint *_topSafeAreaConstraint;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self GTCAppBarViewController_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self GTCAppBarViewController_commonInit];
    }
    return self;
}

- (void)GTCAppBarViewController_commonInit {
    // Shadow layer
    GTCFlexibleHeaderShadowIntensityChangeBlock intensityBlock =
    ^(CALayer *_Nonnull shadowLayer, CGFloat intensity) {
        CGFloat elevation = GTCShadowElevationAppBar * intensity;
        [(GTCShadowLayer *)shadowLayer setElevation:elevation];
    };
    [self.headerView setShadowLayer:[GTCShadowLayer layer] intensityDidChangeBlock:intensityBlock];

    [self.headerView forwardTouchEventsForView:self.headerStackView];
    [self.headerView forwardTouchEventsForView:self.navigationBar];

    self.headerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerStackView.topBar = self.navigationBar;
}

- (GTCHeaderStackView *)headerStackView {
    // Removed call to loadView here as we should never be calling it manually.
    // It previously replaced loadViewIfNeeded call that is only iOS 9.0+ to
    // make backwards compatible.
    // Underlying issue is you need view loaded before accessing. Below change will accomplish that
    // by calling for view.bounds initializing the stack view
    if (!_headerStackView) {
        _headerStackView = [[GTCHeaderStackView alloc] initWithFrame:CGRectZero];
    }
    return _headerStackView;
}

- (GTCNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[GTCNavigationBar alloc] init];
    }
    return _navigationBar;
}

- (UIBarButtonItem *)backButtonItem {
    UIViewController *parent = self.parentViewController;
    UINavigationController *navigationController = parent.navigationController;

    NSArray<UIViewController *> *viewControllerStack = navigationController.viewControllers;

    // This will be zero if there is no navigation controller, so a view controller which is not
    // inside a navigation controller will be treated the same as a view controller at the root of a
    // navigation controller
    NSUInteger index = [viewControllerStack indexOfObject:parent];

    UIViewController *iterator = parent;

    // In complex cases it might actually be a parent of @c fhvParent which is on the nav stack.
    while (index == NSNotFound && iterator && ![iterator isEqual:navigationController]) {
        iterator = iterator.parentViewController;
        index = [viewControllerStack indexOfObject:iterator];
    }

    if (index == NSNotFound) {
        NSCAssert(NO, @"View controller not present in its own navigation controller.");
        // This is not something which should ever happen, but just in case.
        return nil;
    }
    if (index == 0) {
        // The view controller is at the root of a navigation stack (or not in one).
        return nil;
    }
    UIViewController *previousViewControler = navigationController.viewControllers[index - 1];
    if ([previousViewControler isKindOfClass:[GTCAppBarContainerViewController class]]) {
        // Special case: if the previous view controller is a container controller, use its content
        // view controller.
        GTCAppBarContainerViewController *chvc =
        (GTCAppBarContainerViewController *)previousViewControler;
        previousViewControler = chvc.contentViewController;
    }
    UIBarButtonItem *backBarButtonItem = previousViewControler.navigationItem.backBarButtonItem;
    if (!backBarButtonItem) {
        UIImage *backButtonImage = [GTCIcons imageFor_ic_arrow_back];
        backButtonImage = [backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.navigationBar.gtf_effectiveUserInterfaceLayoutDirection ==
            UIUserInterfaceLayoutDirectionRightToLeft) {
            backButtonImage = [backButtonImage gtf_imageWithHorizontallyFlippedOrientation];
        }
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(didTapBackButton:)];
    }
    backBarButtonItem.accessibilityIdentifier = @"back_bar_button";
    NSString *key =
    kGTAppBarStringTable[kStr_GTAppBarBackButtonAccessibilityLabel];
    backBarButtonItem.accessibilityLabel =
    NSLocalizedStringFromTableInBundle(key,
                                       kGTAppBarStringsTableName,
                                       [[self class] bundle],
                                       @"Back");
    return backBarButtonItem;
}

#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kGTAppBarBundle]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTCAppBar class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle)resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.headerStackView];

    // Bar stack expands vertically, but has a margin above it for the status bar.
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint
                                                            constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", kBarStackKey]
                                                            options:0
                                                            metrics:nil
                                                            views:@{kBarStackKey : self.headerStackView}];
    [self.view addConstraints:horizontalConstraints];

    CGFloat topMargin = GTCDeviceTopSafeAreaInset();
    _verticalConstraint = [NSLayoutConstraint constraintWithItem:self.headerStackView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1
                                                        constant:topMargin];
    _verticalConstraint.active = !self.inferTopSafeAreaInsetFromViewController;

    _topSafeAreaConstraint =
    [NSLayoutConstraint constraintWithItem:self.headerView.topSafeAreaGuide
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.headerStackView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    _topSafeAreaConstraint.active = self.inferTopSafeAreaInsetFromViewController;

    [NSLayoutConstraint constraintWithItem:self.headerStackView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0].active = YES;
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    [super setInferTopSafeAreaInsetFromViewController:inferTopSafeAreaInsetFromViewController];

    if (inferTopSafeAreaInsetFromViewController) {
        self.topLayoutGuideAdjustmentEnabled = YES;
    }

    _verticalConstraint.active = !self.inferTopSafeAreaInsetFromViewController;
    _topSafeAreaConstraint.active = self.inferTopSafeAreaInsetFromViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIBarButtonItem *backBarButtonItem = [self backButtonItem];
    if (backBarButtonItem && !self.navigationBar.backItem) {
        self.navigationBar.backItem = backBarButtonItem;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        // We only update the top inset on iOS 11 because previously we were not adjusting the header
        // height to make it smaller when the status bar is hidden.
        _verticalConstraint.constant = GTCDeviceTopSafeAreaInset();
    }
#endif
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];

    [self.navigationBar observeNavigationItem:parent.navigationItem];
}

- (BOOL)accessibilityPerformEscape {
    [self dismissSelf];
    return YES;
}

#pragma mark User actions

- (void)didTapBackButton:(__unused id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    UIViewController *pvc = self.parentViewController;
    if (pvc.navigationController && pvc.navigationController.viewControllers.count > 1) {
        [pvc.navigationController popViewControllerAnimated:YES];
    } else {
        [pvc dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

#pragma mark - To be deprecated

@implementation GTCAppBar

- (instancetype)init {
    self = [super init];
    if (self) {
        _appBarViewController = [[GTCAppBarViewController alloc] init];
    }
    return self;
}

- (GTCFlexibleHeaderViewController *)headerViewController {
    return self.appBarViewController;
}

- (GTCHeaderStackView *)headerStackView {
    return self.appBarViewController.headerStackView;
}

- (GTCNavigationBar *)navigationBar {
    return self.appBarViewController.navigationBar;
}

- (void)addSubviewsToParent {
    GTCAppBarViewController *abvc = self.appBarViewController;
    NSAssert(abvc.parentViewController,
             @"appBarViewController does not have a parentViewController. "
             @"Use [self addChildViewController:appBar.appBarViewController]. "
             @"This warning only appears in DEBUG builds");
    if (abvc.view.superview == abvc.parentViewController.view) {
        return;
    }

    // Enforce the header's desire to fully cover the width of its parent view.
    CGRect frame = abvc.view.frame;
    frame.origin.x = 0;
    frame.size.width = abvc.parentViewController.view.bounds.size.width;
    abvc.view.frame = frame;

    [abvc.parentViewController.view addSubview:abvc.view];
    [abvc didMoveToParentViewController:abvc.parentViewController];
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    self.appBarViewController.inferTopSafeAreaInsetFromViewController =
    inferTopSafeAreaInsetFromViewController;
}

- (BOOL)inferTopSafeAreaInsetFromViewController {
    return self.appBarViewController.inferTopSafeAreaInsetFromViewController;
}

@end
