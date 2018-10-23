//
//  GTCTabBarViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCTabBarViewController.h"

#import "GTShadowElevations.h"
#import "GTShadowLayer.h"

static NSString *const GTCTabBarViewControllerViewControllersKey =
@"GTCTabBarViewControllerViewControllersKey";
static NSString *const GTCTabBarViewControllerSelectedViewControllerKey =
@"GTCTabBarViewControllerSelectedViewControllerKey";
static NSString *const GTCTabBarViewControllerDelegateKey = @"GTCTabBarViewControllerDelegateKey";
static NSString *const GTCTabBarViewControllerTabBarKey = @"GTCTabBarViewControllerTabBarKey";

const CGFloat GTCTabBarViewControllerAnimationDuration = 0.3f;

/**
 * View to host shadow for the tab bar.
 */
@interface GTCTabBarShadowView : UIView
@end

@implementation GTCTabBarShadowView

+ (Class)layerClass {
    return [GTCShadowLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCTabBarShadowViewInitialization];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCTabBarShadowViewInitialization];
    }
    return self;
}

- (void)commonGTCTabBarShadowViewInitialization {
    GTCShadowLayer *shadowLayer = (GTCShadowLayer *)self.layer;
    [shadowLayer setElevation:GTCShadowElevationMenu];
}

@end

@interface GTCTabBarViewController ()

@property(nonatomic, readwrite, nonnull) GTCTabBar *tabBar;

@end

@implementation GTCTabBarViewController {
    /** For showing/hiding, Animation needs to know where it wants to end up. */
    BOOL _tabBarWantsToBeHidden;
    GTCTabBarShadowView *_tabBarShadow;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewControllers = [aDecoder decodeObjectOfClass:[NSArray class]
                                                  forKey:GTCTabBarViewControllerViewControllersKey];
        self.selectedViewController =
        [aDecoder decodeObjectOfClass:[UIViewController class]
                               forKey:GTCTabBarViewControllerSelectedViewControllerKey];
        _tabBar = [aDecoder decodeObjectOfClass:[GTCTabBar class]
                                         forKey:GTCTabBarViewControllerTabBarKey];
        _delegate = [aDecoder decodeObjectForKey:GTCTabBarViewControllerDelegateKey];
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    // Already been setup through encoding/decoding
    if (self.tabBar) {
        return;
    }
    GTCTabBar *tabBar = [[GTCTabBar alloc] initWithFrame:CGRectZero];
    tabBar.alignment = GTCTabBarAlignmentJustified;
    tabBar.delegate = self;
    self.tabBar = tabBar;
    _tabBarShadow = [[GTCTabBarShadowView alloc] initWithFrame:CGRectZero];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_viewControllers forKey:GTCTabBarViewControllerViewControllersKey];
    [coder encodeConditionalObject:_selectedViewController
                            forKey:GTCTabBarViewControllerSelectedViewControllerKey];
    [coder encodeObject:_tabBar forKey:GTCTabBarViewControllerTabBarKey];
    [coder encodeConditionalObject:_delegate forKey:GTCTabBarViewControllerDelegateKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = self.view;
    view.clipsToBounds = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:_tabBarShadow];
    [view addSubview:self.tabBar];
    [self updateOldViewControllers:nil to:_viewControllers];
    [self updateOldSelectedViewController:nil to:_selectedViewController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateLayout];
}

#pragma mark - Properties

- (BOOL)tabBarHidden {
    return self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (_tabBar.hidden != hidden) {
        if (animated) {
            // Before entering our animation block put the view's layout in a good state.
            [self.view layoutIfNeeded];
        }
        _tabBarWantsToBeHidden = hidden;
        // Hiding the tab bar has the side effect of growing the current viewController to use that
        // space. This does that in its layoutSubViews.
        [self.view setNeedsLayout];
        if (animated) {
            if (!hidden) {
                // If we are showing, set the state before the animation.
                _tabBar.hidden = hidden;
                _tabBarShadow.hidden = hidden;
            }
            [UIView animateWithDuration:GTCTabBarViewControllerAnimationDuration
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(__unused BOOL finished) {
                                 // If we are hiding, set the state after the animation.
                                 self.tabBar.hidden = hidden;
                                 self->_tabBarShadow.hidden = hidden;
                             }];
        } else {
            _tabBar.hidden = hidden;
            _tabBarShadow.hidden = hidden;
        }
    }
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    NSArray<UIViewController *> *oldViewControllers = _viewControllers;
    _viewControllers = [viewControllers copy];
    [self updateOldViewControllers:oldViewControllers to:viewControllers];
}

- (void)updateOldViewControllers:(NSArray<UIViewController *> *)oldViewControllers
                              to:(NSArray<UIViewController *> *)viewControllers {
    if (!self.isViewLoaded || [oldViewControllers isEqual:viewControllers]) {
        return;
    }

    if (![oldViewControllers isEqual:viewControllers]) {
        // For all view controllers that this is removing, follow UIViewController.h's rules for
        // for removing a child view controller. See the comments in UIViewController.h for more
        // information.
        for (UIViewController *viewController in oldViewControllers) {
            if (![viewControllers containsObject:viewController]) {
                [viewController willMoveToParentViewController:nil];
                if (viewController.isViewLoaded) {
                    [viewController.view removeFromSuperview];
                }
                [viewController removeFromParentViewController];
            }
        }
        // Show the newly-visible view controller.
        [self updateTabBarItems];
    }
}

- (void)updateOldSelectedViewController:(nullable UIViewController *)oldSelectedViewController
                                     to:(nullable UIViewController *)selectedViewController {
    if (!self.isViewLoaded || oldSelectedViewController == selectedViewController) {
        return;
    }
    if (selectedViewController) {
        NSAssert([_viewControllers containsObject:selectedViewController], @"not one of us.");
    }

    if (![self.childViewControllers containsObject:selectedViewController]) {
        [self addChildViewController:selectedViewController];
        UIView *view = selectedViewController.view;
        [self.view addSubview:view];
        [selectedViewController didMoveToParentViewController:self];
    }
    [self updateTabBarItems];
    BOOL animated = NO;
    [oldSelectedViewController beginAppearanceTransition:NO animated:animated];
    [selectedViewController beginAppearanceTransition:YES animated:animated];

    [self transitionViewsWithoutAnimationFromViewController:oldSelectedViewController
                                           toViewController:selectedViewController];

    [oldSelectedViewController endAppearanceTransition];
    [selectedViewController endAppearanceTransition];

    if (selectedViewController) {
        self.tabBar.selectedItem = selectedViewController.tabBarItem;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setSelectedViewController:(nullable UIViewController *)selectedViewController {
    UIViewController *oldSelectedViewController = _selectedViewController;
    _selectedViewController = selectedViewController;
    [self updateOldSelectedViewController:oldSelectedViewController to:selectedViewController];
}

#pragma mark - private

// Encapsulate the actual view handling.
- (void)transitionViewsWithoutAnimationFromViewController:(UIViewController *)from
                                         toViewController:(UIViewController *)to {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    from.view.hidden = YES;
    to.view.hidden = NO;
}

// Either this has just come into existence or its array of viewControllers has changed.
// Update the TabBar from the array of viewControllers.
- (void)updateTabBarItems {
    NSMutableArray<UITabBarItem *> *items = [NSMutableArray array];
    BOOL hasTitles = NO;
    BOOL hasImages = NO;
    for (UIViewController *child in _viewControllers) {
        UITabBarItem *tabBarItem = child.tabBarItem;
        [items addObject:tabBarItem];
        if (tabBarItem.title.length) {
            hasTitles = YES;
        }
        if (tabBarItem.image) {
            hasImages = YES;
        }
    }
    // This class preserves the invariant that if the selected controller is not nil, it is contained
    // in the array of viewControllers.
    if (![_viewControllers containsObject:_selectedViewController]) {
        self.selectedViewController = nil;
    }
    self.tabBar.items = items;
    // The default height of the tab bar depends on the underlying UITabBarItems of
    // the viewControllers.
    if (hasImages && hasTitles) {
        self.tabBar.itemAppearance = GTCTabBarItemAppearanceTitledImages;
    } else if (hasImages) {
        self.tabBar.itemAppearance = GTCTabBarItemAppearanceImages;
    } else {
        self.tabBar.itemAppearance = GTCTabBarItemAppearanceTitles;
    }
    [self.view bringSubviewToFront:_tabBarShadow];
    [self.view bringSubviewToFront:self.tabBar];
}

- (nullable UIViewController *)controllerWithView:(nullable UIView *)view {
    for (UIViewController *child in _viewControllers) {
        if (child.view == view) {
            return child;
        }
    }
    return nil;
}

- (void)updateLayout {
    CGRect bounds = self.view.bounds;
    CGFloat tabBarHeight = [[_tabBar class] defaultHeightForBarPosition:UIBarPositionBottom
                                                         itemAppearance:_tabBar.itemAppearance];
    if (@available(iOS 11.0, *)) {
        tabBarHeight += self.view.safeAreaInsets.bottom;
    }

    CGRect currentViewFrame = bounds;
    CGRect tabBarFrame = CGRectMake(bounds.origin.x, bounds.origin.y + bounds.size.height,
                                    bounds.size.width, tabBarHeight);
    if (!_tabBarWantsToBeHidden) {
        CGRectDivide(bounds, &tabBarFrame, &currentViewFrame, tabBarHeight, CGRectMaxYEdge);
    }
    _tabBar.frame = tabBarFrame;
    _tabBarShadow.frame = tabBarFrame;
    _selectedViewController.view.frame = currentViewFrame;
}

#pragma mark -  GTCTabBarDelegate

- (BOOL)tabBar:(UITabBar *)tabBar shouldSelectItem:(UITabBarItem *)item {
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        NSUInteger index = [tabBar.items indexOfObject:item];
        if (index < _viewControllers.count) {
            UIViewController *newSelected = _viewControllers[index];
            return [_delegate tabBarController:self shouldSelectViewController:newSelected];
        }
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [tabBar.items indexOfObject:item];
    if (index < _viewControllers.count) {
        UIViewController *newSelected = _viewControllers[index];
        if (newSelected != self.selectedViewController) {
            self.selectedViewController = newSelected;
        }
        if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
            [_delegate tabBarController:self didSelectViewController:newSelected];
        }
    }
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    if (_tabBar == bar) {
        return UIBarPositionBottom;
    } else {
        return UIBarPositionAny;
    }
}

#pragma mark - UIViewController status bar

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return _selectedViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return _selectedViewController;
}

@end

