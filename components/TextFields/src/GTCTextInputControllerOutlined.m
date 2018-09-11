//
//  GTCTextInputControllerOutlined.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerOutlined.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTCTextInput.h"
#import "GTCTextInputBorderView.h"
#import "GTCTextInputController.h"
#import "GTCTextInputControllerBase.h"
#import "GTCTextInputControllerFloatingPlaceholder.h"
#import "GTCTextInputUnderlineView.h"
#import "private/GTCTextInputControllerBase+Subclassing.h"

#import "GTMath.h"

#pragma mark - Properties

static BOOL _isFloatingEnabled = NO;

#pragma mark - Class Properties

static const CGFloat GTCTextInputOutlinedTextFieldFloatingPlaceholderPadding = 8.f;
static const CGFloat GTCTextInputOutlinedTextFieldFullPadding = 16.f;
static const CGFloat GTCTextInputOutlinedTextFieldNormalPlaceholderPadding = 20.f;
static const CGFloat GTCTextInputOutlinedTextFieldThreeQuartersPadding = 12.f;

static UIRectCorner _roundedCornersDefault = UIRectCornerAllCorners;

@interface GTCTextInputControllerOutlined ()

@property(nonatomic, strong) NSLayoutConstraint *placeholderCenterY;
@property(nonatomic, strong) NSLayoutConstraint *placeholderLeading;

@end

@implementation GTCTextInputControllerOutlined

- (instancetype)initWithTextInput:(UIView<GTCTextInput> *)input {
    NSAssert(![input conformsToProtocol:@protocol(GTCMultilineTextInput)],
             @"This design is meant for single-line text fields only. For a complementary multi-line "
             @"style, see GTCTextInputControllerOutlinedTextArea.");
    self = [super initWithTextInput:input];
    if (self) {
        input.textInsetsMode = GTCTextInputTextInsetsModeAlways;
    }
    return self;
}

#pragma mark - Properties Implementations

- (BOOL)isFloatingEnabled {
    return _isFloatingEnabled;
}

- (void)setFloatingEnabled:(__unused BOOL)floatingEnabled {
    // Unused. Floating is always enabled.
    _isFloatingEnabled = floatingEnabled;
}

- (UIOffset)floatingPlaceholderOffset {
    UIOffset offset = [super floatingPlaceholderOffset];
    CGFloat textVerticalOffset = 0;
    offset.vertical = textVerticalOffset;
    return offset;
}

+ (UIRectCorner)roundedCornersDefault {
    return _roundedCornersDefault;
}

+ (void)setRoundedCornersDefault:(UIRectCorner)roundedCornersDefault {
    _roundedCornersDefault = roundedCornersDefault;
}

#pragma mark - GTCTextInputPositioningDelegate

- (CGRect)leadingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect leadingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? -1 * GTCTextInputOutlinedTextFieldFullPadding
    : GTCTextInputOutlinedTextFieldFullPadding;

    leadingViewRect = CGRectOffset(leadingViewRect, xOffset, 0.f);

    CGRect borderRect = [self borderRect];
    leadingViewRect.origin.y = CGRectGetMinY(borderRect) + CGRectGetHeight(borderRect) / 2.f -
    CGRectGetHeight(leadingViewRect) / 2.f;

    return leadingViewRect;
}

- (CGFloat)leadingViewTrailingPaddingConstant {
    return GTCTextInputOutlinedTextFieldFullPadding;
}

- (CGRect)trailingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect trailingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? GTCTextInputOutlinedTextFieldThreeQuartersPadding
    : -1 * GTCTextInputOutlinedTextFieldThreeQuartersPadding;

    trailingViewRect = CGRectOffset(trailingViewRect, xOffset, 0.f);

    CGRect borderRect = [self borderRect];
    trailingViewRect.origin.y = CGRectGetMinY(borderRect) + CGRectGetHeight(borderRect) / 2.f -
    CGRectGetHeight(trailingViewRect) / 2.f;

    return trailingViewRect;
}

- (CGFloat)trailingViewTrailingPaddingConstant {
    return GTCTextInputOutlinedTextFieldThreeQuartersPadding;
}

// clang-format off
/**
 textInsets: is the source of truth for vertical layout. It's used to figure out the proper
 height and also where to place the placeholder / text field.

 NOTE: It's applied before the textRect is flipped for RTL. So all calculations are done here à la
 LTR.

 This one is a little different because the placeholder crosses the top bordered area when floating.

 The vertical layout is, at most complex, this form:

 placeholderEstimatedHeight                                           // Height of placeholder
 GTCTextInputOutlinedTextFieldFullPadding                             // Padding
 GTCCeil(MAX(self.textInput.font.lineHeight,                          // Text field or placeholder
 self.textInput.placeholderLabel.font.lineHeight))
 GTCTextInputControllerBaseDefaultPadding                             // Padding to bottom of border rect
 underlineLabelsOffset                                                // From super class.
 */
// clang-format on
- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    UIEdgeInsets textInsets = [super textInsets:defaultInsets];
    CGFloat textVerticalOffset = self.textInput.placeholderLabel.font.lineHeight * .5f;

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat placeholderEstimatedHeight =
    GTCCeil(self.textInput.placeholderLabel.font.lineHeight * scale) / scale;
    textInsets.top = [self borderHeight] - GTCTextInputOutlinedTextFieldFullPadding -
    placeholderEstimatedHeight + textVerticalOffset;

    textInsets.left = GTCTextInputOutlinedTextFieldFullPadding;
    textInsets.right = GTCTextInputOutlinedTextFieldFullPadding;

    return textInsets;
}

#pragma mark - GTCTextInputControllerBase overrides

- (void)updateLayout {
    [super updateLayout];

    self.textInput.clipsToBounds = NO;
}

-(void)updateUnderline {
    self.textInput.underline.hidden = NO;
    self.textInput.backgroundColor = [UIColor yellowColor];
}

- (void)updateBorder {
    [super updateBorder];

    UIBezierPath *path;
    if ([self isPlaceholderUp]) {
        CGFloat placeholderWidth =
        [self.textInput.placeholderLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]
        .width * (CGFloat)self.floatingPlaceholderScale.floatValue;

        placeholderWidth += GTCTextInputOutlinedTextFieldFloatingPlaceholderPadding;

        path =
        [self roundedPathFromRect:[self borderRect]
                    withTextSpace:placeholderWidth
                    leadingOffset:GTCTextInputOutlinedTextFieldFullPadding -
         GTCTextInputOutlinedTextFieldFloatingPlaceholderPadding / 2.0f];
    } else {
        CGSize cornerRadius = CGSizeMake(GTCTextInputControllerBaseDefaultBorderRadius,
                                         GTCTextInputControllerBaseDefaultBorderRadius);
        path = [UIBezierPath bezierPathWithRoundedRect:[self borderRect]
                                     byRoundingCorners:self.roundedCorners
                                           cornerRadii:cornerRadius];
    }
    self.textInput.borderPath = path;

    UIColor *borderColor = self.textInput.isEditing ? self.activeColor : self.normalColor;
    if (!self.textInput.isEnabled) {
        borderColor = self.disabledColor;
    }
    self.textInput.borderView.borderStrokeColor =
    (self.isDisplayingCharacterCountError || self.isDisplayingErrorText) ? self.errorColor
    : borderColor;
    self.textInput.borderView.borderPath.lineWidth = self.textInput.isEditing ? 2 : 1;

    [self.textInput.borderView setNeedsLayout];

    [self updatePlaceholder];
}

- (CGRect)borderRect {
    CGRect pathRect = self.textInput.bounds;
    pathRect.origin.y = pathRect.origin.y + self.textInput.placeholderLabel.font.lineHeight * .5f;
    pathRect.size.height = [self borderHeight];
    return pathRect;
}

- (UIBezierPath *)roundedPathFromRect:(CGRect)f
                        withTextSpace:(CGFloat)textSpace
                        leadingOffset:(CGFloat)offset {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat radius = GTCTextInputControllerBaseDefaultBorderRadius;
    CGFloat yOffset = f.origin.y;
    CGFloat xOffset = f.origin.x;

    // Draw the path
    [path moveToPoint:CGPointMake(radius + xOffset, yOffset)];
    if (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
        UIUserInterfaceLayoutDirectionLeftToRight) {
        [path addLineToPoint:CGPointMake(offset + xOffset, yOffset)];
        [path moveToPoint:CGPointMake(textSpace + offset + xOffset, yOffset)];
        [path addLineToPoint:CGPointMake(f.size.width - radius + xOffset, yOffset)];
    } else {
        [path addLineToPoint:CGPointMake(xOffset + (f.size.width - (offset + textSpace)), yOffset)];
        [path moveToPoint:CGPointMake(xOffset + (f.size.width - offset), yOffset)];
        [path addLineToPoint:CGPointMake(xOffset + (f.size.width - radius), yOffset)];
    }

    [path addArcWithCenter:CGPointMake(f.size.width - radius + xOffset, radius + yOffset)
                    radius:radius
                startAngle:- (CGFloat)(M_PI / 2)
                  endAngle:0
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(f.size.width + xOffset, f.size.height - radius + yOffset)];
    [path addArcWithCenter:CGPointMake(f.size.width - radius + xOffset, f.size.height - radius + yOffset)
                    radius:radius
                startAngle:0
                  endAngle:- (CGFloat)((M_PI * 3) / 2)
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(radius + xOffset, f.size.height + yOffset)];
    [path addArcWithCenter:CGPointMake(radius + xOffset, f.size.height - radius + yOffset)
                    radius:radius
                startAngle:- (CGFloat)((M_PI * 3) / 2)
                  endAngle:- (CGFloat)M_PI
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(xOffset, radius + yOffset)];
    [path addArcWithCenter:CGPointMake(radius + xOffset, radius + yOffset)
                    radius:radius
                startAngle:- (CGFloat)M_PI
                  endAngle:- (CGFloat)(M_PI / 2)
                 clockwise:YES];

    return path;
}

- (void)updatePlaceholder {
    [super updatePlaceholder];

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat placeholderEstimatedHeight =
    GTCCeil(self.textInput.placeholderLabel.font.lineHeight * scale) / scale;
    CGFloat placeholderConstant =
    ([self borderHeight] / 2.f) - (placeholderEstimatedHeight / 2.f)
    + self.textInput.placeholderLabel.font.lineHeight * .5f;
    if (!self.placeholderCenterY) {
        self.placeholderCenterY = [NSLayoutConstraint constraintWithItem:self.textInput.placeholderLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.textInput
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:placeholderConstant];
        self.placeholderCenterY.priority = UILayoutPriorityDefaultHigh;
        self.placeholderCenterY.active = YES;

        [self.textInput.placeholderLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh + 1
                                                           forAxis:UILayoutConstraintAxisVertical];
    }
    self.placeholderCenterY.constant = placeholderConstant;

    CGFloat placeholderLeadingConstant = GTCTextInputOutlinedTextFieldFullPadding;

    if ([self.textInput conformsToProtocol:@protocol(GTCLeadingViewTextInput)]) {
        UIView<GTCLeadingViewTextInput> *leadingViewInput =
        (UIView<GTCLeadingViewTextInput> *)self.textInput;
        if (leadingViewInput.leadingView.superview) {
            placeholderLeadingConstant += CGRectGetWidth(leadingViewInput.leadingView.frame) +
            [self leadingViewTrailingPaddingConstant];
        }
    }

    if (!self.placeholderLeading) {
        self.placeholderLeading = [NSLayoutConstraint constraintWithItem:self.textInput.placeholderLabel
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.textInput
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1
                                                                constant:placeholderLeadingConstant];
        self.placeholderLeading.priority = UILayoutPriorityDefaultHigh;
        self.placeholderLeading.active = YES;
    }
    self.placeholderLeading.constant = placeholderLeadingConstant;
}

- (CGFloat)borderHeight {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat placeholderEstimatedHeight =
    GTCCeil(self.textInput.placeholderLabel.font.lineHeight * scale) / scale;
    return GTCTextInputOutlinedTextFieldNormalPlaceholderPadding + placeholderEstimatedHeight +
    GTCTextInputOutlinedTextFieldNormalPlaceholderPadding;
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

    return -underlineOffset;
}

@end

