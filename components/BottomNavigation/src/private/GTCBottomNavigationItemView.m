//
//  GTCBottomNavigationItemView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCBottomNavigationItemView.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTCBottomNavigationStrings.h"
#import "GTCBottomNavigationStrings_table.h"
#import "GTMath.h"
#import "GTCBottomNavigationItemBadge.h"

static const CGFloat GTCBottomNavigationItemViewInkOpacity = 0.150f;
static const CGFloat GTCBottomNavigationItemViewTitleFontSize = 12.f;

// The duration of the selection transition animation.
static const NSTimeInterval kGTCBottomNavigationItemViewTransitionDuration = 0.180f;

// The Bundle for string resources.
static NSString *const kGTBottomNavigationBundle = @"GTBottomNavigation.bundle";
static NSString *const kGTCBottomNavigationItemViewTabString = @"tab";

@interface GTCBottomNavigationItemView ()

@property(nonatomic, strong) GTCBottomNavigationItemBadge *badge;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic) BOOL shouldPretendToBeATab;

@end

@implementation GTCBottomNavigationItemView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
        if (&UIAccessibilityTraitTabBar == NULL) {
            _shouldPretendToBeATab = YES;
        }
#pragma clang diagnostic pop
#else
        _shouldPretendToBeATab = YES;
#endif
        _titleBelowIcon = YES;
        [self commonGTCBottomNavigationItemViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _titleBelowIcon = YES;

        NSUInteger totalViewsProcessed = 0;
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[GTCInkView class]]) {
                _inkView = (GTCInkView *)view;
                ++totalViewsProcessed;
            } else if ([view isKindOfClass:[UIImageView class]]) {
                _iconImageView = (UIImageView *)view;
                _image = _iconImageView.image;
                ++totalViewsProcessed;
            } else if ([view isKindOfClass:[UILabel class]]) {
                _label = (UILabel *)view;
                ++totalViewsProcessed;
            } else if ([view isKindOfClass:[GTCBottomNavigationItemBadge class]]) {
                _badge = (GTCBottomNavigationItemBadge *)view;
                ++totalViewsProcessed;
            } else if ([view isKindOfClass:[UIButton class]]) {
                _button = (UIButton *)view;
                ++totalViewsProcessed;
            }
        }
        NSAssert(totalViewsProcessed == self.subviews.count,
                 @"Unexpected number of subviews. Expected %lu but restored %lu. Unarchiving may fail.",
                 (unsigned long)self.subviews.count, (unsigned long)totalViewsProcessed);

        [self commonGTCBottomNavigationItemViewInit];
    }
    return self;
}

- (void)commonGTCBottomNavigationItemViewInit {

    if (!_selectedItemTintColor) {
        _selectedItemTintColor = [UIColor blackColor];
    }
    if (!_unselectedItemTintColor) {
        _unselectedItemTintColor = [UIColor grayColor];
    }
    _selectedItemTitleColor = _selectedItemTintColor;

    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.isAccessibilityElement = NO;
        [self addSubview:_iconImageView];
    }

    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.text = _title;
        _label.font = [UIFont systemFontOfSize:GTCBottomNavigationItemViewTitleFontSize];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = _selectedItemTitleColor;
        _label.isAccessibilityElement = NO;
        [self addSubview:_label];

    }

    if (!_badge) {
        _badge = [[GTCBottomNavigationItemBadge alloc] initWithFrame:CGRectZero];
        _badge.isAccessibilityElement = NO;
        [self addSubview:_badge];
    }

    if (!_badge.badgeValue) {
        _badge.hidden = YES;
    }

    if (!_inkView) {
        _inkView = [[GTCInkView alloc] initWithFrame:self.bounds];
        _inkView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _inkView.usesLegacyInkRipple = NO;
        _inkView.clipsToBounds = NO;
        [self addSubview:_inkView];
    }

    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:self.bounds];
        _button.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _button.accessibilityLabel = [self accessibilityLabelWithTitle:_title];
        _button.accessibilityTraits &= ~UIAccessibilityTraitButton;
        _button.accessibilityValue = self.accessibilityValue;
        [self addSubview:_button];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.label sizeToFit];
    CGSize labelSize = CGSizeMake(CGRectGetWidth(self.label.bounds),
                                  CGRectGetHeight(self.label.bounds));
    CGFloat maxWidth = CGRectGetWidth(self.bounds);
    self.label.frame = CGRectMake(0, 0, MIN(maxWidth, labelSize.width), labelSize.height);
    self.inkView.maxRippleRadius =
    (CGFloat)(GTCHypot(CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds)) / 2);
    [self centerLayoutAnimated:NO];
}

- (void)centerLayoutAnimated:(BOOL)animated {
    CGRect contentBoundingRect = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    CGRect iconBounds = self.iconImageView.bounds;
    CGFloat centerY = CGRectGetMidY(contentBoundingRect);
    CGFloat centerX = CGRectGetMidX(contentBoundingRect);
    UIUserInterfaceLayoutDirection layoutDirection = self.gtf_effectiveUserInterfaceLayoutDirection;
    BOOL isRTL = layoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    if (isRTL) {
        centerX = CGRectGetWidth(self.bounds) - centerX;
    }

    if (self.titleBelowIcon) {
        BOOL titleHidden =
        self.titleVisibility == GTCBottomNavigationBarTitleVisibilityNever ||
        (self.titleVisibility == GTCBottomNavigationBarTitleVisibilitySelected && !self.selected);
        CGFloat iconHeight = CGRectGetHeight(self.iconImageView.bounds);
        CGFloat labelHeight = CGRectGetHeight(self.label.bounds);
        CGFloat totalContentHeight = iconHeight;
        if (!titleHidden) {
            totalContentHeight += labelHeight + self.contentVerticalMargin;
        }
        CGPoint iconImageViewCenter =
        CGPointMake(centerX, centerY - totalContentHeight / 2 + iconHeight / 2);
        CGPoint badgeCenter =
        CGPointMake(iconImageViewCenter.x + CGRectGetMidX(iconBounds) * (isRTL ? -1 : 1),
                    iconImageViewCenter.y - CGRectGetMidY(iconBounds));
        self.label.center = CGPointMake(centerX, centerY + totalContentHeight / 2 - labelHeight / 2);
        if (animated) {
            [UIView animateWithDuration:kGTCBottomNavigationItemViewTransitionDuration animations:^(void) {
                self.iconImageView.center = iconImageViewCenter;
                self.badge.center = badgeCenter;
            }];
        } else {
            self.iconImageView.center = iconImageViewCenter;
            self.badge.center = badgeCenter;
        }
        self.label.textAlignment = NSTextAlignmentCenter;
    } else {
        CGFloat contentsWidth =
        CGRectGetWidth(self.iconImageView.bounds) + CGRectGetWidth(self.label.bounds);
        if (!isRTL) {
            CGPoint iconImageViewCenter =
            CGPointMake(centerX - CGRectGetWidth(contentBoundingRect) * 0.2f, centerY);
            self.iconImageView.center = iconImageViewCenter;
            CGFloat labelCenterX =
            iconImageViewCenter.x + contentsWidth / 2 + self.contentHorizontalMargin;
            self.label.center = CGPointMake(labelCenterX, centerY);
            self.badge.center =
            CGPointMake(iconImageViewCenter.x + CGRectGetMidX(iconBounds),
                        iconImageViewCenter.y - CGRectGetMidY(iconBounds));
            self.label.textAlignment = NSTextAlignmentLeft;
        } else {
            CGPoint iconImageViewCenter =
            CGPointMake(centerX + CGRectGetWidth(contentBoundingRect) * 0.2f, centerY);
            self.iconImageView.center = iconImageViewCenter;
            CGFloat labelCenterX =
            iconImageViewCenter.x - contentsWidth / 2 - self.contentHorizontalMargin;
            self.label.center = CGPointMake(labelCenterX, centerY);
            self.badge.center =
            CGPointMake(iconImageViewCenter.x - CGRectGetMidX(iconBounds),
                        iconImageViewCenter.y - CGRectGetMidY(iconBounds));
            self.label.textAlignment = NSTextAlignmentRight;
        }
    }
}

- (void)updateLabelVisibility {
    if (self.selected) {
        switch (self.titleVisibility) {
            case GTCBottomNavigationBarTitleVisibilitySelected:
            case GTCBottomNavigationBarTitleVisibilityAlways:
                self.label.hidden = NO;
                break;
            case GTCBottomNavigationBarTitleVisibilityNever:
                self.label.hidden = YES;
                break;
        }
    } else {
        switch (self.titleVisibility) {
            case GTCBottomNavigationBarTitleVisibilitySelected:
            case GTCBottomNavigationBarTitleVisibilityNever:
                self.label.hidden = YES;
                break;
            case GTCBottomNavigationBarTitleVisibilityAlways:
                self.label.hidden = NO;
                break;
        }
    }
}

- (NSString *)accessibilityLabelWithTitle:(NSString *)title {
    NSMutableArray *labelComponents = [NSMutableArray array];

    // Use untransformed title as accessibility label to ensure accurate reading.
    if (title.length > 0) {
        [labelComponents addObject:title];
    }

    if (self.shouldPretendToBeATab) {
        NSString *key =
        kGTCBottomNavigationStringTable[kStr_GTCBottomNavigationTabElementAccessibilityLabel];
        NSString *tabString =
        NSLocalizedStringFromTableInBundle(key,
                                           kGTCBottomNavigationStringsTableName,
                                           [[self class] bundle],
                                           kGTCBottomNavigationItemViewTabString);
        [labelComponents addObject:tabString];
    }

    // Speak components with a pause in between.
    return [labelComponents componentsJoinedByString:@", "];
}

- (NSString *)badgeValue {
    return self.badge.badgeValue;
}

#pragma mark - Setters

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    _selected = selected;
    if (selected) {
        self.label.textColor = self.selectedItemTitleColor;
        self.iconImageView.tintColor = self.selectedItemTintColor;
        self.button.accessibilityTraits |= UIAccessibilityTraitSelected;
        self.iconImageView.image = (self.selectedImage) ? self.selectedImage : self.image;
        [self updateLabelVisibility];
    } else {
        self.label.textColor = self.unselectedItemTintColor;
        self.iconImageView.tintColor = self.unselectedItemTintColor;
        self.button.accessibilityTraits &= ~UIAccessibilityTraitSelected;
        self.iconImageView.image = self.image;
        [self updateLabelVisibility];
    }
    [self centerLayoutAnimated:animated];
}

- (void)setSelectedItemTintColor:(UIColor *)selectedItemTintColor {
    _selectedItemTintColor = selectedItemTintColor;
    _selectedItemTitleColor = selectedItemTintColor;
    if (self.selected) {
        self.iconImageView.tintColor = self.selectedItemTintColor;
        self.label.textColor = self.selectedItemTitleColor;
    }
    self.inkView.inkColor =
    [self.selectedItemTintColor colorWithAlphaComponent:GTCBottomNavigationItemViewInkOpacity];

}

- (void)setUnselectedItemTintColor:(UIColor *)unselectedItemTintColor {
    _unselectedItemTintColor = unselectedItemTintColor;
    if (!self.selected) {
        self.iconImageView.tintColor = self.unselectedItemTintColor;
        self.label.textColor = self.unselectedItemTintColor;
    }
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    _selectedItemTitleColor = selectedItemTitleColor;
    if (self.selected) {
        self.label.textColor = self.selectedItemTitleColor;
    }
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    _badgeColor = badgeColor;
    self.badge.badgeColor = badgeColor;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    // Due to KVO, badgeValue may be of type NSNull.
    if ([badgeValue isKindOfClass:[NSNull class]]) {
        badgeValue = nil;
    }
    self.badge.badgeValue = badgeValue;
    if ([super accessibilityValue] == nil || [self accessibilityValue].length == 0) {
        self.button.accessibilityValue = badgeValue;
    }
    if (badgeValue == nil || badgeValue.length == 0) {
        self.badge.hidden = YES;
    } else {
        self.badge.hidden = NO;
    }
}

- (void)setImage:(UIImage *)image {
    _image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconImageView.image = _image;
    self.iconImageView.tintColor = (self.selected) ? self.selectedItemTintColor
    : self.unselectedItemTintColor;
    [self.iconImageView sizeToFit];
}

-(void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = [selectedImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    self.iconImageView.image = _selectedImage;
    self.iconImageView.tintColor = self.selectedItemTintColor;
    [self.iconImageView sizeToFit];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = _title;
    self.button.accessibilityLabel = [self accessibilityLabelWithTitle:_title];
}

-(void)setTitleVisibility:(GTCBottomNavigationBarTitleVisibility)titleVisibility {
    _titleVisibility = titleVisibility;
    [self updateLabelVisibility];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    self.label.font = itemTitleFont;
    [self setNeedsLayout];
}

-(void)setAccessibilityValue:(NSString *)accessibilityValue {
    [super setAccessibilityValue:accessibilityValue];
    self.button.accessibilityValue = accessibilityValue;
}

- (NSString *)accessibilityValue {
    return self.button.accessibilityValue;
}

-(void)setAccessibilityIdentifier:(NSString *)accessibilityIdentifier {
    self.button.accessibilityIdentifier = accessibilityIdentifier;
}

-(NSString *)accessibilityIdentifier {
    return self.button.accessibilityIdentifier;
}

#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kGTBottomNavigationBundle]];
    });
    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTCBottomNavigationBar class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}


@end
