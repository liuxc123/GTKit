//
//  GTCTabBar.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTCTabBarAlignment.h"
#import "GTCTabBarItemAppearance.h"
#import "GTCTabBarTextTransform.h"

@class GTCTabBarItem;
@protocol GTCTabBarDelegate;
@protocol GTCTabBarIndicatorTemplate;

typedef NS_ENUM(NSInteger, GTCTabBarItemState) {
    /** State for unselected tab bar item. */
    GTCTabBarItemStateNormal,
    /** State for selected tab bar item. */
    GTCTabBarItemStateSelected,
};

/**
 A material tab bar for switching between views of grouped content.

 Clients are responsible for responding to changes to the selected tab and updating the selected
 tab as necessary.

 Note: This class is not intended to be subclassed.

 @see https://material.io/go/design-tabs
 */
IB_DESIGNABLE
@interface GTCTabBar : UIView <UIBarPositioning>

/** The default height for the tab bar with a given position and item appearance. */
+ (CGFloat)defaultHeightForBarPosition:(UIBarPosition)position
                        itemAppearance:(GTCTabBarItemAppearance)appearance;

/** The default height for the tab bar in the top position, given an item appearance. */
+ (CGFloat)defaultHeightForItemAppearance:(GTCTabBarItemAppearance)appearance;

/**
 Items displayed in the tab bar.

 The bar determines the newly-selected item using the following logic:
 * Reselect the previously-selected item if it's still present in `items` after the update.
 * If there was no selection previously or if the old selected item is gone, select the first item.
 Clients that need empty selection to be preserved across updates to `items` must manually reset
 selectedItem to nil after the update.

 Changes to this property are not animated.
 */
@property(nonatomic, copy, nonnull) NSArray<UITabBarItem *> *items;

/**
 The currently selected item. Setting to nil will clear the selection.

 Changes to `selectedItem` are not animated.
 */
@property(nonatomic, strong, nullable) UITabBarItem *selectedItem;

/** The tab bar's delegate. */
@property(nonatomic, weak, nullable) IBOutlet id<GTCTabBarDelegate> delegate;

/**
 Tint color for the tab bar, which determines the color of the tab indicator bar. If
 selectedItemTintColor is nil, tintColor also affects tinting of selected item titles and images.
 */
@property(nonatomic, strong, null_resettable) UIColor *tintColor;

/**
 Tint color for selected items. If set overrides titleColorForState: and imageTintColorForState:
 for GTCTabBarItemStateSelected. Returns imageTintColorForState: for GTCTabBarItemStateSelected.
 */
@property(nonatomic, nullable) UIColor *selectedItemTintColor UI_APPEARANCE_SELECTOR;

/**
 Tint color for unselected items. If set overrides titleColorForState: and imageTintColorForState:
 for GTCTabBarItemStateNormal. Returns imageTintColorForState: for GTCTabBarItemStateNormal.
 */
@property(nonatomic, nonnull) UIColor *unselectedItemTintColor UI_APPEARANCE_SELECTOR;

/** Ink color for taps on tab bar items. Default: Semi-transparent white. */
@property(nonatomic, nonnull) UIColor *inkColor UI_APPEARANCE_SELECTOR;

/** Color for the bottom divider. Default: Clear. */
@property(nonatomic, nonnull) UIColor *bottomDividerColor;

/**
 Font used for selected item titles.
 By default this uses +[GTCTypography buttonFont]. Ignored for bottom-position tab bars.

 Note: Tab sizes are determined based on their unselected state and do not vary based on selection.
 To avoid clipped layouts and other layout issues, the font provided here should have similar
 metrics to `unselectedItemTitleFont`.
 */
@property(nonatomic, strong, nonnull) UIFont *selectedItemTitleFont UI_APPEARANCE_SELECTOR;

/**
 Font used for unselected item titles.
 By default this uses the GTCTypography button font. Ignored for bottom-position tab bars.

 Note: Tab sizes are determined based on their unselected state and do not vary based on selection.
 To avoid clipped layouts and other layout issues, the font provided here should have similar
 metrics to `selectedItemTitleFont`.
 */
@property(nonatomic, strong, nonnull) UIFont *unselectedItemTitleFont UI_APPEARANCE_SELECTOR;

/**
 Tint color to apply to the tab bar background.

 If nil, the receiver uses the default background appearance. Default: nil.
 */
@property(nonatomic, nullable) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

/**
 Horizontal alignment of tabs within the tab bar. Changes are not animated. Default alignment is
 GTCTabBarAlignmentLeading.

 The default value is based on the position and is recommended for most applications.
 */
@property(nonatomic) GTCTabBarAlignment alignment;

/**
 Appearance of tabs within the tab bar. Changes are not animated.

 The default value is based on the position and is recommended for most applications.
 */
@property(nonatomic) GTCTabBarItemAppearance itemAppearance;

/**
 Indicates if all tab titles should be uppercased for display. If NO, item titles will be displayed
 verbatim.

 The default value is based on the position and is recommended for most applications.

 NOTE: This property will be deprecated in a future release. Use `titleTextTransform` instead.
 https://github.com/material-components/material-components-ios/issues/2552
 */
@property(nonatomic) IBInspectable BOOL displaysUppercaseTitles;

/**
 Defines how tab bar item titles are transformed for display.

 The default value is GTCTabBarTextTransformAutomatic.
 */
@property(nonatomic) GTCTabBarTextTransform titleTextTransform UI_APPEARANCE_SELECTOR;

/**
 Template that defines the appearance of the selection indicator.

 The default indicator template is a fixed-height rectangular bar under the selected tab.
 */
@property(nonatomic, null_resettable) id<GTCTabBarIndicatorTemplate> selectionIndicatorTemplate
UI_APPEARANCE_SELECTOR;

/**
 Select an item with optional animation. Setting to nil will clear the selection.

 `selectedItem` must be nil or in `items`.
 */
- (void)setSelectedItem:(nullable UITabBarItem *)selectedItem animated:(BOOL)animated;

/** Updates the alignment with optional animation. */
- (void)setAlignment:(GTCTabBarAlignment)alignment animated:(BOOL)animated;

/**
 Sets the color of the title for the specified state.

 If the @c GTCTabBarItemState value is not set, then defaults to a default value. Therefore,
 at a minimum, you should set the value for GTCTabBarItemStateNormal.
 */
- (void)setTitleColor:(nullable UIColor *)color forState:(GTCTabBarItemState)state;

/** Returns the title color associated with the specified state. */
- (nullable UIColor *)titleColorForState:(GTCTabBarItemState)state;

/**
 Sets the tint color of the image for the specified state.

 If the @c GTCTabBarItemState value is not set, then defaults to a default value. Therefore,
 at a minimum, you should set the value for GTCTabBarItemStateNormal.
 */
- (void)setImageTintColor:(nullable UIColor *)color forState:(GTCTabBarItemState)state;

/** Returns the image tint color associated with the specified state. */
- (nullable UIColor *)imageTintColorForState:(GTCTabBarItemState)state;

@end

#pragma mark -

/** Accessibility-related methods on GTCTabBar. */
@interface GTCTabBar (GTCAccessibility)

/**
 Get the accessibility element representing the given item. Returns nil if item is not in `items`
 or if the item is not on screen.

 The accessibility element returned from this method may be used as the focused element after a
 run loop iteration.
 */
- (nullable id)accessibilityElementForItem:(nonnull UITabBarItem *)item;

@end

#pragma mark -

/**
 Delegate protocol for GTCTabBar. Clients may implement this protocol to receive notifications of
 selection changes in the tab bar or to determine the bar's position.
 */
@protocol GTCTabBarDelegate <UIBarPositioningDelegate>

@optional

/**
 Called before the selected item changes by user action. This method is not called for programmatic
 changes to the tab bar's selected item. Return YES to allow the selection.
 If you don't implement all items changes are allowed.
 */
- (BOOL)tabBar:(nonnull GTCTabBar *)tabBar shouldSelectItem:(nonnull UITabBarItem *)item;

/**
 Called before the selected item changes by user action. This method is not called for programmatic
 changes to the tab bar's selected item.  NOTE: Will be deprecated. Use tabBar:shouldSelectItem:.
 */
- (void)tabBar:(nonnull GTCTabBar *)tabBar willSelectItem:(nonnull UITabBarItem *)item;

/**
 Called when the selected item changes by user action. This method is not called for programmatic
 changes to the tab bar's selected item.
 */
- (void)tabBar:(nonnull GTCTabBar *)tabBar didSelectItem:(nonnull UITabBarItem *)item;

@end

