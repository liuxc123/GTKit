//
//  GTCBottomSheetPresentationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>
#import "GTCBottomSheetController.h"

@class GTCBottomSheetPresentationController;

/**
 Delegate for GTCBottomSheetPresentationController.
 */
@protocol GTCBottomSheetPresentationControllerDelegate <UIAdaptivePresentationControllerDelegate>
@optional

/**
 Called before the bottom sheet is presented.

 @param bottomSheet The GTCBottomSheetPresentationController being presented.
 */
- (void)prepareForBottomSheetPresentation:
(nonnull GTCBottomSheetPresentationController *)bottomSheet;

/**
 Called after dimissing the bottom sheet to let clients know it is no longer onscreen. The bottom
 sheet controller calls this method only in response to user actions such as tapping the background
 or dragging the sheet offscreen. This method is not called if the bottom sheet is dismissed
 programmatically.

 @param bottomSheet The GTCBottomSheetPresentationController that was dismissed.
 */
- (void)bottomSheetPresentationControllerDidDismissBottomSheet:
(nonnull GTCBottomSheetPresentationController *)bottomSheet;

- (void)bottomSheetWillChangeState:(nonnull GTCBottomSheetPresentationController *)bottomSheet
                        sheetState:(GTCSheetState)sheetState;
@end

/**
 A UIPresentationController for presenting a modal view controller as a bottom sheet.
 */
@interface GTCBottomSheetPresentationController : UIPresentationController

/**
 Interactions with the tracking scroll view will affect the bottom sheet's drag behavior.

 If no trackingScrollView is provided, then one will be inferred from the associated view
 controller.
 */
@property(nonatomic, weak, nullable) UIScrollView *trackingScrollView;

/**
 When set to false, the bottom sheet controller can't be dismissed by tapping outside of sheet area.
 */
@property(nonatomic, assign) BOOL dismissOnBackgroundTap;

/**
 If @c YES, then the dimmed scrim view will act as an accessibility element for dismissing the
 bottom sheet.

 Defaults to @c NO.
 */
@property(nonatomic, assign) BOOL isScrimAccessibilityElement;

/**
 The @c accessibilityLabel value of the dimmed scrim view.

 Defaults to @c nil.
 */
@property(nullable, nonatomic, copy) NSString *scrimAccessibilityLabel;

/**
 The @c accessibilityHint value of the dimmed scrim view.

 Defaults to @c nil.
 */
@property(nullable, nonatomic, copy) NSString *scrimAccessibilityHint;

/**
 The @c accessibilityTraits of the dimmed scrim view.

 Defaults to @c UIAccessibilityTraitButton.
 */
@property(nonatomic, assign) UIAccessibilityTraits scrimAccessibilityTraits;

/**
 Delegate to tell the presenter when to dismiss.
 */
@property(nonatomic, weak, nullable) id<GTCBottomSheetPresentationControllerDelegate> delegate;

@end
