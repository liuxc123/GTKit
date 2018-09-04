//
//  GTCTextInputControllerOutlinedTextArea.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerOutlinedTextArea.h"

#import "GTCTextInput.h"
#import "GTCTextInputBorderView.h"
#import "GTCTextInputController.h"
#import "GTCTextInputControllerBase.h"
#import "GTCTextInputControllerFloatingPlaceholder.h"
#import "GTCTextInputUnderlineView.h"
#import "private/GTCTextInputControllerBase+Subclassing.h"

#import "GTMath.h"

/**
 Note: Right now this is a subclass of GTCTextInputControllerBase since they share a vast
 majority of code. If the designs diverge further, this would make a good candidate for its own
 class.
 */

#pragma mark - Constants

static const CGFloat GTCTextInputTextFieldOutlinedTextAreaFullPadding = 16.f;
static const CGFloat GTCTextInputTextFieldOutlinedTextAreaHalfPadding = 8.f;

// The guidelines have 8 points of padding but since the fonts on iOS are slightly smaller, we need
// to add points to keep the versions at the same height.
static const CGFloat GTCTextInputTextFieldOutlinedTextAreaPaddingAdjustment = 1.f;

#pragma mark - Class Properties

static UIRectCorner _roundedCornersDefault = UIRectCornerAllCorners;

@interface GTCTextInputControllerOutlinedTextArea ()

@property(nonatomic, strong) NSLayoutConstraint *placeholderTop;

@end

@implementation GTCTextInputControllerOutlinedTextArea

- (instancetype)initWithTextInput:(UIView<GTCTextInput> *)input {
    NSAssert([input conformsToProtocol:@protocol(GTCMultilineTextInput)],
             @"This design is meant for multi-line text fields only.");
    self = [super initWithTextInput:input];
    if (self) {
    }
    return self;
}

#pragma mark - Properties Implementations

- (BOOL)isFloatingEnabled {
    return YES;
}

- (void)setFloatingEnabled:(__unused BOOL)floatingEnabled {
    // Unused. Floating is always enabled.
}

+ (UIRectCorner)roundedCornersDefault {
    return _roundedCornersDefault;
}

+ (void)setRoundedCornersDefault:(UIRectCorner)roundedCornersDefault {
    _roundedCornersDefault = roundedCornersDefault;
}

#pragma mark - GTCTextInputPositioningDelegate

// clang-format off
/**
 textInsets: is the source of truth for vertical layout. It's used to figure out the proper
 height and also where to place the placeholder / text field.

 NOTE: It's applied before the textRect is flipped for RTL. So all calculations are done here à la
 LTR.

 The vertical layout is, at most complex, this form:

 GTCTextInputTextFieldOutlinedTextAreaHalfPadding +                   // Small padding
 GTCTextInputTextFieldOutlinedTextAreaPaddingAdjustment               // Additional point (iOS specific)
 placeholderEstimatedHeight                                           // Height of placeholder
 GTCTextInputTextFieldOutlinedTextAreaHalfPadding +                   // Small padding
 GTCTextInputTextFieldOutlinedTextAreaPaddingAdjustment               // Additional point (iOS specific)
 GTCCeil(MAX(self.textInput.font.lineHeight,                          // Text field or placeholder
 self.textInput.placeholderLabel.font.lineHeight))
 underlineOffset                                                      // Small Padding +
 // underlineLabelsOffset From super class.
 */
// clang-format on
- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    UIEdgeInsets textInsets = [super textInsets:defaultInsets];
    textInsets.top = GTCTextInputTextFieldOutlinedTextAreaHalfPadding +
    GTCTextInputTextFieldOutlinedTextAreaPaddingAdjustment +
    GTCRint(self.textInput.placeholderLabel.font.lineHeight *
            (CGFloat)self.floatingPlaceholderScale.floatValue) +
    GTCTextInputTextFieldOutlinedTextAreaHalfPadding +
    GTCTextInputTextFieldOutlinedTextAreaPaddingAdjustment;

    // .bottom = underlineOffset + the half padding above the line but below the text field and any
    // space needed for the labels and / or line.
    // Legacy has an additional half padding here but this version does not.
    CGFloat underlineOffset = [self underlineOffset];

    textInsets.bottom = underlineOffset;
    textInsets.left = GTCTextInputTextFieldOutlinedTextAreaFullPadding;
    textInsets.right = GTCTextInputTextFieldOutlinedTextAreaFullPadding;

    return textInsets;
}

#pragma mark - Layout

- (void)updateBorder {
    [super updateBorder];
    UIColor *borderColor = self.textInput.isEditing ? self.activeColor : self.normalColor;
    self.textInput.borderView.borderStrokeColor =
    (self.isDisplayingCharacterCountError || self.isDisplayingErrorText) ? self.errorColor
    : borderColor;
    self.textInput.borderView.borderPath.lineWidth = self.textInput.isEditing ? 2 : 1;
}

- (void)updateLayout {
    [super updateLayout];

    if (!self.textInput) {
        return;
    }

    NSAssert([self.textInput conformsToProtocol:@protocol(GTCMultilineTextInput)],
             @"This design is meant for multi-line text fields only.");
    if (![self.textInput conformsToProtocol:@protocol(GTCMultilineTextInput)]) {
        return;
    }

    ((UIView<GTCMultilineTextInput> *)self.textInput).expandsOnOverflow = NO;
    ((UIView<GTCMultilineTextInput> *)self.textInput).minimumLines = 5;

    self.textInput.underline.alpha = 0;

    if (!self.placeholderTop) {
        self.placeholderTop =
        [NSLayoutConstraint constraintWithItem:self.textInput.placeholderLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.textInput
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:GTCTextInputTextFieldOutlinedTextAreaFullPadding];
        self.placeholderTop.priority = UILayoutPriorityDefaultHigh;
        self.placeholderTop.active = YES;
    }
}

// The measurement from bottom to underline center Y.
- (CGFloat)underlineOffset {
    // The amount of space underneath the underline depends on whether there is content in the
    // underline labels.
    CGFloat underlineLabelsOffset = 0;
    CGFloat scale = UIScreen.mainScreen.scale;

    if (self.textInput.leadingUnderlineLabel.text.length) {
        underlineLabelsOffset =
        GTCCeil(self.textInput.leadingUnderlineLabel.font.lineHeight * scale) / scale;
    }
    if (self.textInput.trailingUnderlineLabel.text.length || self.characterCountMax) {
        underlineLabelsOffset =
        MAX(underlineLabelsOffset,
            GTCCeil(self.textInput.trailingUnderlineLabel.font.lineHeight * scale) / scale);
    }

    CGFloat underlineOffset = underlineLabelsOffset;
    underlineOffset += GTCTextInputTextFieldOutlinedTextAreaHalfPadding;

    if (!GTCCGFloatEqual(underlineLabelsOffset, 0)) {
        underlineOffset += GTCTextInputTextFieldOutlinedTextAreaHalfPadding;
    }

    return underlineOffset;
}

@end
