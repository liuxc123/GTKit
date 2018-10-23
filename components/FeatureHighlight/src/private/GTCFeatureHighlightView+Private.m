//
//  GTCFeatureHighlightView+Private.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightView+Private.h"

#import "GTCFeatureHighlightDismissGestureRecognizer.h"
#import "GTCFeatureHighlightLayer.h"
#import <GTFTextAccessibility/GTFTextAccessibility.h>

#import "GTFeatureHighlightStrings.h"
#import "GTFeatureHighlightStrings_table.h"
#import "GTMath.h"
#import "GTTypography.h"

static inline CGFloat CGPointDistanceToPoint(CGPoint a, CGPoint b) {
    return GTCHypot(a.x - b.x, a.y - b.y);
}

const CGFloat kGTCFeatureHighlightMinimumInnerRadius = 44.0f;
const CGFloat kGTCFeatureHighlightInnerContentPadding = 10.0f;
const CGFloat kGTCFeatureHighlightInnerPadding = 20.0f;
const CGFloat kGTCFeatureHighlightTextPadding = 40.0f;
const CGFloat kGTCFeatureHighlightTextMaxWidth = 300.0f;
const CGFloat kGTCFeatureHighlightConcentricBound = 88.0f;
const CGFloat kGTCFeatureHighlightNonconcentricOffset = 20.0f;
const CGFloat kGTCFeatureHighlightMaxTextHeight = 1000.0f;
const CGFloat kGTCFeatureHighlightTitleBodyBaselineOffset = 32.0f;
const CGFloat kGTCFeatureHighlightOuterHighlightAlpha = 0.96f;

const CGFloat kGTCFeatureHighlightGestureDisappearThresh = 0.9f;
const CGFloat kGTCFeatureHighlightGestureAppearThresh = 0.95f;
const CGFloat kGTCFeatureHighlightGestureDismissThresh = 0.85f;
const CGFloat kGTCFeatureHighlightGestureAnimationDuration = 0.2f;

const CGFloat kGTCFeatureHighlightDismissAnimationDuration = 0.25f;

// Animation consts
const CGFloat kGTCFeatureHighlightInnerRadiusFactor = 1.1f;
const CGFloat kGTCFeatureHighlightOuterRadiusFactor = 1.125f;
const CGFloat kGTCFeatureHighlightPulseRadiusFactor = 2.0f;
const CGFloat kGTCFeatureHighlightPulseStartAlpha = 0.54f;
const CGFloat kGTCFeatureHighlightInnerRadiusBloomAmount =
(kGTCFeatureHighlightInnerRadiusFactor - 1) * kGTCFeatureHighlightMinimumInnerRadius;
const CGFloat kGTCFeatureHighlightPulseRadiusBloomAmount =
(kGTCFeatureHighlightPulseRadiusFactor - 1) * kGTCFeatureHighlightMinimumInnerRadius;

static const GTCFontTextStyle kTitleTextStyle = GTCFontTextStyleTitle;
static const GTCFontTextStyle kBodyTextStyle = GTCFontTextStyleSubheadline;

static inline CGPoint CGPointAddedToPoint(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

@implementation GTCFeatureHighlightView {
    BOOL _forceConcentricLayout;
    UIView *_highlightView;
    CGPoint _highlightPoint;
    CGFloat _innerRadius;
    CGPoint _outerCenter;
    CGFloat _outerRadius;
    CGFloat _outerRadiusScale;
    BOOL _isLayedOutAppearing;
    GTCFeatureHighlightLayer *_outerLayer;
    GTCFeatureHighlightLayer *_pulseLayer;
    GTCFeatureHighlightLayer *_innerLayer;
    GTCFeatureHighlightLayer *_displayMaskLayer;

    BOOL _gtc_adjustsFontForContentSizeCategory;

    // This view is a hack to work around UIKit calling our animation completion blocks immediately if
    // there is no UIKit content being animated. Since our appearance and disappearance animations are
    // mostly CAAnimations, we need to guarantee there will be a UIKit animation occuring in order to
    // ensure we always see the full CAAnimations before the completion blocks are called.
    UIView *_dummyAnimatedView;
}

@synthesize highlightRadius = _outerRadius;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        _dummyAnimatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _dummyAnimatedView.backgroundColor = [UIColor clearColor];
        [self addSubview:_dummyAnimatedView];

        _outerLayer = [[GTCFeatureHighlightLayer alloc] init];
        [self.layer addSublayer:_outerLayer];

        _pulseLayer = [[GTCFeatureHighlightLayer alloc] init];
        [self.layer addSublayer:_pulseLayer];

        _innerLayer = [[GTCFeatureHighlightLayer alloc] init];
        [self.layer addSublayer:_innerLayer];

        _displayMaskLayer = [[GTCFeatureHighlightLayer alloc] init];
        _displayMaskLayer.fillColor = [UIColor whiteColor].CGColor;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentNatural;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];

        _bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bodyLabel.shadowColor = nil;
        _bodyLabel.shadowOffset = CGSizeZero;
        _bodyLabel.textAlignment = NSTextAlignmentNatural;
        _bodyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _bodyLabel.numberOfLines = 0;
        [self addSubview:_bodyLabel];

        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];

        GTCFeatureHighlightDismissGestureRecognizer *panRecognizer =
        [[GTCFeatureHighlightDismissGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(didGestureDismiss:)];
        panRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panRecognizer];

        // We want the inner and outer highlights to animate from the same origin so we start them from
        // a concentric position.
        _forceConcentricLayout = YES;
        [self applyGTCFeatureHighlightViewDefaults];

        _outerRadiusScale = 1.0;
    }
    return self;
}

- (void)dealloc {
    //TODO(#2651): Remove once we move to iOS8
    // Remove Dynamic Type contentSizeCategoryDidChangeNotification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)applyGTCFeatureHighlightViewDefaults {
    _outerHighlightColor = [self GTCFeatureHighlightDefaultOuterHighlightColor];
    _innerHighlightColor = [self GTCFeatureHighlightDefaultInnerHighlightColor];
}

- (UIColor *)GTCFeatureHighlightDefaultOuterHighlightColor {
    return [[UIColor blueColor] colorWithAlphaComponent:kGTCFeatureHighlightOuterHighlightAlpha];
}

- (UIColor *)GTCFeatureHighlightDefaultInnerHighlightColor {
    return [UIColor whiteColor];
}

- (void)setOuterHighlightColor:(UIColor *)outerHighlightColor {
    if (!outerHighlightColor) {
        outerHighlightColor = [self GTCFeatureHighlightDefaultOuterHighlightColor];
    }
    _outerHighlightColor = outerHighlightColor;
    _outerLayer.fillColor = _outerHighlightColor.CGColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;

    [self updateTitleFont];
}

- (void)updateTitleFont {
    if (!_titleFont) {
        _titleFont = [GTCFeatureHighlightView defaultTitleFont];
    }
    if (_gtc_adjustsFontForContentSizeCategory) {
        _titleLabel.font =
        [_titleFont gtc_fontSizedForMaterialTextStyle:kTitleTextStyle
                                 scaledForDynamicType:_gtc_adjustsFontForContentSizeCategory];
    } else {
        _titleLabel.font = _titleFont;
    }

    [self setNeedsLayout];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;

    _titleLabel.textColor = titleColor;
}

- (void)setBodyFont:(UIFont *)bodyFont {
    _bodyFont = bodyFont;

    [self updateBodyFont];
}

- (void)updateBodyFont {
    if (!_bodyFont) {
        _bodyFont = [GTCFeatureHighlightView defaultBodyFont];
    }
    if (_gtc_adjustsFontForContentSizeCategory) {
        _bodyLabel.font =
        [_bodyFont gtc_fontSizedForMaterialTextStyle:kBodyTextStyle
                                scaledForDynamicType:_gtc_adjustsFontForContentSizeCategory];
    } else {
        _bodyLabel.font = _bodyFont;
    }
    [self setNeedsLayout];
}

- (void)setBodyColor:(UIColor *)bodyColor {
    _bodyColor = bodyColor;

    _bodyLabel.textColor = bodyColor;
}

+ (UIFont *)defaultBodyFont {
    if ([GTCTypography.fontLoader isKindOfClass:[GTCSystemFontLoader class]]) {
        return [UIFont gtc_standardFontForMaterialTextStyle:kBodyTextStyle];
    }
    return [GTCTypography body1Font];
}

+ (UIFont *)defaultTitleFont {
    if ([GTCTypography.fontLoader isKindOfClass:[GTCSystemFontLoader class]]) {
        return [UIFont gtc_standardFontForMaterialTextStyle:kTitleTextStyle];
    }
    return [GTCTypography titleFont];
}

- (void)setInnerHighlightColor:(UIColor *)innerHighlightColor {
    if (!innerHighlightColor) {
        innerHighlightColor = [self GTCFeatureHighlightDefaultInnerHighlightColor];
    }
    _innerHighlightColor = innerHighlightColor;

    _pulseLayer.fillColor = _innerHighlightColor.CGColor;
    _innerLayer.fillColor = _innerHighlightColor.CGColor;
}

- (void)layoutAppearing {
    _isLayedOutAppearing = YES;

    // TODO: Mask the labels during the presentation and dismissal animations.
    _titleLabel.alpha = 1;
    _bodyLabel.alpha = 1;

    // Guarantee something changes in case the label alphas are already 1.0
    _dummyAnimatedView.frame = CGRectOffset(_dummyAnimatedView.frame, 1, 0);
}

- (void)layoutDisappearing {
    _isLayedOutAppearing = NO;

    _titleLabel.alpha = 0;
    _bodyLabel.alpha = 0;

    // Guarantee something changes in case the label alphas are already 0.0
    _dummyAnimatedView.frame = CGRectOffset(_dummyAnimatedView.frame, 1, 0);
}

- (void)setDisplayedView:(UIView *)displayedView {
    CGSize displayedSize = displayedView.frame.size;
    CGFloat viewRadius =
    (CGFloat)sqrt(pow(displayedSize.width / 2, 2) + pow(displayedSize.height / 2, 2));
    viewRadius += kGTCFeatureHighlightInnerContentPadding;
    _innerRadius = MAX(viewRadius, kGTCFeatureHighlightMinimumInnerRadius);

    _displayedView.layer.mask = nil;
    [_displayedView removeFromSuperview];
    _displayedView = displayedView;
    [self addSubview:_displayedView];
    _displayedView.layer.mask = _displayMaskLayer;
}

- (void)setHighlightPoint:(CGPoint)highlightPoint {
    _highlightPoint = highlightPoint;

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [_innerLayer removeAllAnimations];
    [_outerLayer removeAllAnimations];
    [_pulseLayer removeAllAnimations];

    BOOL leftHalf = _highlightPoint.x < self.frame.size.width / 2;
    BOOL topHalf = _highlightPoint.y < self.frame.size.height / 2;

    CGFloat textWidth = MIN(self.frame.size.width - 2 * kGTCFeatureHighlightTextPadding,
                            kGTCFeatureHighlightTextMaxWidth);
    CGSize titleSize =
    [_titleLabel sizeThatFits:CGSizeMake(textWidth, kGTCFeatureHighlightMaxTextHeight)];
    CGSize detailSize =
    [_bodyLabel sizeThatFits:CGSizeMake(textWidth, kGTCFeatureHighlightMaxTextHeight)];
    titleSize.width = (CGFloat)ceil(MAX(titleSize.width, detailSize.width));
    detailSize.width = titleSize.width;

    CGFloat textVerticalPadding = 0;
    CGFloat textPaddingAbove = _titleLabel.font.descender;
    CGFloat textPaddingBelow = _bodyLabel.font.ascender - textPaddingAbove;
    if (titleSize.height > 0 && detailSize.height > 0) {
        textVerticalPadding = kGTCFeatureHighlightTitleBodyBaselineOffset - textPaddingBelow;
    }

    CGFloat textHeight = titleSize.height + detailSize.height + textVerticalPadding;

    if ((_highlightPoint.y <= kGTCFeatureHighlightConcentricBound) ||
        (_highlightPoint.y >= self.frame.size.height - kGTCFeatureHighlightConcentricBound)) {
        _highlightCenter = _highlightPoint;
    } else {
        if (topHalf) {
            _highlightCenter.y = _highlightPoint.y + _innerRadius + textHeight / 2;
        } else {
            _highlightCenter.y = _highlightPoint.y - _innerRadius - textHeight / 2;
        }
        if (leftHalf) {
            _highlightCenter.x = _highlightPoint.x + kGTCFeatureHighlightNonconcentricOffset;
        } else {
            _highlightCenter.x = _highlightPoint.x - kGTCFeatureHighlightNonconcentricOffset;
        }
    }

    CGPoint outerCenter = _forceConcentricLayout ? _highlightPoint : _highlightCenter;
    if (self.layer.animationKeys) {
        // If our layer has an animationKeys array then we must be inside an animation (because we're
        // resizing or rotating), so we want to use the current animation's properties for our various
        // layers' CAAnimations.
        CAAnimation *animation = [self.layer animationForKey:self.layer.animationKeys.firstObject];
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:animation.timingFunction];
        [CATransaction setAnimationDuration:animation.duration];
        [_innerLayer setPosition:_highlightPoint animated:YES];
        [_pulseLayer setPosition:_highlightPoint animated:YES];
        [_outerLayer setPosition:outerCenter animated:YES];
        [CATransaction commit];
    } else {
        _innerLayer.position = _highlightPoint;
        _pulseLayer.position = _highlightPoint;
        _outerLayer.position = outerCenter;
    }
    _displayedView.center = _highlightPoint;

    CGFloat leftTextBound = kGTCFeatureHighlightTextPadding;
    CGFloat rightTextBound = self.frame.size.width - MAX(titleSize.width, detailSize.width) -
    kGTCFeatureHighlightTextPadding;
    CGPoint titlePos = CGPointMake(0, 0);
    titlePos.x = MIN(MAX(_highlightCenter.x - textWidth / 2, leftTextBound), rightTextBound);
    if (topHalf) {
        titlePos.y = _highlightPoint.y + kGTCFeatureHighlightInnerPadding + _innerRadius;
    } else {
        titlePos.y = _highlightPoint.y - kGTCFeatureHighlightInnerPadding - _innerRadius - textHeight;
    }

    CGRect titleFrame =
    GTCRectAlignToScale((CGRect){titlePos, titleSize}, [UIScreen mainScreen].scale);
    _titleLabel.frame = titleFrame;

    CGFloat detailPositionY = (CGFloat)ceil(CGRectGetMaxY(titleFrame) + textVerticalPadding);
    CGRect detailFrame = (CGRect){CGPointMake(titlePos.x, detailPositionY), detailSize};
    _bodyLabel.frame = detailFrame;

    // Calculating the radius required for a circle centered at _highlightCenter that fully encircles
    // both labels.
    CGRect textFrames = CGRectUnion(_titleLabel.frame, _bodyLabel.frame);
    CGFloat distX = ABS(CGRectGetMidX(textFrames) - _highlightCenter.x) + textFrames.size.width / 2;
    CGFloat distY = ABS(CGRectGetMidY(textFrames) - _highlightCenter.y) + textFrames.size.height / 2;
    CGFloat minTextRadius =
    (CGFloat)(sqrt(pow(distX, 2) + pow(distY, 2)) + kGTCFeatureHighlightTextPadding);

    // Calculating the radius required for a circle centered at _highlightCenter that fully encircles
    // the inner highlight.
    distX = ABS(_highlightCenter.x - _highlightPoint.x);
    distY = ABS(_highlightCenter.y - _highlightPoint.y);
    CGFloat minInnerHighlightRadius = (CGFloat)(sqrt(pow(distX, 2) + pow(distY, 2)) + _innerRadius +
                                                kGTCFeatureHighlightInnerPadding);

    // Use the larger of the two radii to ensure everything is encircled.
    _outerRadius = MAX(minTextRadius, minInnerHighlightRadius);
}

- (void)didTapView:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint pos = [tapGestureRecognizer locationInView:self];
    CGFloat pointDist = CGPointDistanceToPoint(_highlightPoint, pos);
    CGFloat centerDist = CGPointDistanceToPoint(_highlightCenter, pos);

    if (self.interactionBlock) {
        if (centerDist > _outerRadius * _outerRadiusScale) {
            // For taps outside the outer highlight, dismiss as not accepted
            self.interactionBlock(NO);
        } else if (pointDist < _innerRadius) {
            // For taps inside the inner highlight, dismiss as accepted
            self.interactionBlock(YES);
        }
    }
}

- (void)didGestureDismiss:(GTCFeatureHighlightDismissGestureRecognizer *)dismissRecognizer {
    CGFloat progress = dismissRecognizer.progress;
    switch (dismissRecognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self layoutInProgressDismissal:progress];
            break;

        case UIGestureRecognizerStateEnded:
            if (progress > kGTCFeatureHighlightGestureDismissThresh) {
                [self animateDismissalCancelled];
            } else {
                if (self.interactionBlock) {
                    self.interactionBlock(NO);
                }
            }
            break;

        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self animateDismissalCancelled];
            break;

        case UIGestureRecognizerStatePossible:
            break;

        case UIGestureRecognizerStateBegan:
            break;
    }
}

- (void)layoutInProgressDismissal:(CGFloat)progress {
    _outerRadiusScale = progress;
    [self updateOuterHighlight];

    // Square progress to ease-in the translation
    CGFloat translationProgress = (1 - progress * progress);
    CGPoint pointOffset = CGPointMake((_highlightPoint.x - _highlightCenter.x) * translationProgress,
                                      (_highlightPoint.y - _highlightCenter.y) * translationProgress);
    CGPoint center = CGPointAddedToPoint(_highlightCenter, pointOffset);
    [_outerLayer setPosition:center animated:NO];
    [_outerLayer removeAllAnimations];

    if (_isLayedOutAppearing) {
        if (progress < kGTCFeatureHighlightGestureDisappearThresh) {
            [UIView animateWithDuration:kGTCFeatureHighlightGestureAnimationDuration
                             animations:^{
                                 [self layoutDisappearing];
                             }];
        }
    } else if (progress > kGTCFeatureHighlightGestureAppearThresh) {
        [UIView animateWithDuration:kGTCFeatureHighlightGestureAnimationDuration
                         animations:^{
                             [self layoutAppearing];
                         }];
    }
}

- (void)animateDismissalCancelled {
    [UIView animateWithDuration:kGTCFeatureHighlightGestureAnimationDuration
                     animations:^{
                         [self layoutAppearing];
                     }];

    _outerRadiusScale = 1;
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction
                                               functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:kGTCFeatureHighlightDismissAnimationDuration];
    [_outerLayer setRadius:_outerRadius * _outerRadiusScale animated:YES];
    [_outerLayer setPosition:_highlightCenter animated:YES];
    [CATransaction commit];
}

- (void)animateDiscover:(NSTimeInterval)duration {
    [_innerLayer setFillColor:[_innerHighlightColor colorWithAlphaComponent:0].CGColor];
    [_outerLayer setFillColor:[_outerHighlightColor colorWithAlphaComponent:0].CGColor];

    CGPoint displayMaskCenter =
    CGPointMake(_displayedView.frame.size.width / 2, _displayedView.frame.size.height / 2);

    [_displayMaskLayer setPosition:displayMaskCenter];
    [_innerLayer setPosition:_highlightPoint];
    [_pulseLayer setPosition:_highlightPoint];
    [_outerLayer setPosition:_highlightPoint];
    [_outerLayer setRadius:0.0 animated:NO];

    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction
                                               functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:duration];
    [_displayMaskLayer setRadius:_innerRadius animated:YES];
    [_innerLayer setFillColor:[_innerHighlightColor colorWithAlphaComponent:1].CGColor animated:YES];
    [_innerLayer setRadius:_innerRadius animated:YES];
    [_outerLayer setFillColor:_outerHighlightColor.CGColor animated:YES];
    [_outerLayer setPosition:_highlightCenter animated:YES];
    [_outerLayer setRadius:_outerRadius animated:YES];
    [CATransaction commit];

    _forceConcentricLayout = NO;
}

- (void)animatePulse {
    NSArray *keyTimes = @[ @0, @0.5, @1 ];
    id pulseColorStart =
    (__bridge id)
    [_innerHighlightColor colorWithAlphaComponent:kGTCFeatureHighlightPulseStartAlpha]
    .CGColor;
    id pulseColorEnd = (__bridge id)[_innerHighlightColor colorWithAlphaComponent:0].CGColor;
    CGFloat radius = _innerRadius;

    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction
                                               functionWithName:kCAMediaTimingFunctionEaseOut]];
    CGFloat innerBloomRadius = radius + kGTCFeatureHighlightInnerRadiusBloomAmount;
    CGFloat pulseBloomRadius = radius + kGTCFeatureHighlightPulseRadiusBloomAmount;
    NSArray *innerKeyframes = @[ @(radius), @(innerBloomRadius), @(radius) ];
    [_innerLayer animateRadiusOverKeyframes:innerKeyframes keyTimes:keyTimes];
    NSArray *pulseKeyframes = @[ @(radius), @(radius), @(pulseBloomRadius) ];
    [_pulseLayer animateRadiusOverKeyframes:pulseKeyframes keyTimes:keyTimes];
    [_pulseLayer animateFillColorOverKeyframes:@[ pulseColorStart, pulseColorStart, pulseColorEnd ]
                                      keyTimes:keyTimes];
    [CATransaction commit];
}

- (void)animateAccepted:(NSTimeInterval)duration {
    CGPoint displayMaskCenter =
    CGPointMake(_displayedView.frame.size.width / 2, _displayedView.frame.size.height / 2);

    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction
                                               functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:duration];
    [_displayMaskLayer setPosition:displayMaskCenter animated:YES];
    [_displayMaskLayer setRadius:0.0 animated:YES];
    [_innerLayer setPosition:_highlightPoint animated:YES];
    [_innerLayer setRadius:0.0 animated:YES];
    [_outerLayer setFillColor:[_outerHighlightColor colorWithAlphaComponent:0].CGColor animated:YES];
    [_outerLayer setPosition:_highlightCenter animated:YES];
    [_outerLayer setRadius:kGTCFeatureHighlightOuterRadiusFactor * _outerRadius animated:YES];
    [CATransaction commit];

    _forceConcentricLayout = YES;
}

- (void)animateRejected:(NSTimeInterval)duration {
    CGPoint displayMaskCenter =
    CGPointMake(_displayedView.frame.size.width / 2, _displayedView.frame.size.height / 2);

    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction
                                               functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:duration];
    [_displayMaskLayer setPosition:displayMaskCenter animated:YES];
    [_displayMaskLayer setRadius:0 animated:YES];
    [_innerLayer setPosition:_highlightPoint animated:YES];
    [_innerLayer setRadius:0 animated:YES];
    [_outerLayer setFillColor:[_outerHighlightColor colorWithAlphaComponent:0].CGColor animated:YES];
    [_outerLayer setPosition:_highlightPoint animated:YES];
    [_outerLayer setRadius:0 animated:YES];
    [CATransaction commit];

    _forceConcentricLayout = NO;
}

- (void)updateOuterHighlight {
    CGFloat scaledRadius = _outerRadius * _outerRadiusScale;
    if (self.layer.animationKeys) {
        CAAnimation *animation = [self.layer animationForKey:self.layer.animationKeys.firstObject];
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:animation.timingFunction];
        [CATransaction setAnimationDuration:animation.duration];
        [_outerLayer setRadius:scaledRadius animated:YES];
        [CATransaction commit];
    } else {
        [_outerLayer setRadius:scaledRadius animated:NO];
    }
}

#pragma mark - Dynamic Type Support

- (BOOL)gtc_adjustsFontForContentSizeCategory {
    return _gtc_adjustsFontForContentSizeCategory;
}

- (void)gtc_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtc_adjustsFontForContentSizeCategory = adjusts;

    if (_gtc_adjustsFontForContentSizeCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentSizeCategoryDidChange:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIContentSizeCategoryDidChangeNotification
                                                      object:nil];
    }

    [self updateTitleFont];
    [self updateBodyFont];
}

// Handles UIContentSizeCategoryDidChangeNotifications
- (void)contentSizeCategoryDidChange:(__unused NSNotification *)notification {
    [self updateTitleFont];
    [self updateBodyFont];
}

#pragma mark - UIGestureRecognizerDelegate (Tap)

- (BOOL)gestureRecognizer:(__unused UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(__unused UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIAccessibility

- (void)setAccessibilityHint:(NSString *)accessibilityHint {
    _titleLabel.accessibilityHint = accessibilityHint;
}

- (NSString *)accessibilityHint {
    return _titleLabel.accessibilityHint;
}

@end

