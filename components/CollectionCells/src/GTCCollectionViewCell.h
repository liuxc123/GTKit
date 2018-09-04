//
//  GTCCollectionViewCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import "GTInk.h"

#import <UIKit/UIKit.h>

/** The available cell accessory view types. Based on UITableViewCellAccessoryType. */
typedef NS_ENUM(NSUInteger, GTCCollectionViewCellAccessoryType) {
    /** Default value. No accessory view shown. */
    GTCCollectionViewCellAccessoryNone,

    /** A chevron accessory view. */
    GTCCollectionViewCellAccessoryDisclosureIndicator,

    /** A checkmark accessory view. */
    GTCCollectionViewCellAccessoryCheckmark,

    /** An info button accessory view. */
    GTCCollectionViewCellAccessoryDetailButton
};

// String key for accessibility hint of selected cells.
FOUNDATION_EXPORT NSString *_Nonnull const kSelectedCellAccessibilityHintKey;

// String key for accessibility hint of deselected cells.
FOUNDATION_EXPORT NSString *_Nonnull const kDeselectedCellAccessibilityHintKey;

/**
 The GTCCollectionViewCell class provides an implementation of UICollectionViewCell that
 supports Material Design layout and styling.
 */
@interface GTCCollectionViewCell : UICollectionViewCell

/** The accessory type for this cell. Default is GTCCollectionViewCellAccessoryNone. */
@property(nonatomic) GTCCollectionViewCellAccessoryType accessoryType;

/** If set, use custom view and ignore accessoryType. Defaults to nil. */
@property(nonatomic, strong, nullable) UIView *accessoryView;

/**
 The accessory inset for this cell. Only left/right insets are valid as top/bottom insets will
 be ignored. These insets are used for both accessories and editing mask controls.
 Defaults to {0, 16.0f, 0, 16.0f}.
 */
@property(nonatomic) UIEdgeInsets accessoryInset;

/**
 Whether to hide the separator for this cell. If not set, the @c shouldHideSeparators property of
 the collection view styler will be used. Defaults to NO.
 */
@property(nonatomic) BOOL shouldHideSeparator;

/**
 The separator inset for this cell. Only left/right insets are valid as top/bottom insets will be
 ignored. If this property is not changed, the @c separatorInset property of the collection view
 styler will be used instead. Defaults to UIEdgeInsetsZero.
 */
@property(nonatomic) UIEdgeInsets separatorInset;

/**
 A boolean value indicating whether a cell permits interactions with subviews of its content while
 the cell is in editing mode. If NO, then tapping anywhere in the cell will select it instead of
 permitting the tapped subview to receive the touch. Defaults to NO.
 */
@property(nonatomic) BOOL allowsCellInteractionsWhileEditing;

/**
 A boolean value indicating whether the a cell is being edited. Setting is not animated.

 When set, the cell will shows/hide editing controls with/without animation.
 */
@property(nonatomic, getter=isEditing) BOOL editing;

/**
 The color for the editing selector when the cell is selected.

 The default is a red color.
 */
@property(nonatomic, strong, null_resettable) UIColor *editingSelectorColor UI_APPEARANCE_SELECTOR;

/**
 Set the editing state with optional animations.

 When set, the cell will shows/hide editing controls with/without animation.

 @param editing YES if editing; otherwise, NO.
 @param animated YES the transition will be animated; otherwise, NO.
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

/** View containing the ink effect. */
@property(nonatomic, strong, nullable) GTCInkView *inkView;

@end
