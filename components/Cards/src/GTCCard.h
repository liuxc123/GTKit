//
//  GTCCard.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>
#import "GTInk.h"
#import "GTShadowLayer.h"

@protocol GTCShapeGenerating;

@interface GTCCard : UIControl

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

/**
 Sets the shadow elevation for an UIControlState state

 @param shadowElevation The shadow elevation
 @param state UIControlState the card state
 */
- (void)setShadowElevation:(GTCShadowElevation)shadowElevation forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the shadow elevation for an UIControlState state

 If no elevation has been set for a state, the value for UIControlStateNormal will be returned.
 Default value for UIControlStateNormal is 1
 Default value for UIControlStateHighlighted is 8

 @param state UIControlState the card state
 @return The shadow elevation for the requested state.
 */
- (GTCShadowElevation)shadowElevationForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the border width for an UIControlState state

 @param borderWidth The border width
 @param state UIControlState the card state
 */
- (void)setBorderWidth:(CGFloat)borderWidth forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the border width for an UIControlState state

 If no border width has been set for a state, the value for UIControlStateNormal will be returned.
 Default value for UIControlStateNormal is 0

 @param state UIControlState the card state
 @return The border width for the requested state.
 */
- (CGFloat)borderWidthForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the border color for an UIControlState state

 @param borderColor The border color
 @param state UIControlState the card state
 */
- (void)setBorderColor:(nullable UIColor *)borderColor forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the border color for an UIControlState state

 If no border color has been set for a state, it will check the value of UIControlStateNormal.
 If that value also isn't set, then nil will be returned.

 @param state UIControlState the card state
 @return The border color for the requested state.
 */
- (nullable UIColor *)borderColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the shadow color for an UIControlState state

 @param shadowColor The shadow color
 @param state UIControlState the card state
 */
- (void)setShadowColor:(nullable UIColor *)shadowColor forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;

/**
 Returns the shadow color for an UIControlState state

 If no color has been set for a state, the value for GTCCardViewStateNormal will be returned.
 Default value for UIControlStateNormal is blackColor

 @param state UIControlState the card state
 @return The shadow color for the requested state.
 */
- (nullable UIColor *)shadowColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/*
 The shape generator used to define the card's shape.
 When set, layer properties such as cornerRadius and other layer properties are nullified/zeroed.
 If a layer property is explicitly set after the shapeGenerator has been set, it will lead to
 unexpected behavior.

 When the shapeGenerator is nil, GTCCard will use the default underlying layer with
 its default settings.

 Default value for shapeGenerator is nil.
 */
@property(nullable, nonatomic, strong) id<GTCShapeGenerating> shapeGenerator;


@end
