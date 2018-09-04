//
//  GTCTextInputControllerFilled.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import "GTCTextInputControllerFilled.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTCMultilineTextField.h"
#import "GTCTextInput.h"
#import "GTCTextInputBorderView.h"
#import "GTCTextInputController.h"
#import "GTCTextInputControllerBase.h"
#import "GTCTextInputControllerFloatingPlaceholder.h"
#import "private/GTCTextInputArt.h"
#import "private/GTCTextInputControllerBase+Subclassing.h"

#import "GTMath.h"

/**
 Note: Right now this is a subclass of GTCTextInputControllerBase since they share a vast
 majority of code. If the designs diverge further, this would make a good candidate for its own
 class.
 */

#pragma mark - Constants

static const CGFloat GTCTextInputControllerFilledClearButtonPaddingAddition = -2.f;
static const CGFloat GTCTextInputControllerFilledDefaultUnderlineActiveHeight = 2;
static const CGFloat GTCTextInputControllerFilledDefaultUnderlineNormalHeight = 1;
static const CGFloat GTCTextInputControllerFilledFullPadding = 16.f;

// The guidelines have 8 points of padding but since the fonts on iOS are slightly smaller, we need
// to add points to keep the versions at the same height.
static const CGFloat GTCTextInputControllerFilledHalfPadding = 8.f;
static const CGFloat GTCTextInputControllerFilledHalfPaddingAddition = 1.f;
static const CGFloat GTCTextInputControllerFilledNormalPlaceholderPadding = 20.f;
static const CGFloat GTCTextInputControllerFilledThreeQuartersPadding = 12.f;

static inline UIColor *GTCTextInputControllerFilledDefaultBorderFillColorDefault() {
    return [UIColor colorWithWhite:0 alpha:.06f];
}

#pragma mark - Class Properties

static UIColor *_borderFillColorDefault;

static UIRectCorner _roundedCornersDefault = UIRectCornerAllCorners;

static CGFloat _underlineHeightActiveDefault =
GTCTextInputControllerFilledDefaultUnderlineActiveHeight;
static CGFloat _underlineHeightNormalDefault =
GTCTextInputControllerFilledDefaultUnderlineNormalHeight;

@interface GTCTextInputControllerFilled ()

@property(nonatomic, strong) NSLayoutConstraint *clearButtonBottom;
@property(nonatomic, strong) NSLayoutConstraint *placeholderTop;
@property(nonatomic, strong) NSLayoutConstraint *underlineBottom;

@end

@implementation GTCTextInputControllerFilled

#pragma mark - Properties Implementations

+ (UIColor *)borderFillColorDefault {
    if (!_borderFillColorDefault) {
        _borderFillColorDefault = GTCTextInputControllerFilledDefaultBorderFillColorDefault();
    }
    return _borderFillColorDefault;
}

+ (UIRectCorner)roundedCornersDefault {
    return _roundedCornersDefault;
}

+ (void)setRoundedCornersDefault:(UIRectCorner)roundedCornersDefault {
    _roundedCornersDefault = roundedCornersDefault;
}

+ (CGFloat)underlineHeightActiveDefault {
    return _underlineHeightActiveDefault;
}

+ (void)setUnderlineHeightActiveDefault:(CGFloat)underlineHeightActiveDefault {
    _underlineHeightActiveDefault = underlineHeightActiveDefault;
}

+ (CGFloat)underlineHeightNormalDefault {
    return _underlineHeightNormalDefault;
}

+ (void)setUnderlineHeightNormalDefault:(CGFloat)underlineHeightNormalDefault {
    _underlineHeightNormalDefault = underlineHeightNormalDefault;
}

#pragma mark - GTCTextInputPositioningDelegate

- (CGRect)leadingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect leadingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? -1 * GTCTextInputControllerFilledFullPadding
    : GTCTextInputControllerFilledFullPadding;

    leadingViewRect = CGRectOffset(leadingViewRect, xOffset, 0.f);

    leadingViewRect.origin.y = CGRectGetHeight(self.textInput.borderPath.bounds) / 2.f -
    CGRectGetHeight(leadingViewRect) / 2.f;

    return leadingViewRect;
}

- (CGFloat)leadingViewTrailingPaddingConstant {
    return GTCTextInputControllerFilledFullPadding;
}

- (CGRect)trailingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect trailingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? GTCTextInputControllerFilledThreeQuartersPadding
    : -1 * GTCTextInputControllerFilledThreeQuartersPadding;

    trailingViewRect = CGRectOffset(trailingViewRect, xOffset, 0.f);

    trailingViewRect.origin.y = CGRectGetHeight(self.textInput.borderPath.bounds) / 2.f -
    CGRectGetHeight(trailingViewRect) / 2.f;

    return trailingViewRect;
}

- (CGFloat)trailingViewTrailingPaddingConstant {
    return GTCTextInputControllerFilledThreeQuartersPadding;
}

// clang-format off
/**
 textInsets: is the source of truth for vertical layout. It's used to figure out the proper
 height and also where to place the placeholder / text field.

 NOTE: It's applied before the textRect is flipped for RTL. So all calculations are done here à la
 LTR.

 The vertical layout is, at most complex (floating), this form:
 GTCTextInputControllerFilledHalfPadding +                            // Small padding
 GTCTextInputControllerFilledHalfPaddingAddition                      // Additional point (iOS specific)
 GTCRint(self.textInput.placeholderLabel.font.lineHeight * scale)     // Placeholder when up
 GTCTextInputControllerFilledHalfPadding +                            // Small padding
 GTCTextInputControllerFilledHalfPaddingAddition                      // Additional point (iOS specific)
 GTCCeil(MAX(self.textInput.font.lineHeight,                        // Text field or placeholder line height
 self.textInput.placeholderLabel.font.lineHeight))
 GTCTextInputControllerFilledHalfPadding +                            // Small padding
 GTCTextInputControllerFilledHalfPaddingAddition                      // Additional point (iOS specific)
 --Underline--                                                        // Underline (height not counted)
 underlineLabelsOffset                                                // Depends on text insets mode. See the super class.
 */
// clang-format on
- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    UIEdgeInsets textInsets = [super textInsets:defaultInsets];
    if (self.isFloatingEnabled) {
        textInsets.top =
        GTCTextInputControllerFilledHalfPadding + GTCTextInputControllerFilledHalfPaddingAddition +
        GTCRint(self.textInput.placeholderLabel.font.lineHeight *
                (CGFloat)self.floatingPlaceholderScale.floatValue) +
        GTCTextInputControllerFilledHalfPadding + GTCTextInputControllerFilledHalfPaddingAddition;
    } else {
        textInsets.top = GTCTextInputControllerFilledNormalPlaceholderPadding;
    }

    textInsets.bottom = [self beneathInputPadding] + [self underlineOffset];

    textInsets.left = GTCTextInputControllerFilledFullPadding;
    textInsets.right = GTCTextInputControllerFilledHalfPadding;

    return textInsets;
}

- (void)updateLayout {
    [super updateLayout];

    if (!self.textInput) {
        return;
    }

    CGFloat clearButtonConstant =
    -1 * ([self beneathInputPadding] - GTCTextInputClearButtonImageBuiltInPadding +
          GTCTextInputControllerFilledClearButtonPaddingAddition);
    if (!self.clearButtonBottom) {
        self.clearButtonBottom = [NSLayoutConstraint constraintWithItem:self.textInput.clearButton
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.textInput.underline
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:clearButtonConstant];
        self.clearButtonBottom.active = YES;
    }
    self.clearButtonBottom.constant = clearButtonConstant;
}

#pragma mark - Layout

- (void)updatePlaceholder {
    [super updatePlaceholder];

    if (!self.placeholderTop) {
        self.placeholderTop = [NSLayoutConstraint
                               constraintWithItem:self.textInput.placeholderLabel
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.textInput
                               attribute:NSLayoutAttributeTop
                               multiplier:1
                               constant:GTCTextInputControllerFilledNormalPlaceholderPadding];
        self.placeholderTop.priority = UILayoutPriorityDefaultHigh;
        self.placeholderTop.active = YES;
    }

    UIEdgeInsets textInsets = [self textInsets:UIEdgeInsetsZero];
    CGFloat underlineBottomConstant =
    textInsets.top + [self estimatedTextHeight] + [self beneathInputPadding];
    // When floating placeholders are turned off, the underline will drift up unless this is set. Even
    // tho it is redundant when floating is on, we just keep it on always for simplicity.
    // Note: This is an issue only on single-line text fields.
    if (!self.underlineBottom) {
        if ([self.textInput isKindOfClass:[GTCMultilineTextField class]]) {
            self.underlineBottom =
            [NSLayoutConstraint constraintWithItem:self.textInput.underline
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:((GTCMultilineTextField *)self.textInput).textView
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                          constant:[self beneathInputPadding]];
            self.underlineBottom.active = YES;

        } else {
            self.underlineBottom = [NSLayoutConstraint constraintWithItem:self.textInput.underline
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.textInput
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:underlineBottomConstant];
            self.underlineBottom.active = YES;
        }
    }
    if ([self.textInput isKindOfClass:[GTCMultilineTextField class]]) {
        self.underlineBottom.constant = [self beneathInputPadding];
    } else {
        self.underlineBottom.constant = underlineBottomConstant;
    }
}

// The measurement from bottom to underline bottom. Only used in non-floating case.
- (CGFloat)underlineOffset {
    // The amount of space underneath the underline may depend on whether there is content in the
    // underline labels.

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat leadingOffset =
    GTCCeil(self.textInput.leadingUnderlineLabel.font.lineHeight * scale) / scale;
    CGFloat trailingOffset =
    GTCCeil(self.textInput.trailingUnderlineLabel.font.lineHeight * scale) / scale;

    CGFloat underlineOffset = 0;
    switch (self.textInput.textInsetsMode) {
        case GTCTextInputTextInsetsModeAlways:
            underlineOffset +=
            MAX(leadingOffset, trailingOffset) + GTCTextInputControllerFilledHalfPadding;
            break;
        case GTCTextInputTextInsetsModeIfContent: {
            // contentConditionalOffset will have the estimated text height for the largest underline
            // label that also has text.
            CGFloat contentConditionalOffset = 0;
            if (self.textInput.leadingUnderlineLabel.text.length) {
                contentConditionalOffset = leadingOffset;
            }
            if (self.textInput.trailingUnderlineLabel.text.length) {
                contentConditionalOffset = MAX(contentConditionalOffset, trailingOffset);
            }

            if (!GTCCGFloatEqual(contentConditionalOffset, 0)) {
                underlineOffset += contentConditionalOffset + GTCTextInputControllerFilledHalfPadding;
            }
        } break;
        case GTCTextInputTextInsetsModeNever:
            break;
    }
    return underlineOffset;
}

- (CGFloat)estimatedTextHeight {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat estimatedTextHeight = GTCCeil(self.textInput.font.lineHeight * scale) / scale;

    return estimatedTextHeight;
}

- (UIOffset)floatingPlaceholderOffset {
    UIOffset offset = [super floatingPlaceholderOffset];

    if ([self.textInput conformsToProtocol:@protocol(GTCLeadingViewTextInput)]) {
        UIView<GTCLeadingViewTextInput> *input = (UIView<GTCLeadingViewTextInput> *)self.textInput;
        if (input.leadingView.superview) {
            offset.horizontal -=
            CGRectGetWidth(input.leadingView.frame) + [self leadingViewTrailingPaddingConstant];
        }
    }
    return offset;
}

// The space ABOVE the underline but under the text input area.
- (CGFloat)beneathInputPadding {
    if (self.isFloatingEnabled) {
        return GTCTextInputControllerFilledHalfPadding +
        GTCTextInputControllerFilledHalfPaddingAddition;
    } else {
        return GTCTextInputControllerFilledNormalPlaceholderPadding;
    }
}

@end
