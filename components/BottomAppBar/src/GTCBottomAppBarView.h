//
//  GTCBottomAppBarView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTButtons.h"

/** The elevation of the floating action button. */
typedef NS_ENUM(NSInteger, GTCBottomAppBarFloatingButtonElevation) {
    GTCBottomAppBarFloatingButtonElevationPrimary = 0,
    GTCBottomAppBarFloatingButtonElevationSecondary = 1
};

/** The position of the floating action button. */
typedef NS_ENUM(NSInteger, GTCBottomAppBarFloatingButtonPosition) {
    GTCBottomAppBarFloatingButtonPositionCenter = 0,
    GTCBottomAppBarFloatingButtonPositionLeading = 1,
    GTCBottomAppBarFloatingButtonPositionTrailing = 2
};

/**
 A bottom app bar view with an embedded floating button.

 The bottom app bar is a bar docked at the bottom of the screen. A floating action button is
 provided for a primary action.
 */
@interface GTCBottomAppBarView : UIView

/**
 Is the floating button on the bottom bar hidden.
 Default is NO.
 */
@property(nonatomic, assign, getter=isFloatingButtonHidden) BOOL floatingButtonHidden;

/**
 The elevation of the floating action button.
 Default is GTCBottomAppBarFloatingButtonElevationPrimary.
 */
@property(nonatomic, assign) GTCBottomAppBarFloatingButtonElevation floatingButtonElevation;

/**
 The position of the floating action button.
 Default is GTCBottomAppBarFloatingButtonPositionCenter.
 */
@property(nonatomic, assign) GTCBottomAppBarFloatingButtonPosition floatingButtonPosition;

/**
 The floating button on the bottom bar. This button is exposed for customizability.
 */
@property(nonatomic, strong, nonnull, readonly) GTCFloatingButton *floatingButton;

/**
 The offset from the center of the floating button to the top edge of the navigation bar
 */
@property(nonatomic, assign) CGFloat floatingButtonVerticalOffset;

/**
 Navigation bar items that precede the floating action button. There is no limit to the number of
 buttons that can be added, but button bar width overflow is not handled.
 */
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *leadingBarButtonItems;

/**
 Navigation bar items that trail the floating action button. There is no limit to the number of
 buttons that can be added, but button bar width overflow is not handled.
 */
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *trailingBarButtonItems;

/**
 Color of the background of the bottom app bar.
 */
@property(nullable, nonatomic, strong) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

/**
 The @c tintColor applied to the bar items on the leading side of the BottomAppBar.
 */
@property(nonnull, nonatomic, strong) UIColor *leadingBarItemsTintColor;

/**
 The @c tintColor applied to the bar items on the trailing side of the BottomAppBar.
 */
@property(nonnull, nonatomic, strong) UIColor *trailingBarItemsTintColor;

/**
 To color the background of the view use -barTintColor instead.
 */
@property(nullable, nonatomic, copy) UIColor *backgroundColor NS_UNAVAILABLE;

/**
 The color of the shadow under the bottom app bar.

 To set the shadow color of the Floating Action Button, set it directly on the button.
 */
@property(nullable, nonatomic, strong) UIColor *shadowColor UI_APPEARANCE_SELECTOR;

/**
 Sets the visibility of the floating action button.

 @param animated Enable or disable animation.
 */
- (void)setFloatingButtonHidden:(BOOL)floatingButtonHidden animated:(BOOL)animated;

/**
 Sets the elevation of the floating action button. Note, if the set elevation is the same as the
 current elevation there is no change in the elevation nor animation.

 @param animated Enable or disable animation.
 */
- (void)setFloatingButtonElevation:(GTCBottomAppBarFloatingButtonElevation)floatingButtonElevation
                          animated:(BOOL)animated;

/**
 Sets the position of the floating action button. Note, if the set position is the same as the
 current position there is no change in the position nor animation.

 @param animated Enable or disable animation.
 */
- (void)setFloatingButtonPosition:(GTCBottomAppBarFloatingButtonPosition)floatingButtonPosition
                         animated:(BOOL)animated;

@end
