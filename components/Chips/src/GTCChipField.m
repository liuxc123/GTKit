//
//  GTCChipField.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipField.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTMath.h"
#import "GTTextFields.h"

static NSString *const GTCChipFieldTextFieldKey = @"textField";
static NSString *const GTCChipFieldDelegateKey = @"delegate";
static NSString *const GTCChipFieldChipsKey = @"chips";
static NSString *const GTCChipFieldDelimiterKey = @"delimiter";
static NSString *const GTCChipFieldMinTextFieldWidthKey = @"minTextFieldWidth";
static NSString *const GTCChipFieldContentEdgeInsetsKey = @"contentEdgeInsets";
static NSString *const GTCChipFieldShowPlaceholderWithChipsKey = @"showPlaceholderWithChips";
static NSString *const GTCChipFieldChipHeightKey = @"chipHeight";

NSString * const GTCEmptyTextString = @"";
NSString * const GTCChipDelimiterSpace = @" ";

static const CGFloat GTCChipFieldHorizontalInset = 15.f;
static const CGFloat GTCChipFieldVerticalInset = 8.f;
static const CGFloat GTCChipFieldIndent = 4.f;
static const CGFloat GTCChipFieldHorizontalMargin = 4.f;
static const CGFloat GTCChipFieldVerticalMargin = 5.f;
static const CGFloat GTCChipFieldClearButtonSquareWidthHeight = 24.f;
static const CGFloat GTCChipFieldClearImageSquareWidthHeight = 18.f;
static const UIKeyboardType GTCChipFieldDefaultKeyboardType = UIKeyboardTypeEmailAddress;

const CGFloat GTCChipFieldDefaultMinTextFieldWidth = 60.f;
const UIEdgeInsets GTCChipFieldDefaultContentEdgeInsets = {
    GTCChipFieldVerticalInset, GTCChipFieldHorizontalInset, GTCChipFieldVerticalInset,
    GTCChipFieldHorizontalInset};

@protocol GTCChipTextFieldDelegate <NSObject>

- (void)textFieldShouldRespondToDeleteBackward:(UITextField *)textField;

@end

@interface GTCChipTextField : GTCTextField

@property(nonatomic, weak) id<GTCChipTextFieldDelegate> deletionDelegate;

@end

@implementation GTCChipTextField

#pragma mark UIKeyInput

- (void)deleteBackward {
    [super deleteBackward];
    if (self.text.length == 0) {
        [self.deletionDelegate textFieldShouldRespondToDeleteBackward:self];
    }
}

#if GTC_CHIPFIELD_PRIVATE_API_BUG_FIX && !(defined(__IPHONE_8_3) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_3))

// WARNING: This is a private method, see the warning in GTCChipField.h.
// This is only compiled if you explicitly defined GTC_CHIPFIELD_PRIVATE_API_BUG_FIX yourself, and
// you are targeting an iOS version less than 8.3.
- (BOOL)keyboardInputShouldDelete:(UITextField *)textField {
    BOOL shouldDelete = YES;
    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) =
        (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
            NSOperatingSystemVersion minimumVersion = {8, 0, 0};
            NSOperatingSystemVersion maximumVersion = {8, 3, 0};
            NSProcessInfo *processInfo = [NSProcessInfo processInfo];
            BOOL isIos8 = [processInfo isOperatingSystemAtLeastVersion:minimumVersion];
            BOOL isLessThanIos8_3 = ![processInfo isOperatingSystemAtLeastVersion:maximumVersion];
            if (![textField.text length] && isIos8 && isLessThanIos8_3) {
                [self deleteBackward];
            }
        }
    }
    return shouldDelete;
}

#endif

#pragma mark - UIAccessibility

- (CGRect)accessibilityFrame {
    CGRect frame = [super accessibilityFrame];
    return CGRectMake(frame.origin.x + self.textInsets.left,
                      frame.origin.y,
                      frame.size.width - self.textInsets.left,
                      frame.size.height);
}

@end

@interface GTCChipField ()
<GTCChipTextFieldDelegate, GTCTextInputPositioningDelegate, UITextFieldDelegate>
@end

@implementation GTCChipField {
    NSMutableArray<GTCChipView *> *_chips;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCChipFieldInit];

        _chips = [NSMutableArray array];

        GTCChipTextField *chipTextField = [[GTCChipTextField alloc] initWithFrame:self.bounds];
        chipTextField.underline.hidden = YES;
        chipTextField.delegate = self;
        chipTextField.deletionDelegate = self;
        chipTextField.positioningDelegate = self;
        chipTextField.accessibilityTraits = UIAccessibilityTraitNone;
        chipTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        chipTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        chipTextField.keyboardType = GTCChipFieldDefaultKeyboardType;
        // Listen for notifications posted when the text field is the first responder.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChange)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:chipTextField];
        // Also listen for notifications posted when the text field is not the first responder.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChange)
                                                     name:GTCTextFieldTextDidSetTextNotification
                                                   object:chipTextField];
        [self addSubview:chipTextField];
        _textField = chipTextField;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCChipFieldInit];

        _textField = [aDecoder decodeObjectForKey:GTCChipFieldTextFieldKey];

        if ([aDecoder containsValueForKey:GTCChipFieldDelegateKey]) {
            _delegate = [aDecoder decodeObjectForKey:GTCChipFieldDelegateKey];
        }
        if ([aDecoder containsValueForKey:GTCChipFieldChipsKey]) {
            _chips = [aDecoder decodeObjectForKey:GTCChipFieldChipsKey];
        }
        if ([aDecoder containsValueForKey:GTCChipFieldDelimiterKey]) {
            _delimiter = (NSUInteger)[aDecoder decodeIntegerForKey:GTCChipFieldDelimiterKey];
        }
        if ([aDecoder containsValueForKey:GTCChipFieldMinTextFieldWidthKey]) {
            _minTextFieldWidth = (CGFloat)[aDecoder decodeDoubleForKey:GTCChipFieldMinTextFieldWidthKey];
        }
        if ([aDecoder containsValueForKey:GTCChipFieldContentEdgeInsetsKey]) {
            _contentEdgeInsets = [aDecoder decodeUIEdgeInsetsForKey:GTCChipFieldContentEdgeInsetsKey];
        }
        if ([aDecoder containsValueForKey:GTCChipFieldShowPlaceholderWithChipsKey]) {
            _showPlaceholderWithChips =
            [aDecoder decodeBoolForKey:GTCChipFieldShowPlaceholderWithChipsKey];
        }
        if ([aDecoder containsValueForKey:GTCChipFieldChipHeightKey]) {
            _chipHeight = (CGFloat)[aDecoder decodeDoubleForKey:GTCChipFieldChipHeightKey];
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonGTCChipFieldInit {
    _chips = [NSMutableArray array];
    _delimiter = GTCChipFieldDelimiterDefault;
    _minTextFieldWidth = GTCChipFieldDefaultMinTextFieldWidth;
    _contentEdgeInsets = GTCChipFieldDefaultContentEdgeInsets;
    _showPlaceholderWithChips = YES;
    _chipHeight = 32.0f;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_textField forKey:GTCChipFieldTextFieldKey];
    [aCoder encodeObject:_delegate forKey:GTCChipFieldDelegateKey];
    [aCoder encodeObject:_chips forKey:GTCChipFieldChipHeightKey];
    [aCoder encodeInteger:(NSInteger)_delimiter forKey:GTCChipFieldDelimiterKey];
    [aCoder encodeDouble:(double)_minTextFieldWidth forKey:GTCChipFieldMinTextFieldWidthKey];
    [aCoder encodeUIEdgeInsets:_contentEdgeInsets forKey:GTCChipFieldContentEdgeInsetsKey];
    [aCoder encodeBool:_showPlaceholderWithChips forKey:GTCChipFieldShowPlaceholderWithChipsKey];
    [aCoder encodeDouble:(double)_chipHeight forKey:GTCChipFieldChipHeightKey];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect standardizedBounds = CGRectStandardize(self.bounds);

    BOOL isRTL =
    self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;

    // Calculate the frames for all the chips and set them.
    NSArray *chipFrames = [self chipFramesForSize:standardizedBounds.size];
    for (NSUInteger index = 0; index < _chips.count; index++) {
        GTCChipView *chip = _chips[index];

        CGRect chipFrame = [chipFrames[index] CGRectValue];
        if (isRTL) {
            chipFrame = GTFRectFlippedHorizontally(chipFrame, CGRectGetWidth(self.bounds));
        }
        chip.frame = chipFrame;
    }

    // Get the last chip frame and calculate the text field frame from that.
    CGRect lastChipFrame = [chipFrames.lastObject CGRectValue];
    CGRect textFieldFrame = [self frameForTextFieldForLastChipFrame:lastChipFrame
                                                      chipFieldSize:standardizedBounds.size];
    if (isRTL) {
        textFieldFrame = GTFRectFlippedHorizontally(textFieldFrame, CGRectGetWidth(self.bounds));
    }
    self.textField.frame = textFieldFrame;

    [self updateTextFieldPlaceholderText];
}

- (void)updateTextFieldPlaceholderText {
    // Place holder label should be hidden if showPlaceholderWithChips is NO and there are chips.
    // GTCTextField sets the placeholderLabel opacity to 0 if the text field has no text.
    self.textField.placeholderLabel.hidden =
    (!self.showPlaceholderWithChips && self.chips.count > 0) || ![self isTextFieldEmpty];
}

+ (UIFont *)textFieldFont {
    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}

- (CGSize)intrinsicContentSize {
    CGFloat minWidth =
    MAX(self.minTextFieldWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
        CGRectGetWidth(self.bounds));
    return [self sizeThatFits:CGSizeMake(minWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSArray *chipFrames = [self chipFramesForSize:size];
    CGRect lastChipFrame = [chipFrames.lastObject CGRectValue];
    CGRect textFieldFrame = [self frameForTextFieldForLastChipFrame:lastChipFrame
                                                      chipFieldSize:size];

    // Calculate the required size off the text field.
    // To properly apply bottom inset: Calculate what would be the height if there were a chip
    // instead of the text field. Then add the bottom inset.
    CGFloat height = CGRectGetMaxY(textFieldFrame) + self.contentEdgeInsets.bottom +
    (self.chipHeight - textFieldFrame.size.height) / 2;
    CGFloat width = MAX(size.width, self.minTextFieldWidth);

    return CGSizeMake(width, height);
}

- (void)clearTextInput {
    self.textField.text = GTCEmptyTextString;
    [self updateTextFieldPlaceholderText];
}

- (void)setChips:(NSArray<GTCChipView *> *)chips {
    if ([_chips isEqual:chips]) {
        return;
    }

    for (GTCChipView *chip in _chips) {
        [self removeChipSubview:chip];
    }

    _chips = [chips mutableCopy];
    for (GTCChipView *chip in _chips) {
        [self addChipSubview:chip];
    }
    [self notifyDelegateIfSizeNeedsToBeUpdated];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (NSArray<GTCChipView *> *)chips {
    return [NSArray arrayWithArray:_chips];
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}

- (void)addChip:(GTCChipView *)chip {
    // Note that |chipField:shouldAddChip| is only called in |createNewChipFromInput| when it is
    // necessary to restrict chip creation based on input text generated in the user interface.
    // Clients calling |addChip| directly programmatically are expected to handle such restrictions
    // themselves rather than using |chipField:shouldAddChip| to prevent chips from being added.
    [_chips addObject:chip];
    [self addChipSubview:chip];
    if ([self.delegate respondsToSelector:@selector(chipField:didAddChip:)]) {
        [self.delegate chipField:self didAddChip:chip];
    }
    [self notifyDelegateIfSizeNeedsToBeUpdated];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)removeChip:(GTCChipView *)chip {
    [_chips removeObject:chip];
    [self removeChipSubview:chip];
    if ([self.delegate respondsToSelector:@selector(chipField:didRemoveChip:)]) {
        [self.delegate chipField:self didRemoveChip:chip];
    }
    [self notifyDelegateIfSizeNeedsToBeUpdated];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)removeSelectedChips {
    NSMutableArray *chipsToRemove = [NSMutableArray array];
    for (GTCChipView *chip in self.chips) {
        if (chip.isSelected) {
            [chipsToRemove addObject:chip];
        }
    }
    for (GTCChipView *chip in chipsToRemove) {
        [self removeChip:chip];
    }
}

- (void)selectChip:(GTCChipView *)chip {
    [self deselectAllChipsExceptChip:chip];
    chip.selected = YES;
}

- (void)selectLastChip {
    GTCChipView *lastChip = self.chips.lastObject;
    [self deselectAllChipsExceptChip:lastChip];
    lastChip.selected = YES;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                    [lastChip accessibilityLabel]);
}

- (void)deselectAllChips {
    [self deselectAllChipsExceptChip:nil];
}

- (void)deselectAllChipsExceptChip:(GTCChipView *)chip {
    for (GTCChipView *otherChip in self.chips) {
        if (chip != otherChip) {
            otherChip.selected = NO;
        }
    }
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets)) {
        _contentEdgeInsets = contentEdgeInsets;
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setMinTextFieldWidth:(CGFloat)minTextFieldWidth {
    if (_minTextFieldWidth != minTextFieldWidth) {
        _minTextFieldWidth = minTextFieldWidth;
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)commitInput {
    if (![self isTextFieldEmpty]) {
        [self createNewChipFromInput];
    }
}

- (void)createNewChipFromInput {
    NSString *strippedTitle = [self.textField.text
                               stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (strippedTitle.length > 0) {
        GTCChipView *chip = [[GTCChipView alloc] init];
        chip.titleLabel.text = strippedTitle;
        if (self.showChipsDeleteButton) {
            [self addClearButtonToChip:chip];
        }
        BOOL shouldAddChip = YES;
        if ([self.delegate respondsToSelector:@selector(chipField:shouldAddChip:)]) {
            shouldAddChip = [self.delegate chipField:self shouldAddChip:chip];
        }
        if (shouldAddChip) {
            [self addChip:chip];
            [self clearTextInput];
        }
    } else {
        [self clearTextInput];
    }
}

- (void)addClearButtonToChip:(GTCChipView *)chip {
    UIControl *clearButton = [[UIControl alloc] init];
    CGFloat clearButtonWidthAndHeight = GTCChipFieldClearButtonSquareWidthHeight;
    clearButton.frame = CGRectMake(0, 0, clearButtonWidthAndHeight, clearButtonWidthAndHeight);
    clearButton.layer.cornerRadius = clearButtonWidthAndHeight / 2;
    UIImageView *clearImageView = [[UIImageView alloc] initWithImage:[self drawClearButton]];
    CGFloat widthAndHeight = GTCChipFieldClearImageSquareWidthHeight;
    CGFloat padding =
    (GTCChipFieldClearButtonSquareWidthHeight - GTCChipFieldClearImageSquareWidthHeight) / 2;
    clearImageView.frame = CGRectMake(padding, padding, widthAndHeight, widthAndHeight);
    clearButton.tintColor = [UIColor.blackColor colorWithAlphaComponent:0.6f];
    [clearButton addSubview:clearImageView];
    chip.accessoryView = clearButton;
    [clearButton addTarget:self
                    action:@selector(deleteChip:)
          forControlEvents:UIControlEventTouchUpInside];
}

- (UIImage *)drawClearButton {
    CGSize clearButtonSize =
    CGSizeMake(GTCChipFieldClearImageSquareWidthHeight, GTCChipFieldClearImageSquareWidthHeight);

    CGRect bounds = CGRectMake(0, 0, clearButtonSize.width, clearButtonSize.height);
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0);
    [UIColor.grayColor setFill];
    [GTCPathForClearButtonImageFrame(bounds) fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

static inline UIBezierPath *GTCPathForClearButtonImageFrame(CGRect frame) {
    // GENERATED CODE

    CGRect innerBounds = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2,
                                    GTCFloor((frame.size.width - 2) * 0.90909f + 0.5f),
                                    GTCFloor((frame.size.height - 2) * 0.90909f + 0.5f));
    UIBezierPath *ic_clear_path = [UIBezierPath bezierPath];
    [ic_clear_path
     moveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                             CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 0.50000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 0.77600f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.22400f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.77600f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 0.77600f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 0.50000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 0.22400f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.77600f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.22400f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 0.22400f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)];
    [ic_clear_path closePath];
    [ic_clear_path
     moveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.73417f * innerBounds.size.width,
                             CGRectGetMinY(innerBounds) + 0.31467f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.68700f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.26750f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50083f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.45367f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.31467f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.26750f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.26750f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.31467f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.45367f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.50083f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.26750f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.68700f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.31467f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.73417f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50083f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.54800f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.68700f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.73417f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.73417f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.68700f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.54800f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.50083f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.73417f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.31467f * innerBounds.size.height)];
    [ic_clear_path closePath];

    return ic_clear_path;
}

- (void)deleteChip:(id)sender {
    UIControl *deleteButton = (UIControl *)sender;
    GTCChipView *chip = (GTCChipView *)deleteButton.superview;
    [self removeChip:chip];
    [self clearTextInput];
}

- (void)notifyDelegateIfSizeNeedsToBeUpdated {
    if ([self.delegate respondsToSelector:@selector(chipFieldHeightDidChange:)]) {
        CGSize currentSize = CGRectStandardize(self.bounds).size;
        CGSize requiredSize = [self sizeThatFits:CGSizeMake(currentSize.width, CGFLOAT_MAX)];
        if (currentSize.height != requiredSize.height) {
            [self.delegate chipFieldHeightDidChange:self];
        }
    }
}

- (void)chipTapped:(id)sender {
    BOOL shouldBecomeFirstResponder = YES;
    if ([self.delegate respondsToSelector:@selector(chipFieldShouldBecomeFirstResponder:)]) {
        shouldBecomeFirstResponder = [self.delegate chipFieldShouldBecomeFirstResponder:self];
    }
    if (shouldBecomeFirstResponder) {
        [self becomeFirstResponder];
    }
    GTCChipView *chip = (GTCChipView *)sender;
    if ([self.delegate respondsToSelector:@selector(chipField:didTapChip:)]) {
        [self.delegate chipField:self didTapChip:chip];
    }
}

#pragma mark - GTCChipTextFieldDelegate

- (void)textFieldShouldRespondToDeleteBackward:(UITextField *)textField {
    if ([self isAnyChipSelected]) {
        [self removeSelectedChips];
        [self deselectAllChips];
    } else {
        [self selectLastChip];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textField) {
        [self deselectAllChips];
    }
    if ([self.delegate respondsToSelector:@selector(chipFieldDidBeginEditing:)]) {
        [self.delegate chipFieldDidBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ((self.delimiter & GTCChipFieldDelimiterDidEndEditing) == GTCChipFieldDelimiterDidEndEditing) {
        if (textField == self.textField) {
            [self commitInput];
        }
    }
    if ([self.delegate respondsToSelector:@selector(chipFieldDidEndEditing:)]) {
        [self.delegate chipFieldDidEndEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = YES;

    // Chip field content view will handle |chipFieldShouldReturn| if the client is not using chip
    // field directly. If the client uses chip field directly without the content view and has not
    // implemented |chipFieldShouldReturn|, then a chip should always be created.
    if ([self.delegate respondsToSelector:@selector(chipFieldShouldReturn:)]) {
        shouldReturn = [self.delegate chipFieldShouldReturn:self];
    }
    if (shouldReturn) {
        [self createNewChipWithTextField:textField delimiter:GTCChipFieldDelimiterReturn];
    }

    return shouldReturn;
}

- (void)textFieldDidChange {
    [self deselectAllChips];
    [self createNewChipWithTextField:self.textField delimiter:GTCChipFieldDelimiterSpace];

    if ([self.delegate respondsToSelector:@selector(chipField:didChangeInput:)]) {
        [self.delegate chipField:self
                  didChangeInput:[self.textField.text copy]];
    }
}

#pragma mark - Private

- (void)removeChipSubview:(GTCChipView *)chip {
    [chip removeFromSuperview];
    [chip removeTarget:chip.superview
                action:@selector(chipTapped:)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)addChipSubview:(GTCChipView *)chip {
    if (chip.superview != self) {
        [chip addTarget:self
                 action:@selector(chipTapped:)
       forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chip];
    }
}

- (void)createNewChipWithTextField:(UITextField *)textField
                         delimiter:(GTCChipFieldDelimiter)delimiter {
    if ((self.delimiter & delimiter) == delimiter && textField.text.length > 0) {
        if (delimiter == GTCChipFieldDelimiterReturn) {
            [self createNewChipFromInput];
        } else if (delimiter == GTCChipFieldDelimiterSpace) {
            NSString *lastChar = [textField.text substringFromIndex:textField.text.length - 1];
            if ([lastChar isEqualToString:GTCChipDelimiterSpace]) {
                [self createNewChipFromInput];
            }
        }
    }
}

- (BOOL)isAnyChipSelected {
    for (GTCChipView *chip in self.chips) {
        if (chip.isSelected) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isTextFieldEmpty {
    return self.textField.text.length == 0;
}

#pragma mark - Sizing

- (NSArray<NSValue *> *)chipFramesForSize:(CGSize)size {
    NSMutableArray *chipFrames = [NSMutableArray arrayWithCapacity:self.chips.count];
    CGFloat chipFieldMaxX = size.width - self.contentEdgeInsets.right;
    CGFloat maxWidth = size.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right;
    NSUInteger row = 0;
    CGFloat currentOriginX = self.contentEdgeInsets.left;

    for (GTCChipView *chip in self.chips) {
        CGSize chipSize = [chip sizeThatFits:CGSizeMake(maxWidth, self.chipHeight)];
        chipSize.width = MIN(chipSize.width, maxWidth);

        CGFloat availableWidth = chipFieldMaxX - currentOriginX;
        // Check if the chip will fit on the current line.  If it won't fit and the available width
        // is the maximum width, it won't fit on any line. Put it on the current one and move on.
        if (chipSize.width > availableWidth &&
            availableWidth < (chipFieldMaxX - self.contentEdgeInsets.right)) {
            row++;
            currentOriginX = self.contentEdgeInsets.left;
        }
        CGFloat currentOriginY =
        self.contentEdgeInsets.top + (row * (self.chipHeight + GTCChipFieldVerticalMargin));
        CGRect chipFrame =
        CGRectMake(currentOriginX, currentOriginY, chipSize.width, chipSize.height);
        [chipFrames addObject:[NSValue valueWithCGRect:chipFrame]];
        currentOriginX = CGRectGetMaxX(chipFrame) + GTCChipFieldHorizontalMargin;
    }
    return [chipFrames copy];
}

- (CGRect)frameForTextFieldForLastChipFrame:(CGRect)lastChipFrame
                              chipFieldSize:(CGSize)chipFieldSize {
    CGFloat textFieldWidth =
    chipFieldSize.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right;
    CGFloat textFieldHeight = [self.textField sizeThatFits:chipFieldSize].height;
    CGFloat originY = lastChipFrame.origin.y + (self.chipHeight - textFieldHeight) / 2.f;

    // If no chip exists, make the text field the full width minus padding.
    if (CGRectIsEmpty(lastChipFrame)) {
        // Adjust for the top inset
        originY += self.contentEdgeInsets.top;
        return CGRectMake(self.contentEdgeInsets.left, originY, textFieldWidth, textFieldHeight);
    }

    CGFloat availableWidth = chipFieldSize.width - self.contentEdgeInsets.right -
    CGRectGetMaxX(lastChipFrame) - GTCChipFieldHorizontalMargin;
    CGFloat placeholderDesiredWidth = [self placeholderDesiredWidth];
    if (availableWidth < placeholderDesiredWidth) {
        // The text field doesn't fit on the line with the last chip.
        originY += self.chipHeight + GTCChipFieldVerticalMargin;
        return CGRectMake(self.contentEdgeInsets.left, originY, textFieldWidth, textFieldHeight);
    }

    return CGRectMake(self.contentEdgeInsets.left, originY, textFieldWidth, textFieldHeight);
}

- (CGFloat)placeholderDesiredWidth {
    NSString *placeholder = self.textField.placeholder;
    if (!self.showPlaceholderWithChips && self.chips.count > 0) {
        placeholder = nil;
    }
    UIFont *placeholderFont = self.textField.placeholderLabel.font;
    CGRect placeholderDesiredRect =
    [placeholder boundingRectWithSize:CGRectStandardize(self.bounds).size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName : placeholderFont, }
                              context:nil];
    return MAX(CGRectGetWidth(placeholderDesiredRect), self.minTextFieldWidth);
}

#pragma mark - GTCTextInputPositioningDelegate

- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    CGRect lastChipFrame = self.chips.lastObject.frame;
    if (self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        lastChipFrame = GTFRectFlippedHorizontally(lastChipFrame, CGRectGetWidth(self.bounds));
    }

    CGFloat availableWidth = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right -
    CGRectGetMaxX(lastChipFrame) - GTCChipFieldHorizontalMargin;

    CGFloat leftInset = GTCChipFieldIndent;
    if (!CGRectIsEmpty(lastChipFrame) && availableWidth >= [self placeholderDesiredWidth]) {
        leftInset +=
        CGRectGetMaxX(lastChipFrame) + GTCChipFieldHorizontalMargin - self.contentEdgeInsets.left;
    }
    defaultInsets.left = leftInset;

    return defaultInsets;
}

#pragma mark - UIAccessibilityContainer

- (BOOL)isAccessibilityElement {
    return NO;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    if (index < (NSInteger)self.chips.count) {
        return self.chips[index];
    } else if (index == (NSInteger)self.chips.count) {
        return self.textField;
    }

    return nil;
}

- (NSInteger)accessibilityElementCount {
    return self.chips.count + 1;
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    if (element == self.textField) {
        return self.chips.count;
    }

    return [self.chips indexOfObject:element];
}

#pragma mark - Accessibility

- (void)focusTextFieldForAccessibility {
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.textField);
}

@end
