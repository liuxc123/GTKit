//
//  GTCCardCollectionCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>
#import "GTInk.h"
#import "GTShadowLayer.h"

@protocol GTCShapeGenerating;

/**
 Through the lifecycle of the cell, the cell can go through one of the 3 states,
 normal, highlighted, and selected. The cell starts in its default state, normal.
 When `selectable` is set to NO, each touch on the cell turns it to the highlighted state, and when
 the touch is released, it is returned to the normal state. When `selectable` is set to YES. Each
 touch on the cell that isn't cancelled turns the cell to its selected state. Another touch on the
 cell changes it back to normal.
 */
typedef NS_ENUM(NSInteger, GTCCardCellState) {
    /** The visual state when the cell is in its normal state. */
    GTCCardCellStateNormal = 0,

    /** The visual state when the cell is in its highlighted state. */
    GTCCardCellStateHighlighted,

    /** The visual state when the cell has been selected. */
    GTCCardCellStateSelected
};

/**
 The horizontal alignment of the image when in selectable mode (`selectable` is set to YES).
 */
typedef NS_ENUM(NSInteger, GTCCardCellHorizontalImageAlignment) {
    /** The alignment of the image is to the right of the card. */
    GTCCardCellHorizontalImageAlignmentRight = 0,

    /** The alignment of the image is to the center of the card. */
    GTCCardCellHorizontalImageAlignmentCenter,

    /** The alignment of the image is to the left of the card. */
    GTCCardCellHorizontalImageAlignmentLeft,

    // TODO: Add AlignmentLeading and AlignmentTrailing. See Github issue #3045
};

/**
 The vertical alignment of the image when in selectable mode (`selectable` is set to YES).
 */
typedef NS_ENUM(NSInteger, GTCCardCellVerticalImageAlignment) {
    /** The alignment of the image is to the top of the card. */
    GTCCardCellVerticalImageAlignmentTop = 0,

    /** The alignment of the image is to the center of the card. */
    GTCCardCellVerticalImageAlignmentCenter,

    /** The alignment of the image is to the bottom of the card. */
    GTCCardCellVerticalImageAlignmentBottom,
};

@interface GTCCardCollectionCell : UICollectionViewCell

/**
 When selectable is set to YES, a tap on a cell will trigger a visual change between selected
 and unselected. When it is set to NO, a tap will trigger a normal tap (rather than trigger
 different visual selection states on the card).
 Default is set to NO.
 */
@property(nonatomic, assign, getter=isSelectable) BOOL selectable;

/**
 The corner radius for the card
 Default is set to 4.
 */
@property(nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/**
 The inkView for the card that is initiated on tap
 */
@property(nonatomic, readonly, strong, nonnull) GTCInkView *inkView;

/**
 This property defines if a card as a whole should be interactable or not.
 What this means is that when isInteractable is set to NO, there will be no ink ripple and
 no change in shadow elevation when tapped or selected. Also the card container itself will not be
 tappable, but any of its subviews will still be tappable.

 Default is set to YES.

 Important: Our specification for cards explicitly define a card as being an interactable component.
 Therefore, this property should be set to NO *only if* there are other interactable items within
 the card's content, such as buttons or other tappable controls.
 */
@property (nonatomic, getter=isInteractable) IBInspectable BOOL interactable;

/*
 The shape generator used to define the card cell's shape.
 When set, layer properties such as cornerRadius and other layer properties are nullified/zeroed.
 If a layer property is explicitly set after the shapeGenerator has been set, it will lead to
 unexpected behavior.

 When the shapeGenerator is nil, GTCCardCollectionCell will use the default underlying layer with
 its default settings.

 Default value for shapeGenerator is nil.
 */
@property(nullable, nonatomic, strong) id<GTCShapeGenerating> shapeGenerator;

/**
 Sets the shadow elevation for an GTCCardViewState state

 @param shadowElevation The shadow elevation
 @param state GTCCardCellState the card state
 */
- (void)setShadowElevation:(GTCShadowElevation)shadowElevation forState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the shadow elevation for an GTCCardViewState state

 If no elevation has been set for a state, the value for GTCCardCellStateNormal will be returned.
 Default value for GTCCardCellStateNormal is 1
 Default value for GTCCardCellStateHighlighted is 8
 Default value for GTCCardCellStateSelected is 8

 @param state GTCCardCellStateNormal the card state
 @return The shadow elevation for the requested state.
 */
- (GTCShadowElevation)shadowElevationForState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the border width for an GTCCardViewState state

 @param borderWidth The border width
 @param state GTCCardCellState the card state
 */
- (void)setBorderWidth:(CGFloat)borderWidth forState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the border width for an GTCCardCellState state

 If no border width has been set for a state, the value for GTCCardCellStateNormal will be returned.
 Default value for GTCCardCellStateNormal is 0

 @param state GTCCardCellState the card state
 @return The border width for the requested state.
 */
- (CGFloat)borderWidthForState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the border color for an GTCCardCellStateNormal state

 @param borderColor The border color
 @param state GTCCardCellState the card state
 */
- (void)setBorderColor:(nullable UIColor *)borderColor forState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the border color for an GTCCardCellStateNormal state

 If no border color has been set for a state, it will check the value of UIControlStateNormal.
 If that value also isn't set, then nil will be returned.

 @param state GTCCardCellState the card state
 @return The border color for the requested state.
 */
- (nullable UIColor *)borderColorForState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the shadow color for an GTCCardCellStateNormal state

 @param shadowColor The shadow color
 @param state GTCCardCellState the card state
 */
- (void)setShadowColor:(nullable UIColor *)shadowColor forState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the shadow color for an GTCCardCellStateNormal state

 If no color has been set for a state, the value for GTCCardViewStateNormal will be returned.
 Default value for GTCCardCellStateNormal is blackColor

 @param state GTCCardCellState the card state
 @return The shadow color for the requested state.
 */
- (nullable UIColor *)shadowColorForState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Returns the image for an GTCCardCellStateNormal state.

 @note The image is only displayed when `selectable` is YES.
 If no image has been set for a state, it will check the value of UIControlStateNormal.
 If that value also isn't set, then nil will be returned.
 Default value for GTCCardCellStateSelected is ic_check_circle

 @param state GTCCardCellState the card state
 @return The image for the requested state.
 */
- (nullable UIImage *)imageForState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the image for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 @param image The image
 @param state GTCCardCellState the card state
 */
- (void)setImage:(nullable UIImage *)image forState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the horizontal image alignment for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 If no alignment has been set for a state, it will check the value of UIControlStateNormal.
 If that value also isn't set, then GTCCardCellImageHorizontalAlignmentRight will be returned.

 @param state GTCCardCellState the card state
 @return The horizontal alignment for the requested state.
 */
- (GTCCardCellHorizontalImageAlignment)horizontalImageAlignmentForState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Sets the image alignment for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 @param horizontalImageAlignment The image alignment
 @param state GTCCardCellState the card state
 */
- (void)setHorizontalImageAlignment:(GTCCardCellHorizontalImageAlignment)horizontalImageAlignment
                           forState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Returns the vertical image alignment for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 If no alignment has been set for a state, it will check the value of UIControlStateNormal.
 If that value also isn't set, then GTCCardCellImageVerticalAlignmentTop will be returned.

 @param state GTCCardCellState the card state
 @return The vertical alignment for the requested state.
 */
- (GTCCardCellVerticalImageAlignment)verticalImageAlignmentForState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 Sets the image alignment for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 @param verticalImageAlignment The image alignment
 @param state GTCCardCellState the card state
 */
- (void)setVerticalImageAlignment:(GTCCardCellVerticalImageAlignment)verticalImageAlignment
                         forState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Returns the image tint color for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 If no tint color has been set for a state, it will check the value of UIControlStateNormal.
 If that value also isn't set, then nil will be returned.

 @param state GTCCardCellState the card state
 @return The image tint color for the requested state.
 */
- (nullable UIColor *)imageTintColorForState:(GTCCardCellState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the image tint color for an GTCCardCellStateNormal state

 @note The image is only displayed when `selectable` is YES.
 @param imageTintColor The image tint color
 @param state GTCCardCellState the card state
 */
- (void)setImageTintColor:(nullable UIColor *)imageTintColor forState:(GTCCardCellState)state
UI_APPEARANCE_SELECTOR;

/**
 The state of the card cell.
 Default is GTCCardCellStateNormal.
 */
@property(nonatomic, readonly) GTCCardCellState state;

@end
