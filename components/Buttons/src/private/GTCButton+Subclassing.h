//
//  GTCButton+Subclassing.h
//  Pods
//
//  Created by liuxc on 2018/8/20.
//


#import "GTCButton.h"

@class GTCInkView;

@interface GTCButton (Subclassing)

    /** Access to the ink view layer. Mainly used for subclasses to override ink properties. */
    @property(nonatomic, readonly, strong, nonnull) GTCInkView *inkView;

    /** Whether the background color should be opaque. */
- (BOOL)shouldHaveOpaqueBackground;

    /** Updates the background color based on the button's current configuration. */
- (void)updateBackgroundColor;

    /**
     Should the button raise when touched?

     Default is YES.
     */
    @property(nonatomic) BOOL shouldRaiseOnTouch;

    /** The bounding path of the button. The shadow will follow that path. */
- (nonnull UIBezierPath *)boundingPath;

    /**
     Previously used to set the corner radius of the button. This has been deprecated and the layer's
     |cornerRadius| property should be set directly.
     */
- (CGFloat)cornerRadius  __deprecated_msg("Set layer.cornerRadius explicitly");

    /** The default content edge insets of the button. They are set at initialization time. */
- (UIEdgeInsets)defaultContentEdgeInsets;

    @end
