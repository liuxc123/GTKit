//
//  GTCBottomNavigationBar.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GTCBottomNavigationBar.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTMath.h"
#import "GTShadowElevations.h"
#import "GTShadowLayer.h"
#import "GTTypography.h"
#import "private/GTCBottomNavigationStrings.h"
#import "private/GTCBottomNavigationStrings_table.h"
#import "private/GTCBottomNavigationItemView.h"

// The Bundle for string resources.
static NSString *const kMaterialBottomNavigationBundle = @"MaterialBottomNavigation.bundle";

static const CGFloat kGTCBottomNavigationBarHeight = 56.f;
static const CGFloat kGTCBottomNavigationBarHeightAdjacentTitles = 40.f;
static const CGFloat kGTCBottomNavigationBarLandscapeContainerWidth = 320.f;
static const CGFloat kGTCBottomNavigationBarItemsHorizontalMargin = 12.f;
static NSString *const kGTCBottomNavigationBarBadgeColorString = @"badgeColor";
static NSString *const kGTCBottomNavigationBarBadgeValueString = @"badgeValue";
static NSString *const kGTCBottomNavigationBarAccessibilityValueString =
@"accessibilityValue";
static NSString *const kGTCBottomNavigationBarImageString = @"image";
static NSString *const kGTCBottomNavigationBarSelectedImageString = @"selectedImage";
// TODO: - Change to NSKeyValueChangeNewKey
static NSString *const kGTCBottomNavigationBarNewString = @"new";
static NSString *const kGTCBottomNavigationBarTitleString = @"title";
static NSString *const kGTCBottomNavigationBarAccessibilityIdentifier = @"accessibilityIdentifier";


static NSString *const kGTCBottomNavigationBarOfAnnouncement = @"of";

@interface GTCBottomNavigationBar () <GTCInkTouchControllerDelegate>

@property(nonatomic, assign) BOOL itemsDistributed;
@property(nonatomic, assign) BOOL titleBelowItem;
@property(nonatomic, assign) CGFloat maxLandscapeClusterContainerWidth;
@property(nonatomic, strong) NSMutableArray<GTCBottomNavigationItemView *> *itemViews;
@property(nonatomic, readonly) UIEdgeInsets GTC_safeAreaInsets;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) NSMutableArray *inkControllers;
@property(nonatomic) BOOL shouldPretendToBeATabBar;

@end

@implementation GTCBottomNavigationBar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
        self.isAccessibilityElement = NO;
        [self commonGTCBottomNavigationBarInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCBottomNavigationBarInit];
    }
    return self;
}

- (void)commonGTCBottomNavigationBarInit {
    _itemsContentHorizontalMargin = kGTCBottomNavigationBarItemsHorizontalMargin;
    _selectedItemTintColor = [UIColor blackColor];
    _unselectedItemTintColor = [UIColor grayColor];
    _selectedItemTitleColor = _selectedItemTintColor;
    _titleVisibility = GTCBottomNavigationBarTitleVisibilitySelected;
    _alignment = GTCBottomNavigationBarAlignmentJustified;
    _itemsDistributed = YES;
    _titleBelowItem = YES;
    _barTintColor = [UIColor whiteColor];
    self.backgroundColor = _barTintColor;

    // Remove any unarchived subviews and reconfigure the view hierarchy
    if (self.subviews.count) {
        NSArray *subviews = self.subviews;
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
    }
    _maxLandscapeClusterContainerWidth = kGTCBottomNavigationBarLandscapeContainerWidth;
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleRightMargin);
    _containerView.clipsToBounds = YES;
    [self addSubview:_containerView];
#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
    if (&UIAccessibilityTraitTabBar != NULL) {
        _containerView.accessibilityTraits = UIAccessibilityTraitTabBar;
    } else {
        _shouldPretendToBeATabBar = YES;
    }
#pragma clang diagnostic pop
#else
    _shouldPretendToBeATabBar = YES;
#endif
    [self setElevation:GTCShadowElevationBottomNavigationBar];
    _itemViews = [NSMutableArray array];
    _itemTitleFont = [UIFont gtc_standardFontForMaterialTextStyle:GTCFontTextStyleCaption];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize size = self.bounds.size;
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        [self layoutLandscapeModeWithBottomNavSize:size
                                    containerWidth:self.maxLandscapeClusterContainerWidth];
    } else {
        [self sizeContainerViewItemsDistributed:YES withBottomNavSize:size containerWidth:size.width];
        self.titleBelowItem = YES;
    }
    [self layoutItemViews];
}

- (CGSize)sizeThatFits:(CGSize)size {
    self.maxLandscapeClusterContainerWidth = MIN(size.width, size.height);
    UIEdgeInsets insets = self.GTC_safeAreaInsets;
    CGFloat heightWithInset = kGTCBottomNavigationBarHeight + insets.bottom;
    if (self.alignment == GTCBottomNavigationBarAlignmentJustifiedAdjacentTitles &&
        self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        heightWithInset = kGTCBottomNavigationBarHeightAdjacentTitles + insets.bottom;
    }
    CGSize insetSize = CGSizeMake(size.width, heightWithInset);
    return insetSize;
}

+ (Class)layerClass {
    return [GTCShadowLayer class];
}

- (void)setElevation:(GTCShadowElevation)elevation {
    [(GTCShadowLayer *)self.layer setElevation:elevation];
}

- (void)layoutLandscapeModeWithBottomNavSize:(CGSize)bottomNavSize
                              containerWidth:(CGFloat)containerWidth {
    switch (self.alignment) {
        case GTCBottomNavigationBarAlignmentJustified:
            [self sizeContainerViewItemsDistributed:YES
                                  withBottomNavSize:bottomNavSize
                                     containerWidth:containerWidth];
            self.titleBelowItem = YES;
            break;
        case GTCBottomNavigationBarAlignmentJustifiedAdjacentTitles:
            [self sizeContainerViewItemsDistributed:YES
                                  withBottomNavSize:bottomNavSize
                                     containerWidth:containerWidth];
            self.titleBelowItem = NO;
            break;
        case GTCBottomNavigationBarAlignmentCentered:
            [self sizeContainerViewItemsDistributed:NO
                                  withBottomNavSize:bottomNavSize
                                     containerWidth:containerWidth];
            self.titleBelowItem = YES;
            break;
    }
}

- (void)sizeContainerViewItemsDistributed:(BOOL)itemsDistributed
                        withBottomNavSize:(CGSize)bottomNavSize
                           containerWidth:(CGFloat)containerWidth {
    CGFloat barHeight = kGTCBottomNavigationBarHeight;
    if (self.alignment == GTCBottomNavigationBarAlignmentJustifiedAdjacentTitles &&
        self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        barHeight = kGTCBottomNavigationBarHeightAdjacentTitles;
    }
    if (itemsDistributed) {
        UIEdgeInsets insets = self.GTC_safeAreaInsets;
        self.containerView.frame =
        CGRectMake(insets.left, 0, bottomNavSize.width - insets.left - insets.right, barHeight);
    } else {
        CGFloat clusteredOffsetX = (bottomNavSize.width - containerWidth) / 2;
        self.containerView.frame = CGRectMake(clusteredOffsetX, 0, containerWidth, barHeight);
    }
}

- (void)layoutItemViews {
    UIUserInterfaceLayoutDirection layoutDirection = self.gtf_effectiveUserInterfaceLayoutDirection;
    NSInteger numItems = self.items.count;
    if (numItems == 0) {
        return;
    }
    CGFloat navBarWidth = CGRectGetWidth(self.containerView.bounds);
    CGFloat navBarHeight = CGRectGetHeight(self.containerView.bounds);
    CGFloat itemWidth = navBarWidth / numItems;
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
        GTCBottomNavigationItemView *itemView = self.itemViews[i];
        if (layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
            itemView.frame = CGRectMake(i * itemWidth, 0, itemWidth, navBarHeight);
        } else {
            itemView.frame =
            CGRectMake(navBarWidth - (i + 1) * itemWidth, 0,  itemWidth, navBarHeight);
        }
    }
}

- (void)dealloc {
    [self removeObserversFromTabBarItems];
}

- (void)addObserversToTabBarItems {
    for (UITabBarItem *item in self.items) {
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarBadgeColorString
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarBadgeValueString
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarAccessibilityValueString
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarImageString
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarSelectedImageString
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarTitleString
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self
               forKeyPath:kGTCBottomNavigationBarAccessibilityIdentifier
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
}

- (void)removeObserversFromTabBarItems {
    for (UITabBarItem *item in self.items) {
        @try {
            [item removeObserver:self forKeyPath:kGTCBottomNavigationBarBadgeColorString];
            [item removeObserver:self forKeyPath:kGTCBottomNavigationBarBadgeValueString];
            [item removeObserver:self
                      forKeyPath:kGTCBottomNavigationBarAccessibilityValueString];
            [item removeObserver:self forKeyPath:kGTCBottomNavigationBarImageString];
            [item removeObserver:self
                      forKeyPath:kGTCBottomNavigationBarSelectedImageString];
            [item removeObserver:self forKeyPath:kGTCBottomNavigationBarTitleString];
            [item removeObserver:self forKeyPath:kGTCBottomNavigationBarAccessibilityIdentifier];
        }
        @catch (NSException *exception) {
            if (exception) {
                // No need to do anything if there are no observers.
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (!context) {
        NSInteger selectedItemNum = 0;
        for (NSUInteger i = 0; i < self.items.count; i++) {
            UITabBarItem *item = self.items[i];
            if (object == item) {
                selectedItemNum = i;
                break;
            }
        }
        GTCBottomNavigationItemView *itemView = _itemViews[selectedItemNum];
        if ([keyPath isEqualToString:kGTCBottomNavigationBarBadgeColorString]) {
            itemView.badgeColor = change[kGTCBottomNavigationBarNewString];
        } else if ([keyPath
                    isEqualToString:kGTCBottomNavigationBarAccessibilityValueString]) {
            itemView.accessibilityValue = change[NSKeyValueChangeNewKey];
        } else if ([keyPath isEqualToString:kGTCBottomNavigationBarBadgeValueString]) {
            itemView.badgeValue = change[kGTCBottomNavigationBarNewString];
        } else if ([keyPath isEqualToString:kGTCBottomNavigationBarImageString]) {
            itemView.image = change[kGTCBottomNavigationBarNewString];
        } else if ([keyPath isEqualToString:kGTCBottomNavigationBarSelectedImageString]) {
            itemView.selectedImage = change[kGTCBottomNavigationBarNewString];
        } else if ([keyPath isEqualToString:kGTCBottomNavigationBarTitleString]) {
            itemView.title = change[kGTCBottomNavigationBarNewString];
        } else if ([keyPath isEqualToString:kGTCBottomNavigationBarAccessibilityIdentifier]) {
            itemView.accessibilityIdentifier = change[kGTCBottomNavigationBarNewString];
        }
    }
}

- (UIEdgeInsets)GTC_safeAreaInsets {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        // Accommodate insets for iPhone X.
        insets = self.safeAreaInsets;
    }
    return insets;
}

- (UIView *)viewForItem:(UITabBarItem *)item {
    NSUInteger itemIndex = [_items indexOfObject:item];
    if (itemIndex == NSNotFound) {
        return nil;
    }
    if (itemIndex >= _itemViews.count) {
        NSAssert(NO, @"Item index should not be out of item view bounds");
        return nil;
    }
    return _itemViews[itemIndex];
}

#pragma mark - Touch handlers

- (void)didTouchDownButton:(UIButton *)button {
    GTCBottomNavigationItemView *itemView = (GTCBottomNavigationItemView *)button.superview;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(itemView.inkView.bounds),
                                      CGRectGetMidY(itemView.inkView.bounds));
    [itemView.inkView startTouchBeganAnimationAtPoint:centerPoint completion:nil];
}

- (void)didTouchUpInsideButton:(UIButton *)button {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UITabBarItem *item = self.items[i];
        GTCBottomNavigationItemView *itemView = self.itemViews[i];
        if (itemView.button == button) {
            BOOL shouldSelect = YES;
            if ([self.delegate respondsToSelector:@selector(bottomNavigationBar:shouldSelectItem:)]) {
                shouldSelect = [self.delegate bottomNavigationBar:self shouldSelectItem:item];
            }
            if (shouldSelect) {
                [self setSelectedItem:item animated:YES];
                if ([self.delegate respondsToSelector:@selector(bottomNavigationBar:didSelectItem:)]) {
                    [self.delegate bottomNavigationBar:self didSelectItem:item];
                }
            }
        }
    }
}

- (void)didTouchUpOutsideButton:(UIButton *)button {
    GTCBottomNavigationItemView *itemView = (GTCBottomNavigationItemView *)button.superview;
    [itemView.inkView startTouchEndedAnimationAtPoint:CGPointZero completion:nil];
}

- (void)didCancelTouchesForButton:(UIButton *)button {
    GTCBottomNavigationItemView *itemView = (GTCBottomNavigationItemView *)button.superview;
    [itemView.inkView cancelAllAnimationsAnimated:NO];
}

#pragma mark - Setters

- (void)setItems:(NSArray<UITabBarItem *> *)items {
    if ([_items isEqual:items] || _items == items) {
        return;
    }

    // Remove existing item views from the bottom navigation so it can be repopulated with new items.
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        [itemView removeFromSuperview];
    }
    [self.itemViews removeAllObjects];
    [self.inkControllers removeAllObjects];
    if (!self.inkControllers) {
        _inkControllers = [@[] mutableCopy];
    }
    [self removeObserversFromTabBarItems];

    _items = [items copy];

    for (NSUInteger i = 0; i < items.count; i++) {
        UITabBarItem *item = items[i];
        GTCBottomNavigationItemView *itemView =
        [[GTCBottomNavigationItemView alloc] initWithFrame:CGRectZero];
        itemView.title = item.title;
        itemView.itemTitleFont = self.itemTitleFont;
        itemView.selectedItemTintColor = self.selectedItemTintColor;
        itemView.selectedItemTitleColor = self.selectedItemTitleColor;
        itemView.unselectedItemTintColor = self.unselectedItemTintColor;
        itemView.titleVisibility = self.titleVisibility;
        itemView.titleBelowIcon = self.titleBelowItem;
        itemView.accessibilityValue = item.accessibilityValue;
        itemView.accessibilityIdentifier = item.accessibilityIdentifier;
        itemView.contentInsets = self.itemsContentInsets;
        itemView.contentVerticalMargin = self.itemsContentVerticalMargin;
        itemView.contentHorizontalMargin = self.itemsContentHorizontalMargin;
        GTCInkTouchController *controller = [[GTCInkTouchController alloc] initWithView:itemView];
        controller.delegate = self;
        [self.inkControllers addObject:controller];

        if (self.shouldPretendToBeATabBar) {
            NSString *key = kGTCBottomNavigationStringTable[
                                                            kStr_GTCBottomNavigationItemCountAccessibilityHint
                                                                 ];
            NSString *itemOfTotalString =
            NSLocalizedStringFromTableInBundle(key,
                                               kGTCBottomNavigationStringsTableName,
                                               [[self class] bundle],
                                               kGTCBottomNavigationBarOfString);
            NSString *localizedPosition =
            [NSString localizedStringWithFormat:itemOfTotalString, (i + 1), (int)items.count];
            itemView.button.accessibilityHint = localizedPosition;
        }
        if (item.image) {
            itemView.image = item.image;
        }
        if (item.selectedImage) {
            itemView.selectedImage = item.selectedImage;
        }
        if (item.badgeValue) {
            itemView.badgeValue = item.badgeValue;
        }
#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        NSOperatingSystemVersion iOS10Version = {10, 0, 0};
        if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:iOS10Version]) {
            if (item.badgeColor) {
                itemView.badgeColor = item.badgeColor;
            }
        }
#pragma clang diagnostic pop
#endif
        itemView.selected = NO;
        [itemView.button addTarget:self
                            action:@selector(didTouchUpInsideButton:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.itemViews addObject:itemView];
        [self.containerView addSubview:itemView];
    }
    self.selectedItem = nil;
    [self addObserversToTabBarItems];
    [self setNeedsLayout];
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    [self setSelectedItem:selectedItem animated:NO];
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem animated:(BOOL)animated {
    if (_selectedItem == selectedItem) {
        return;
    }
    _selectedItem = selectedItem;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UITabBarItem *item = self.items[i];
        GTCBottomNavigationItemView *itemView = self.itemViews[i];
        if (selectedItem == item) {
            [itemView setSelected:YES animated:animated];
        } else {
            [itemView setSelected:NO animated:animated];
        }
    }
}

- (void)setItemsContentInsets:(UIEdgeInsets)itemsContentInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_itemsContentInsets, itemsContentInsets)) {
        return;
    }
    _itemsContentInsets = itemsContentInsets;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        GTCBottomNavigationItemView *itemView = self.itemViews[i];
        itemView.contentInsets = itemsContentInsets;
    }
    [self setNeedsLayout];
}

- (void)setItemsContentVerticalMargin:(CGFloat)itemsContentsVerticalMargin {
    if (GTCCGFloatEqual(_itemsContentVerticalMargin, itemsContentsVerticalMargin)) {
        return;
    }
    _itemsContentVerticalMargin = itemsContentsVerticalMargin;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        GTCBottomNavigationItemView *itemView = self.itemViews[i];
        itemView.contentVerticalMargin = itemsContentsVerticalMargin;
    }
    [self setNeedsLayout];
}

- (void)setItemsContentHorizontalMargin:(CGFloat)itemsContentHorizontalMargin {
    if (GTCCGFloatEqual(_itemsContentHorizontalMargin, itemsContentHorizontalMargin)) {
        return;
    }
    _itemsContentHorizontalMargin = itemsContentHorizontalMargin;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        GTCBottomNavigationItemView *itemView = self.itemViews[i];
        itemView.contentHorizontalMargin = itemsContentHorizontalMargin;
    }
    [self setNeedsLayout];
}

- (void)setTitleBelowItem:(BOOL)titleBelowItem {
    _titleBelowItem = titleBelowItem;
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        itemView.titleBelowIcon = titleBelowItem;
    }
}

- (void)setSelectedItemTintColor:(UIColor *)selectedItemTintColor {
    _selectedItemTintColor = selectedItemTintColor;
    _selectedItemTitleColor = selectedItemTintColor;
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        itemView.selectedItemTintColor = selectedItemTintColor;
    }
}

- (void)setUnselectedItemTintColor:(UIColor *)unselectedItemTintColor {
    _unselectedItemTintColor = unselectedItemTintColor;
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        itemView.unselectedItemTintColor = unselectedItemTintColor;
    }
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    _selectedItemTitleColor = selectedItemTitleColor;
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        itemView.selectedItemTitleColor = selectedItemTitleColor;
    }
}

- (void)setTitleVisibility:(GTCBottomNavigationBarTitleVisibility)titleVisibility {
    _titleVisibility = titleVisibility;
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        itemView.titleVisibility = titleVisibility;
    }
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    for (GTCBottomNavigationItemView *itemView in self.itemViews) {
        itemView.itemTitleFont = itemTitleFont;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    self.backgroundColor = barTintColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    super.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return super.backgroundColor;
}

#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kMaterialBottomNavigationBundle]];
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

#pragma mark - GTCInkTouchControllerDelegate methods

- (GTCInkView *)inkTouchController:(GTCInkTouchController *)inkTouchController
            inkViewAtTouchLocation:(CGPoint)location {
    if ([inkTouchController.view isKindOfClass:[GTCBottomNavigationItemView class]]) {
        return ((GTCBottomNavigationItemView *)inkTouchController.view).inkView;
    }
    return nil;
}

@end
