//
//  GTCTabBar.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCTabBar.h"

#import "GTCTabBarIndicatorTemplate.h"
#import "GTCTabBarUnderlineIndicatorTemplate.h"
#import "GTInk.h"
#import "GTTypography.h"
#import "private/GTCItemBar.h"
#import "private/GTCItemBarAlignment.h"
#import "private/GTCItemBarStyle.h"

static NSString *const GTCTabBarItemsKey = @"GTCTabBarItemsKey";
static NSString *const GTCTabBarSelectedItemKey = @"GTCTabBarSelectedItemKey";
static NSString *const GTCTabBarDelegateKey = @"GTCTabBarDelegateKey";
static NSString *const GTCTabBarTintColorKey = @"GTCTabBarTintColorKey";
static NSString *const GTCTabBarSelectedItemTintColorKey = @"GTCTabBarSelectedItemTintColorKey";
static NSString *const GTCTabBarUnselectedItemTintColorKey = @"GTCTabBarUnselectedItemTintColorKey";
static NSString *const GTCTabBarInkColorKey = @"GTCTabBarInkColorKey";
static NSString *const GTCTabBarSelectedItemTitleFontKey = @"GTCTabBarSelectedItemTitleFontKey";
static NSString *const GTCTabBarUnselectedItemTitleFontKey = @"GTCTabBarUnselectedItemTitleFontKey";
static NSString *const GTCTabBarBarTintColorKey = @"GTCTabBarBarTintColorKey";
static NSString *const GTCTabBarAlignmentKey = @"GTCTabBarAlignmentKey";
static NSString *const GTCTabBarItemApperanceKey = @"GTCTabBarItemApperanceKey";
static NSString *const GTCTabBarDisplaysUppercaseTitlesKey = @"GTCTabBarDisplaysUppercaseTitlesKey";
static NSString *const GTCTabBarTitleTextTransformKey = @"GTCTabBarTitleTextTransformKey";
static NSString *const GTCTabBarSelectionIndicatorTemplateKey = @"GTCTabBarSelectionIndicatorTemplateKey";

/// Padding between image and title in points, according to the spec.
static const CGFloat kImageTitleSpecPadding = 10;

/// Adjustment added to spec measurements to compensate for internal paddings.
static const CGFloat kImageTitlePaddingAdjustment = -3;

// Heights based on the spec: https://material.io/go/design-tabs

/// Height for image-only tab bars, in points.
static const CGFloat kImageOnlyBarHeight = 48;

/// Height for image-only tab bars, in points.
static const CGFloat kTitleOnlyBarHeight = 48;

/// Height for image-and-title tab bars, in points.
static const CGFloat kTitledImageBarHeight = 72;

/// Height for bottom navigation bars, in points.
static const CGFloat kBottomNavigationBarHeight = 56;

/// Maximum width for individual items in bottom navigation bars, in points.
static const CGFloat kBottomNavigationMaximumItemWidth = 168;

/// Title-image padding for bottom navigation bars, in points.
static const CGFloat kBottomNavigationTitleImagePadding = 3;

/// Height for the bottom divider.
static const CGFloat kBottomNavigationBarDividerHeight = 1;

static GTCItemBarAlignment GTCItemBarAlignmentForTabBarAlignment(GTCTabBarAlignment alignment) {
    switch (alignment) {
        case GTCTabBarAlignmentCenter:
            return GTCItemBarAlignmentCenter;

        case GTCTabBarAlignmentLeading:
            return GTCItemBarAlignmentLeading;

        case GTCTabBarAlignmentJustified:
            return GTCItemBarAlignmentJustified;

        case GTCTabBarAlignmentCenterSelected:
            return GTCItemBarAlignmentCenterSelected;
    }

    NSCAssert(0, @"Invalid alignment value %ld", (long)alignment);
    return GTCItemBarAlignmentLeading;
}

@interface GTCTabBar () <GTCItemBarDelegate>
@end

@implementation GTCTabBar {
    /// Item bar responsible for displaying the actual tab bar content.
    GTCItemBar *_itemBar;

    UIView *_dividerBar;

    // Flags tracking if properties are unset and using default values.
    BOOL _hasDefaultAlignment;
    BOOL _hasDefaultItemAppearance;

    // For properties which have been set, these store the new fixed values.
    GTCTabBarAlignment _alignmentOverride;
    GTCTabBarItemAppearance _itemAppearanceOverride;

    UIColor *_selectedTitleColor;
    UIColor *_unselectedTitleColor;
}
// Inherit UIView's tintColor logic.
@dynamic tintColor;
@synthesize alignment = _alignment;
@synthesize barPosition = _barPosition;
@synthesize itemAppearance = _itemAppearance;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCTabBarInit];

        // Use self. when setter needs to be called
        if ([aDecoder containsValueForKey:GTCTabBarItemsKey]) {
            self.items = [aDecoder decodeObjectOfClass:[NSArray class] forKey:GTCTabBarItemsKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarSelectedItemKey]) {
            self.selectedItem = [aDecoder decodeObjectOfClass:[UIBarButtonItem class]
                                                       forKey:GTCTabBarSelectedItemKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarDelegateKey]) {
            self.delegate = [aDecoder decodeObjectForKey:GTCTabBarDelegateKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarTintColorKey]) {
            self.tintColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                    forKey:GTCTabBarTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarSelectedItemTintColorKey]) {
            _selectedItemTintColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                            forKey:GTCTabBarSelectedItemTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarUnselectedItemTintColorKey]) {
            _unselectedItemTintColor =
            [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTCTabBarUnselectedItemTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarInkColorKey]) {
            _inkColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTCTabBarInkColorKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarSelectedItemTitleFontKey]) {
            _selectedItemTitleFont = [aDecoder decodeObjectOfClass:[UIFont class]
                                                            forKey:GTCTabBarSelectedItemTitleFontKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarUnselectedItemTitleFontKey]) {
            _unselectedItemTitleFont =
            [aDecoder decodeObjectOfClass:[UIFont class] forKey:GTCTabBarUnselectedItemTitleFontKey];
        }

        if ([aDecoder containsValueForKey:GTCTabBarBarTintColorKey]) {
            self.barTintColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                       forKey:GTCTabBarBarTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarAlignmentKey]) {
            self.alignment = [aDecoder decodeIntegerForKey:GTCTabBarAlignmentKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarItemApperanceKey]) {
            self.itemAppearance = [aDecoder decodeIntegerForKey:GTCTabBarItemApperanceKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarDisplaysUppercaseTitlesKey]) {
            self.displaysUppercaseTitles = [aDecoder decodeBoolForKey:GTCTabBarDisplaysUppercaseTitlesKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarTitleTextTransformKey]) {
            _titleTextTransform = [aDecoder decodeIntegerForKey:GTCTabBarTitleTextTransformKey];
        }
        if ([aDecoder containsValueForKey:GTCTabBarSelectionIndicatorTemplateKey]) {
            _selectionIndicatorTemplate =
            [aDecoder decodeObjectOfClass:[NSObject class]
                                   forKey:GTCTabBarSelectionIndicatorTemplateKey];
        }
        [self updateItemBarStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCTabBarInit];
    }
    return self;
}

- (void)commonGTCTabBarInit {
    _bottomDividerColor = [UIColor clearColor];
    _selectedItemTintColor = [UIColor whiteColor];
    _unselectedItemTintColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _selectedTitleColor = _selectedItemTintColor;
    _unselectedTitleColor = _unselectedItemTintColor;
    _inkColor = [UIColor colorWithWhite:1.0f alpha:0.7f];

    self.clipsToBounds = YES;
    _barPosition = UIBarPositionAny;
    _hasDefaultItemAppearance = YES;
    _hasDefaultAlignment = YES;

    // Set default values
    _alignment = [self computedAlignment];
    _titleTextTransform = GTCTabBarTextTransformAutomatic;
    _itemAppearance = [self computedItemAppearance];
    _selectionIndicatorTemplate = [GTCTabBar defaultSelectionIndicatorTemplate];
    _selectedItemTitleFont = [GTCTypography buttonFont];
    _unselectedItemTitleFont = [GTCTypography buttonFont];

    // Create item bar.
    _itemBar = [[GTCItemBar alloc] initWithFrame:self.bounds];
    _itemBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _itemBar.delegate = self;
    _itemBar.alignment = GTCItemBarAlignmentForTabBarAlignment(_alignment);
    [self addSubview:_itemBar];

    CGFloat dividerTop = CGRectGetMaxY(self.bounds) - kBottomNavigationBarDividerHeight;
    _dividerBar =
    [[UIView alloc] initWithFrame:CGRectMake(0,
                                             dividerTop,
                                             CGRectGetWidth(self.bounds),
                                             kBottomNavigationBarDividerHeight)];
    _dividerBar.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _dividerBar.backgroundColor = _bottomDividerColor;
    [self addSubview:_dividerBar];

    [self updateItemBarStyle];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize sizeThatFits = [_itemBar sizeThatFits:self.bounds.size];
    _itemBar.frame = CGRectMake(0, 0, sizeThatFits.width, sizeThatFits.height);
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.items forKey:GTCTabBarItemsKey];
    [aCoder encodeObject:self.selectedItem forKey:GTCTabBarSelectedItemKey];
    [aCoder encodeConditionalObject:self.delegate forKey:GTCTabBarDelegateKey];
    [aCoder encodeObject:self.tintColor forKey:GTCTabBarTintColorKey];
    [aCoder encodeObject:_selectedItemTintColor forKey:GTCTabBarSelectedItemTintColorKey];
    [aCoder encodeObject:_unselectedItemTintColor forKey:GTCTabBarUnselectedItemTintColorKey];
    [aCoder encodeObject:_inkColor forKey:GTCTabBarInkColorKey];
    [aCoder encodeObject:_selectedItemTitleFont forKey:GTCTabBarSelectedItemTitleFontKey];
    [aCoder encodeObject:_unselectedItemTitleFont forKey:GTCTabBarUnselectedItemTitleFontKey];
    [aCoder encodeObject:_barTintColor forKey:GTCTabBarBarTintColorKey];
    [aCoder encodeInteger:_alignment forKey:GTCTabBarAlignmentKey];
    [aCoder encodeInteger:_itemAppearance forKey:GTCTabBarItemApperanceKey];
    [aCoder encodeBool:self.displaysUppercaseTitles forKey:GTCTabBarDisplaysUppercaseTitlesKey];
    [aCoder encodeInteger:_titleTextTransform forKey:GTCTabBarTitleTextTransformKey];
    if ([_selectionIndicatorTemplate conformsToProtocol:@protocol(NSCoding)]) {
        [aCoder encodeObject:_selectionIndicatorTemplate
                      forKey:GTCTabBarSelectionIndicatorTemplateKey];
    }
}

#pragma mark - Public

+ (CGFloat)defaultHeightForBarPosition:(UIBarPosition)position
                        itemAppearance:(GTCTabBarItemAppearance)appearance {
    if ([self isTopTabsForPosition:position]) {
        switch (appearance) {
            case GTCTabBarItemAppearanceTitledImages:
                return kTitledImageBarHeight;

            case GTCTabBarItemAppearanceTitles:
                return kTitleOnlyBarHeight;

            case GTCTabBarItemAppearanceImages:
                return kImageOnlyBarHeight;
        }
    } else {
        // Bottom navigation has a fixed height.
        return kBottomNavigationBarHeight;
    }
}

+ (CGFloat)defaultHeightForItemAppearance:(GTCTabBarItemAppearance)appearance {
    return [self defaultHeightForBarPosition:UIBarPositionAny itemAppearance:appearance];
}

- (void)setTitleColor:(nullable UIColor *)color forState:(GTCTabBarItemState)state {
    switch (state) {
        case GTCTabBarItemStateNormal:
            _unselectedTitleColor = color;
            break;
        case GTCTabBarItemStateSelected:
            _selectedTitleColor = color;
            break;
    }
    [self updateItemBarStyle];
}

- (nullable UIColor *)titleColorForState:(GTCTabBarItemState)state {
    switch (state) {
        case GTCTabBarItemStateNormal:
            return _unselectedTitleColor;
            break;
        case GTCTabBarItemStateSelected:
            return _selectedTitleColor;
            break;
    }
}

- (void)setImageTintColor:(nullable UIColor *)color forState:(GTCTabBarItemState)state {
    switch (state) {
        case GTCTabBarItemStateNormal:
            _unselectedItemTintColor = color;
            break;
        case GTCTabBarItemStateSelected:
            _selectedItemTintColor = color;
            break;
    }
    [self updateItemBarStyle];
}

- (nullable UIColor *)imageTintColorForState:(GTCTabBarItemState)state {
    switch (state) {
        case GTCTabBarItemStateNormal:
            return _unselectedItemTintColor;
            break;
        case GTCTabBarItemStateSelected:
            return _selectedItemTintColor;
            break;
    }
}

- (void)setDelegate:(id<GTCTabBarDelegate>)delegate {
    if (delegate != _delegate) {
        _delegate = delegate;

        // Delegate determines the position - update immediately.
        [self updateItemBarPosition];
    }
}

- (NSArray<UITabBarItem *> *)items {
    return _itemBar.items;
}

- (void)setItems:(NSArray<UITabBarItem *> *)items {
    _itemBar.items = items;
}

- (UITabBarItem *)selectedItem {
    return _itemBar.selectedItem;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    _itemBar.selectedItem = selectedItem;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem animated:(BOOL)animated {
    [_itemBar setSelectedItem:selectedItem animated:animated];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    if (_barTintColor != barTintColor && ![_barTintColor isEqual:barTintColor]) {
        _barTintColor = barTintColor;

        // Update background color.
        self.backgroundColor = barTintColor;
    }
}

- (void)setInkColor:(UIColor *)inkColor {
    if (_inkColor != inkColor && ![_inkColor isEqual:inkColor]) {
        _inkColor = inkColor;

        [self updateItemBarStyle];
    }
}

- (void)setUnselectedItemTitleFont:(UIFont *)unselectedItemTitleFont {
    if ((unselectedItemTitleFont != _unselectedItemTitleFont) &&
        ![unselectedItemTitleFont isEqual:_unselectedItemTitleFont]) {
        _unselectedItemTitleFont = unselectedItemTitleFont;
        [self updateItemBarStyle];
    }
}

- (void)setSelectedItemTitleFont:(UIFont *)selectedItemTitleFont {
    if ((selectedItemTitleFont != _selectedItemTitleFont) &&
        ![selectedItemTitleFont isEqual:_selectedItemTitleFont]) {
        _selectedItemTitleFont = selectedItemTitleFont;
        [self updateItemBarStyle];
    }
}

- (void)setAlignment:(GTCTabBarAlignment)alignment {
    [self setAlignment:alignment animated:NO];
}

- (void)setAlignment:(GTCTabBarAlignment)alignment animated:(BOOL)animated {
    _hasDefaultAlignment = NO;
    _alignmentOverride = alignment;
    [self internalSetAlignment:[self computedAlignment] animated:animated];
}

- (void)setItemAppearance:(GTCTabBarItemAppearance)itemAppearance {
    _hasDefaultItemAppearance = NO;
    _itemAppearanceOverride = itemAppearance;
    [self internalSetItemAppearance:[self computedItemAppearance]];
}

- (void)setSelectedItemTintColor:(UIColor *)selectedItemTintColor {
    if (_selectedItemTintColor != selectedItemTintColor &&
        ![_selectedItemTintColor isEqual:selectedItemTintColor]) {
        _selectedItemTintColor = selectedItemTintColor;
        _selectedTitleColor = selectedItemTintColor;

        [self updateItemBarStyle];
    }
}

- (void)setUnselectedItemTintColor:(UIColor *)unselectedItemTintColor {
    if (_unselectedItemTintColor != unselectedItemTintColor &&
        ![_unselectedItemTintColor isEqual:unselectedItemTintColor]) {
        _unselectedItemTintColor = unselectedItemTintColor;
        _unselectedTitleColor = unselectedItemTintColor;

        [self updateItemBarStyle];
    }
}

- (BOOL)displaysUppercaseTitles {
    switch (self.titleTextTransform) {
        case GTCTabBarTextTransformAutomatic:
            return [GTCTabBar displaysUppercaseTitlesByDefaultForPosition:_barPosition];

        case GTCTabBarTextTransformNone:
            return NO;

        case GTCTabBarTextTransformUppercase:
            return YES;
    }
}

- (void)setDisplaysUppercaseTitles:(BOOL)displaysUppercaseTitles {
    self.titleTextTransform =
    displaysUppercaseTitles ? GTCTabBarTextTransformUppercase : GTCTabBarTextTransformNone;
}

- (void)setTitleTextTransform:(GTCTabBarTextTransform)titleTextTransform {
    if (titleTextTransform != _titleTextTransform) {
        _titleTextTransform = titleTextTransform;
        [self updateItemBarStyle];
    }
}

- (void)setSelectionIndicatorTemplate:(id<GTCTabBarIndicatorTemplate>)selectionIndicatorTemplate {
    id<GTCTabBarIndicatorTemplate> template = selectionIndicatorTemplate;
    if (!template) {
        template = [GTCTabBar defaultSelectionIndicatorTemplate];
    }
    _selectionIndicatorTemplate = template;
    [self updateItemBarStyle];
}

- (void)setBottomDividerColor:(UIColor *)bottomDividerColor {
    if (_bottomDividerColor != bottomDividerColor) {
        _bottomDividerColor = bottomDividerColor;
        _dividerBar.backgroundColor = _bottomDividerColor;
    }
}

#pragma mark - GTCAccessibility

- (id)accessibilityElementForItem:(UITabBarItem *)item {
    return [_itemBar accessibilityElementForItem:item];
}

#pragma mark - GTCItemBarDelegate

- (void)itemBar:(__unused GTCItemBar *)itemBar didSelectItem:(UITabBarItem *)item {
    id<GTCTabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [delegate tabBar:self didSelectItem:item];
    }
}

- (BOOL)itemBar:(__unused GTCItemBar *)itemBar shouldSelectItem:(UITabBarItem *)item {
    id<GTCTabBarDelegate> delegate = self.delegate;
    BOOL shouldSelect = YES;
    if ([delegate respondsToSelector:@selector(tabBar:shouldSelectItem:)]) {
        shouldSelect = [delegate tabBar:self shouldSelectItem:item];
    }
    if (shouldSelect && [delegate respondsToSelector:@selector(tabBar:willSelectItem:)]) {
        [delegate tabBar:self willSelectItem:item];
    }
    return shouldSelect;
}

#pragma mark - UIView

- (void)tintColorDidChange {
    [super tintColorDidChange];

    [self updateItemBarStyle];
}

- (CGSize)intrinsicContentSize {
    return _itemBar.intrinsicContentSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_itemBar sizeThatFits:size];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    // Ensure the bar position is up to date before moving to a window.
    [self updateItemBarPosition];
}

#pragma mark - Private

+ (GTCItemBarStyle *)defaultStyleForPosition:(UIBarPosition)position
                              itemAppearance:(GTCTabBarItemAppearance)appearance {
    GTCItemBarStyle *style = [[GTCItemBarStyle alloc] init];

    // Set base style using position.
    if ([self isTopTabsForPosition:position]) {
        // Top tabs
        style.shouldDisplaySelectionIndicator = YES;
        style.shouldGrowOnSelection = NO;
        style.inkStyle = GTCInkStyleBounded;
        style.titleImagePadding = (kImageTitleSpecPadding + kImageTitlePaddingAdjustment);
        style.textOnlyNumberOfLines = 2;
    } else {
        // Bottom navigation
        style.shouldDisplaySelectionIndicator = NO;
        style.shouldGrowOnSelection = YES;
        style.maximumItemWidth = kBottomNavigationMaximumItemWidth;
        style.inkStyle = GTCInkStyleUnbounded;
        style.titleImagePadding = kBottomNavigationTitleImagePadding;
        style.textOnlyNumberOfLines = 1;
    }

    // Update appearance-dependent style properties.
    BOOL displayImage = NO;
    BOOL displayTitle = NO;
    switch (appearance) {
        case GTCTabBarItemAppearanceImages:
            displayImage = YES;
            break;

        case GTCTabBarItemAppearanceTitles:
            displayTitle = YES;
            break;

        case GTCTabBarItemAppearanceTitledImages:
            displayImage = YES;
            displayTitle = YES;
            break;

        default:
            NSAssert(0, @"Invalid appearance value %ld", (long)appearance);
            displayTitle = YES;
            break;
    }
    style.shouldDisplayImage = displayImage;
    style.shouldDisplayTitle = displayTitle;

    // Update default height
    CGFloat defaultHeight = [self defaultHeightForBarPosition:position itemAppearance:appearance];
    if (defaultHeight == 0) {
        NSAssert(0, @"Missing default height for %ld", (long)appearance);
        defaultHeight = kTitleOnlyBarHeight;
    }
    style.defaultHeight = defaultHeight;

    // Only show badge with images.
    style.shouldDisplayBadge = displayImage;

    return style;
}

+ (BOOL)isTopTabsForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return YES;

        case UIBarPositionBottom:
            return NO;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTCTabBar does not support UIBarPositionTopAttached");
            return NO;
    }
}

+ (BOOL)displaysUppercaseTitlesByDefaultForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return YES;

        case UIBarPositionBottom:
            return NO;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTCTabBar does not support UIBarPositionTopAttached");
            return YES;
    }
}

+ (GTCTabBarAlignment)defaultAlignmentForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return GTCTabBarAlignmentLeading;

        case UIBarPositionBottom:
            return GTCTabBarAlignmentJustified;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTCTabBar does not support UIBarPositionTopAttached");
            return GTCTabBarAlignmentLeading;
    }
}

+ (GTCTabBarItemAppearance)defaultItemAppearanceForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return GTCTabBarItemAppearanceTitles;

        case UIBarPositionBottom:
            return GTCTabBarItemAppearanceTitledImages;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTCTabBar does not support UIBarPositionTopAttached");
            return YES;
    }
}

+ (id<GTCTabBarIndicatorTemplate>)defaultSelectionIndicatorTemplate {
    return [[GTCTabBarUnderlineIndicatorTemplate alloc] init];
}

- (GTCTabBarAlignment)computedAlignment {
    if (_hasDefaultAlignment) {
        return [[self class] defaultAlignmentForPosition:_barPosition];
    } else {
        return _alignmentOverride;
    }
}

- (GTCTabBarItemAppearance)computedItemAppearance {
    if (_hasDefaultItemAppearance) {
        return [[self class] defaultItemAppearanceForPosition:_barPosition];
    } else {
        return _itemAppearanceOverride;
    }
}

- (void)internalSetAlignment:(GTCTabBarAlignment)alignment animated:(BOOL)animated {
    if (_alignment != alignment) {
        _alignment = alignment;
        [_itemBar setAlignment:GTCItemBarAlignmentForTabBarAlignment(_alignment) animated:animated];
    }
}

- (void)internalSetItemAppearance:(GTCTabBarItemAppearance)itemAppearance {
    if (_itemAppearance != itemAppearance) {
        _itemAppearance = itemAppearance;
        [self updateItemBarStyle];
    }
}

- (void)updateItemBarPosition {
    UIBarPosition newPosition = UIBarPositionAny;
    id<GTCTabBarDelegate> delegate = _delegate;
    if (delegate && [delegate respondsToSelector:@selector(positionForBar:)]) {
        newPosition = [delegate positionForBar:self];
    }

    if (_barPosition != newPosition) {
        _barPosition = newPosition;
        [self updatePositionDerivedDefaultValues];
        [self updateItemBarStyle];
    }
}

- (void)updatePositionDerivedDefaultValues {
    [self internalSetAlignment:[self computedAlignment] animated:NO];
    [self internalSetItemAppearance:[self computedItemAppearance]];
}

/// Update the item bar's style property, which depends on the bar position and item appearance.
- (void)updateItemBarStyle {
    GTCItemBarStyle *style;

    style = [[self class] defaultStyleForPosition:_barPosition itemAppearance:_itemAppearance];

    if ([GTCTabBar isTopTabsForPosition:_barPosition]) {
        // Top tabs: Use provided fonts.
        style.selectedTitleFont = self.selectedItemTitleFont;
        style.unselectedTitleFont = self.unselectedItemTitleFont;
    } else {
        // Bottom navigation: Ignore provided fonts.
        style.selectedTitleFont = [[GTCTypography fontLoader] regularFontOfSize:12];
        style.unselectedTitleFont = [[GTCTypography fontLoader] regularFontOfSize:12];
    }

    style.selectionIndicatorTemplate = self.selectionIndicatorTemplate;
    style.selectionIndicatorColor = self.tintColor;
    style.inkColor = _inkColor;
    style.displaysUppercaseTitles = self.displaysUppercaseTitles;

    style.selectedTitleColor = _selectedTitleColor ?: self.tintColor;
    style.titleColor = _unselectedTitleColor;
    style.selectedImageTintColor = _selectedItemTintColor ?: self.tintColor;
    style.imageTintColor = _unselectedItemTintColor;

    [_itemBar applyStyle:style];

    // Layout depends on -[GTCItemBar sizeThatFits], which depends on the style.
    [self setNeedsLayout];
}

@end
