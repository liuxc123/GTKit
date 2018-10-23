//
//  GTCBottomNavigationBar.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

@protocol GTCBottomNavigationBarDelegate;

/** States used to configure bottom navigation on when to show item titles. */
typedef NS_ENUM(NSInteger, GTCBottomNavigationBarTitleVisibility) {

    // Default behavior is to show title when item is selected, hide otherwise.
    GTCBottomNavigationBarTitleVisibilitySelected = 0,

    // Item titles are always visible.
    GTCBottomNavigationBarTitleVisibilityAlways = 1,

    // Item titles are never visible.
    GTCBottomNavigationBarTitleVisibilityNever = 2
};

/**
 States used to configure bottom navigation in landscape mode with respect to how items are spaced
 and item title orientation. Titles will be shown or hidden depending on title hide state.
 */
typedef NS_ENUM(NSInteger, GTCBottomNavigationBarAlignment) {

    // Items are distributed using the entire width of the device, justified. Titles are centered
    // below icons.
    GTCBottomNavigationBarAlignmentJustified = 0,

    // Items are distributed using the entire width of the device, justified. Titles are positioned
    // adjacent to icons.
    GTCBottomNavigationBarAlignmentJustifiedAdjacentTitles = 1,

    // Items are tightly clustered together and centered on the navigation bar. Titles are positioned
    // below icons.
    GTCBottomNavigationBarAlignmentCentered = 2
};

/**
 A bottom navigation bar.

 The bottom navigation bar is docked at the bottom of the screen with tappable items. Only one item
 can be selected at at time. The selected item's title text is displayed. Title text for unselected
 items are hidden.
 */
@interface GTCBottomNavigationBar : UIView

/** The bottom navigation bar delegate. */
@property(nonatomic, weak, nullable) id<GTCBottomNavigationBarDelegate> delegate;

/**
 Configures when item titles should be displayed.
 Default is GTCBottomNavigationBarTitleVisibilitySelected.
 */
@property(nonatomic, assign) GTCBottomNavigationBarTitleVisibility titleVisibility
UI_APPEARANCE_SELECTOR;

/**
 Configures item space distribution and title orientation in landscape mode.
 Default is GTCBottomNavigationBarDistributionEqual.
 */
@property(nonatomic, assign) GTCBottomNavigationBarAlignment alignment UI_APPEARANCE_SELECTOR;

/**
 An array of UITabBarItems that is used to populate bottom navigation bar content. It is strongly
 recommended the array contain at least three items and no more than five items -- appearance may
 degrade outside of this range.
 */
@property(nonatomic, copy, nonnull) NSArray<UITabBarItem *> *items;

/**
 Selected item in the bottom navigation bar.
 Default is no item selected.
 */
@property(nonatomic, weak, nullable) UITabBarItem *selectedItem;

/**
 Display font used for item titles.
 Default is system font.
 */
@property(nonatomic, strong, nonnull) UIFont *itemTitleFont UI_APPEARANCE_SELECTOR;

/**
 Color of selected item. Applies color to items' icons and text. If set also sets
 selectedItemTitleColor. Default color is black.
 */
@property (nonatomic, strong, readwrite, nonnull) UIColor *selectedItemTintColor
UI_APPEARANCE_SELECTOR;

/**
 Color of the selected item's title text. Default color is black.
 */
@property(nonatomic, strong, readwrite, nonnull) UIColor *selectedItemTitleColor;

/**
 Color of unselected items. Applies color to items' icons. Text is not displayed in unselected mode.
 Default color is dark gray.
 */
@property (nonatomic, strong, readwrite, nonnull) UIColor *unselectedItemTintColor
UI_APPEARANCE_SELECTOR;

/**
 Color of the background of bottom navigation bar and the bar items.
 */
@property(nonatomic, strong, nullable) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

/**
 To color the background of the view use -barTintColor instead.
 */
@property(nullable, nonatomic,copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 The inset applied to each items bounds to determine the rect in which the items' contents will be
 centered. The contents are centered in this rect, but not compressed, so they may still extend
 beyond these bounds. Defaults to {0, 0, 0, 0}. The inset is flipped for RTL.
 */
@property(nonatomic, assign) UIEdgeInsets itemsContentInsets;

/**
 The margin between the item's icon and title when alignment is either Justified or Centered.
 Defaults to 0.
 */
@property(nonatomic, assign) CGFloat itemsContentVerticalMargin;

/**
 The margin between the item's icon and title when alignment is JustifiedAdjacentTitles. Defaults to
 12.
 */
@property(nonatomic, assign) CGFloat itemsContentHorizontalMargin;

/**
 Returns the navigation bar subview associated with the specific item.

 @param item A UITabBarItem
 */
- (nullable UIView *)viewForItem:(nonnull UITabBarItem *)item;

@end

#pragma mark - GTCBottomNavigationBarDelegate

/**
 Delegate protocol for GTCBottomNavigationBar. Clients may implement this protocol to receive
 notifications of selection changes by user action in the bottom navigation bar.
 */
@protocol GTCBottomNavigationBarDelegate <UINavigationBarDelegate>

@optional

/**
 Called before the selected item changes by user action. Return YES to allow the selection. If not
 implemented all items changes are allowed.
 */
- (BOOL)bottomNavigationBar:(nonnull GTCBottomNavigationBar *)bottomNavigationBar
           shouldSelectItem:(nonnull UITabBarItem *)item;

/**
 Called when the selected item changes by user action.
 */
- (void)bottomNavigationBar:(nonnull GTCBottomNavigationBar *)bottomNavigationBar
              didSelectItem:(nonnull UITabBarItem *)item;

@end
