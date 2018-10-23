//
//  GTCFeatureHighlightViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightViewController.h"

#import <GTFTextAccessibility/GTFTextAccessibility.h>
#import "GTFeatureHighlightStrings.h"
#import "GTFeatureHighlightStrings_table.h"
#import "GTTypography.h"
#import "private/GTCFeatureHighlightAnimationController.h"
#import "private/GTCFeatureHighlightView+Private.h"

// The Bundle for string resources.
static NSString *const kMaterialFeatureHighlightBundle = @"MaterialFeatureHighlight.bundle";

static const CGFloat kGTCFeatureHighlightLineSpacing = 1.0f;
static const CGFloat kGTCFeatureHighlightPulseAnimationInterval = 1.5f;

@interface GTCFeatureHighlightViewController () <UIViewControllerTransitioningDelegate>
@property(nonatomic, nullable, weak) GTCFeatureHighlightView *featureHighlightView;
@end

@implementation GTCFeatureHighlightViewController {
    GTCFeatureHighlightAnimationController *_animationController;
    GTCFeatureHighlightCompletion _completion;
    NSString *_viewAccessiblityHint;
    NSTimer *_pulseTimer;
    UIView *_displayedView;
    UIView *_highlightedView;
}

- (nonnull instancetype)initWithHighlightedView:(nonnull UIView *)highlightedView
                                    andShowView:(nonnull UIView *)displayedView
                                     completion:(nullable GTCFeatureHighlightCompletion)completion {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _highlightedView = highlightedView;
        _displayedView = displayedView;
        _completion = completion;
        _animationController = [[GTCFeatureHighlightAnimationController alloc] init];
        _animationController.presenting = YES;
        _outerHighlightColor =
        [[UIColor blueColor] colorWithAlphaComponent:kGTCFeatureHighlightOuterHighlightAlpha];
        _innerHighlightColor = [UIColor whiteColor];

        _displayedView.accessibilityTraits = UIAccessibilityTraitButton;

        _viewAccessiblityHint = [[self class] dismissAccessibilityHint];

        super.transitioningDelegate = self;
        super.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.featureHighlightView.displayedView = _displayedView;
    self.featureHighlightView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.featureHighlightView.gtc_adjustsFontForContentSizeCategory =
    _gtc_adjustsFontForContentSizeCategory;

    __weak GTCFeatureHighlightViewController *weakSelf = self;
    self.featureHighlightView.interactionBlock = ^(BOOL accepted) {
        GTCFeatureHighlightViewController *strongSelf = weakSelf;
        [strongSelf dismiss:accepted];
    };

    UIGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptFeature)];
    [_displayedView addGestureRecognizer:tapGestureRecognizer];

    self.featureHighlightView.outerHighlightColor = _outerHighlightColor;
    self.featureHighlightView.innerHighlightColor = _innerHighlightColor;
    self.featureHighlightView.titleColor = _titleColor;
    self.featureHighlightView.bodyColor = _bodyColor;
    self.featureHighlightView.titleFont = _titleFont;
    self.featureHighlightView.bodyFont = _bodyFont;
    self.featureHighlightView.accessibilityHint = _viewAccessiblityHint;
}

/* Disable setter. Always use internal transition controller */
- (void)setTransitioningDelegate:
(__unused id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    NSAssert(NO, @"GTCAlertController.transitioningDelegate cannot be changed.");
    return;
}

/* Disable setter. Always use custom presentation style */
- (void)setModalPresentationStyle:(__unused UIModalPresentationStyle)modalPresentationStyle {
    NSAssert(NO, @"GTCAlertController.modalPresentationStyle cannot be changed.");
    return;
}

- (nonnull instancetype)initWithHighlightedView:(nonnull UIView *)highlightedView
                                     completion:(nullable GTCFeatureHighlightCompletion)completion {
    UIView *snapshotView = [highlightedView snapshotViewAfterScreenUpdates:YES];
    // We have to wrap the snapshoted view because _UIReplicantViews can't be accessibility elements.
    UIView *displayedView = [[UIView alloc] initWithFrame:snapshotView.bounds];
    [displayedView addSubview:snapshotView];

    // Copy the accessibility values from the view being highlighted.
    displayedView.isAccessibilityElement = YES;
    displayedView.accessibilityTraits = UIAccessibilityTraitButton;
    displayedView.accessibilityLabel = highlightedView.accessibilityLabel;
    displayedView.accessibilityValue = highlightedView.accessibilityValue;
    displayedView.accessibilityHint = highlightedView.accessibilityHint;

    return [self initWithHighlightedView:highlightedView
                             andShowView:displayedView
                              completion:completion];
}

- (void)loadView {
    self.view = [[GTCFeatureHighlightView alloc] initWithFrame:CGRectZero];
    self.featureHighlightView = (GTCFeatureHighlightView *)self.view;
}

- (void)viewWillLayoutSubviews {
    self.featureHighlightView.titleLabel.attributedText =
    [self attributedStringForString:self.titleText lineSpacing:kGTCFeatureHighlightLineSpacing];
    self.featureHighlightView.bodyLabel.attributedText =
    [self attributedStringForString:self.bodyText lineSpacing:kGTCFeatureHighlightLineSpacing];
}

- (void)dealloc {
    [_pulseTimer invalidate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGPoint point = [_highlightedView.superview convertPoint:_highlightedView.center
                                           toCoordinateSpace:self.featureHighlightView];
    self.featureHighlightView.highlightPoint = point;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _pulseTimer = [NSTimer scheduledTimerWithTimeInterval:kGTCFeatureHighlightPulseAnimationInterval
                                                   target:self.featureHighlightView
                                                 selector:@selector(animatePulse)
                                                 userInfo:NULL
                                                  repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_pulseTimer invalidate];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
         [self resetHighlightPoint];
     }
                                 completion:
     ^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
         [self resetHighlightPoint];
     }];
}

- (void)resetHighlightPoint {
    CGPoint point = [_highlightedView.superview convertPoint:_highlightedView.center
                                                      toView:self.featureHighlightView];
    self.featureHighlightView.highlightPoint = point;
    [self.featureHighlightView layoutIfNeeded];
    [self.featureHighlightView updateOuterHighlight];
}

- (void)setOuterHighlightColor:(UIColor *)outerHighlightColor {
    _outerHighlightColor = outerHighlightColor;
    if (self.isViewLoaded) {
        self.featureHighlightView.outerHighlightColor = outerHighlightColor;
    }
}

- (void)setInnerHighlightColor:(UIColor *)innerHighlightColor {
    _innerHighlightColor = innerHighlightColor;
    if (self.isViewLoaded) {
        self.featureHighlightView.innerHighlightColor = innerHighlightColor;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (self.isViewLoaded) {
        self.featureHighlightView.titleColor = titleColor;
    }
}

- (void)setBodyColor:(UIColor *)bodyColor {
    _bodyColor = bodyColor;
    if (self.isViewLoaded) {
        self.featureHighlightView.bodyColor = bodyColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if (self.isViewLoaded) {
        self.featureHighlightView.titleFont = titleFont;
    }
}

- (void)setBodyFont:(UIFont *)bodyFont {
    _bodyFont = bodyFont;
    if (self.isViewLoaded) {
        self.featureHighlightView.bodyFont = bodyFont;
    }
}

- (void)acceptFeature {
    [self dismiss:YES];
}

- (void)rejectFeature {
    [self dismiss:NO];
}

- (void)dismiss:(BOOL)accepted {
    _animationController.presenting = NO;
    if (accepted) {
        _animationController.dismissStyle = GTCFeatureHighlightDismissAccepted;
    } else {
        _animationController.dismissStyle = GTCFeatureHighlightDismissRejected;
    }
    [self dismissViewControllerAnimated:YES
                             completion:^() {
                                 if (self->_completion) {
                                     self->_completion(accepted);
                                 }
                             }];
}

#pragma mark - Dynamic Type

- (void)gtc_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtc_adjustsFontForContentSizeCategory = adjusts;

    if (_gtc_adjustsFontForContentSizeCategory) {
        [self updateFontsForDynamicType];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentSizeCategoryDidChange:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIContentSizeCategoryDidChangeNotification
                                                      object:nil];
    }
}

- (void)contentSizeCategoryDidChange:(__unused NSNotification *)notification {
    [self updateFontsForDynamicType];
}

- (void)updateFontsForDynamicType {
    [self.featureHighlightView updateTitleFont];
    [self.featureHighlightView updateBodyFont];
    [self.featureHighlightView layoutIfNeeded];
}

#pragma mark - Accessibility

- (BOOL)accessibilityPerformEscape {
    [self rejectFeature];

    return YES;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(__unused UIViewController *)presenting
sourceController:(__unused UIViewController *)source {
    if (presented == self) {
        return _animationController;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:
(UIViewController *)dismissed {
    if (dismissed == self) {
        return _animationController;
    }
    return nil;
}

#pragma mark - UIAccessibility

- (void)setAccessibilityHint:(NSString *)accessibilityHint {
    _viewAccessiblityHint = accessibilityHint;
    if (self.isViewLoaded) {
        self.featureHighlightView.accessibilityHint = accessibilityHint;
    }
}

- (NSString *)accessibilityHint {
    return _viewAccessiblityHint;
}

+ (NSString *)dismissAccessibilityHint {
    NSString *key =
    kGTFeatureHighlightStringTable[kStr_GTFeatureHighlightDismissAccessibilityHint];
    NSString *localizedString = NSLocalizedStringFromTableInBundle(
                                                                   key, kGTFeatureHighlightStringsTableName, [self bundle], @"Double-tap to dismiss.");
    return localizedString;
}

#pragma mark - Private

- (NSAttributedString *)attributedStringForString:(NSString *)string
                                      lineSpacing:(CGFloat)lineSpacing {
    if (!string) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;

    NSDictionary *attrs = @{NSParagraphStyleAttributeName : paragraphStyle};

    return [[NSAttributedString alloc] initWithString:string attributes:attrs];
}

#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kMaterialFeatureHighlightBundle]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTCFeatureHighlightView class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}


@end

