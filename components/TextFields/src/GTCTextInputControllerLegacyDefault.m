//
//  GTCTextInputControllerLegacyDefault.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerLegacyDefault.h"

#import "GTCMultilineTextField.h"
#import "GTCTextInputUnderlineView.h"
#import "private/GTCTextInputArt.h"

#import "GTTypography.h"

#pragma mark - Constants

static const CGFloat GTCTextInputControllerLegacyDefaultClearButtonImageSquareWidthHeight = 24.f;
static const CGFloat GTCTextInputControllerLegacyDefaultUnderlineActiveHeight = 2.f;
static const CGFloat GTCTextInputControllerLegacyDefaultUnderlineNormalHeight = 1.f;
static const CGFloat GTCTextInputControllerLegacyDefaultVerticalHalfPadding = 8.f;
static const CGFloat GTCTextInputControllerLegacyDefaultVerticalPadding = 16.f;

static inline UIBezierPath *GTCTextInputControllerLegacyDefaultEmptyPath() {
    return [UIBezierPath bezierPath];
}

#pragma mark - Class Properties

static CGFloat _underlineHeightActiveLegacyDefault =
GTCTextInputControllerLegacyDefaultUnderlineActiveHeight;
static CGFloat _underlineHeightNormalLegacyDefault =
GTCTextInputControllerLegacyDefaultUnderlineNormalHeight;

@interface GTCTextInputControllerBase ()
- (void)setupInput;
@end

@implementation GTCTextInputControllerLegacyDefault

- (void)setupInput {
    [super setupInput];
    if (!self.textInput) {
        return;
    }
    [self setupClearButton];
}

- (GTCTextInputTextInsetsMode)textInsetModeDefault {
    return GTCTextInputTextInsetsModeIfContent;
}

- (void)setupClearButton {
    UIImage *image = [self
                      drawnClearButtonImage:[UIColor colorWithWhite:0 alpha:[GTCTypography captionFontOpacity]]];
    [self.textInput.clearButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Border Customization

- (void)updateBorder {
    self.textInput.borderPath = GTCTextInputControllerLegacyDefaultEmptyPath();
}

#pragma mark - Clear Button Customization

- (UIImage *)drawnClearButtonImage:(UIColor *)color {
    CGSize clearButtonSize =
    CGSizeMake(GTCTextInputControllerLegacyDefaultClearButtonImageSquareWidthHeight,
               GTCTextInputControllerLegacyDefaultClearButtonImageSquareWidthHeight);

    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect bounds = CGRectMake(0, 0, clearButtonSize.width * scale, clearButtonSize.height * scale);
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
    [color setFill];

    [GTCPathForClearButtonLegacyImageFrame(bounds) fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

#pragma mark - Properties Implementation

+ (CGFloat)underlineHeightActiveDefault {
    return _underlineHeightActiveLegacyDefault;
}

+ (void)setUnderlineHeightActiveDefault:(CGFloat)underlineHeightActiveDefault {
    _underlineHeightActiveLegacyDefault = underlineHeightActiveDefault;
}

+ (CGFloat)underlineHeightNormalDefault {
    return _underlineHeightNormalLegacyDefault;
}

+ (void)setUnderlineHeightNormalDefault:(CGFloat)underlineHeightNormalDefault {
    _underlineHeightNormalLegacyDefault = underlineHeightNormalDefault;
}

- (UIRectCorner)roundedCorners {
    return 0;
}

- (void)setRoundedCorners:(__unused UIRectCorner)roundedCorners {
    // Not implemented. Corners are not rounded.
}

+ (UIRectCorner)roundedCornersDefault {
    return 0;
}

+ (void)setRoundedCornersDefault:(__unused UIRectCorner)roundedCornersDefault {
    // Not implemented. Corners are not rounded.
}

- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    // NOTE: UITextFields have a centerY based layout. But you can change EITHER the height or the Y.
    // Not both. Don't know why. So, we have to leave the text rect as big as the bounds and move it
    // to a Y that works. In other words, no bottom inset will make a difference here for UITextFields
    UIEdgeInsets textInsets = defaultInsets;

    if (!self.isFloatingEnabled) {
        return defaultInsets;
    }

    textInsets.top = GTCTextInputControllerLegacyDefaultVerticalPadding +
    GTCRint(self.textInput.placeholderLabel.font.lineHeight *
            (CGFloat)self.floatingPlaceholderScale.floatValue) +
    GTCTextInputControllerLegacyDefaultVerticalHalfPadding;
    return textInsets;
}

- (UIOffset)floatingPlaceholderOffset {
    CGFloat vertical = GTCTextInputControllerLegacyDefaultVerticalPadding;

    // Offsets needed due to transform working on normal (0.5,0.5) anchor point.
    // Why no anchor point of (0,0)? Because autolayout doesn't play well with anchor points.
    vertical -= self.textInput.placeholderLabel.font.lineHeight *
    (1 - (CGFloat)self.floatingPlaceholderScale.floatValue) * .5f;

    // Remember, the insets are always in LTR. It's automatically flipped when used in RTL.
    // See GTCTextInputController.h.
    UIEdgeInsets insets = self.textInput.textInsets;

    CGFloat placeholderMaxWidth =
    CGRectGetWidth(self.textInput.bounds) / self.floatingPlaceholderScale.floatValue -
    insets.left - insets.right;

    CGFloat placeholderWidth =
    [self.textInput.placeholderLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]
    .width;
    if (placeholderWidth > placeholderMaxWidth) {
        placeholderWidth = placeholderMaxWidth;
    }

    CGFloat horizontal =
    placeholderWidth * (1 - (CGFloat)self.floatingPlaceholderScale.floatValue) * .5f;

    return UIOffsetMake(horizontal, vertical);
}

@end
