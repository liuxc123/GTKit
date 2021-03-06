//
//  TextFieldOutlinedExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/5.
//

#import "GTTextFields.h"
#import "GTTextFields+ColorThemer.h"
#import "GTTextFields+TypographyThemer.h"

@interface TextFieldOutlinedObjectiveCExample
: UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic) GTCTextInputControllerOutlined *nameController;
@property(nonatomic) GTCTextInputControllerOutlined *addressController;
@property(nonatomic) GTCTextInputControllerOutlined *cityController;
@property(nonatomic) GTCTextInputControllerOutlined *stateController;
@property(nonatomic) GTCTextInputControllerOutlined *zipController;
@property(nonatomic) GTCTextInputControllerOutlined *phoneController;

@property(nonatomic) GTCTextInputControllerOutlinedTextArea *messageController;

@property(nonatomic, strong) GTCSemanticColorScheme *colorScheme;
@property(nonatomic, strong) GTCTypographyScheme *typographyScheme;

@property(nonatomic) UIScrollView *scrollView;

@end

@implementation TextFieldOutlinedObjectiveCExample

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)styleTextInputController:(id<GTCTextInputController>)controller {
    [GTCOutlinedTextFieldColorThemer applySemanticColorScheme:self.colorScheme
                                        toTextInputController:controller];
    [GTCTextFieldTypographyThemer applyTypographyScheme:self.typographyScheme
                                  toTextInputController:controller];
    [GTCTextFieldTypographyThemer applyTypographyScheme:self.typographyScheme
                                            toTextInput:controller.textInput];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.colorScheme) {
        self.colorScheme = [[GTCSemanticColorScheme alloc] init];
    }
    if (!self.typographyScheme) {
        self.typographyScheme = [[GTCTypographyScheme alloc] init];
    }

    self.view.backgroundColor = self.colorScheme.backgroundColor;

    [self registerKeyboardNotifications];

    [self setupScrollView];

    GTCTextField *textFieldName = [[GTCTextField alloc] init];
    textFieldName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:textFieldName];

    textFieldName.delegate = self;
    textFieldName.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textFieldName.backgroundColor = [UIColor whiteColor];

    UIImage *leadingImage = [UIImage
                             imageNamed:@"ic_search"
                             inBundle:[NSBundle
                                       bundleForClass:[TextFieldOutlinedObjectiveCExample class]]
                             compatibleWithTraitCollection:nil];
    textFieldName.leadingView = [[UIImageView alloc] initWithImage:leadingImage];
    textFieldName.leadingViewMode = UITextFieldViewModeAlways;

    UIImage *trailingImage = [UIImage
                              imageNamed:@"ic_done"
                              inBundle:[NSBundle
                                        bundleForClass:[TextFieldOutlinedObjectiveCExample class]]
                              compatibleWithTraitCollection:nil];
    textFieldName.trailingView = [[UIImageView alloc] initWithImage:trailingImage];
    textFieldName.trailingViewMode = UITextFieldViewModeAlways;

    self.nameController = [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldName];
    self.nameController.placeholderText = @"Full Name";
    [self.nameController setFloatingEnabled:YES];
    [self styleTextInputController:self.nameController];

    GTCTextField *textFieldAddress = [[GTCTextField alloc] init];
    textFieldAddress.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:textFieldAddress];

    textFieldAddress.delegate = self;
    textFieldAddress.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textFieldAddress.backgroundColor = [UIColor whiteColor];

    self.addressController =
    [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldAddress];
    self.addressController.placeholderText = @"Address";
    [self styleTextInputController:self.addressController];

    GTCTextField *textFieldCity = [[GTCTextField alloc] init];
    textFieldCity.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:textFieldCity];

    textFieldCity.delegate = self;
    textFieldCity.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textFieldCity.backgroundColor = [UIColor whiteColor];

    self.cityController = [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldCity];
    self.cityController.placeholderText = @"City";
    [self styleTextInputController:self.cityController];

    GTCTextField *textFieldState = [[GTCTextField alloc] init];
    textFieldState.translatesAutoresizingMaskIntoConstraints = NO;

    textFieldState.delegate = self;
    textFieldState.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textFieldState.backgroundColor = [UIColor whiteColor];

    self.stateController = [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldState];
    self.stateController.placeholderText = @"State";
    [self styleTextInputController:self.stateController];

    GTCTextField *textFieldZip = [[GTCTextField alloc] init];
    textFieldZip.translatesAutoresizingMaskIntoConstraints = NO;

    textFieldZip.delegate = self;
    textFieldZip.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textFieldZip.backgroundColor = [UIColor whiteColor];

    self.zipController = [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldZip];
    self.zipController.placeholderText = @"Zip Code";
    [self styleTextInputController:self.zipController];

    UIView *stateZip = [[UIView alloc] initWithFrame:CGRectZero];
    stateZip.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:stateZip];
    stateZip.opaque = NO;

    [stateZip addSubview:textFieldState];
    [stateZip addSubview:textFieldZip];

    GTCTextField *textFieldPhone = [[GTCTextField alloc] init];
    textFieldPhone.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:textFieldPhone];

    textFieldPhone.delegate = self;
    textFieldPhone.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textFieldPhone.backgroundColor = [UIColor whiteColor];

    self.phoneController = [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldPhone];
    self.phoneController.placeholderText = @"Phone Number";
    self.phoneController.helperText = @"XXX-XXX-XXXX";
    [self styleTextInputController:self.phoneController];

    GTCMultilineTextField *textFieldMessage = [[GTCMultilineTextField alloc] init];
    textFieldMessage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:textFieldMessage];

    textFieldMessage.textView.delegate = self;

    self.messageController =
    [[GTCTextInputControllerOutlinedTextArea alloc] initWithTextInput:textFieldMessage];
    textFieldMessage.text = @"This is where you could put a multi-line message like an email.\n\n"
    "It can even handle new lines.";
    self.messageController.placeholderText = @"Message";
    [self styleTextInputController:self.messageController];

    NSDictionary *views = @{
                            @"name" : textFieldName,
                            @"address" : textFieldAddress,
                            @"city" : textFieldCity,
                            @"state" : textFieldState,
                            @"zip" : textFieldZip,
                            @"stateZip" : stateZip,
                            @"phone" : textFieldPhone,
                            @"message" : textFieldMessage
                            };
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray
                                                         arrayWithArray:
                                                         [NSLayoutConstraint
                                                          constraintsWithVisualFormat:@"V:[name]-[address]-[city]-[stateZip]-[phone]-[message]"

                                                          options:NSLayoutFormatAlignAllLeading |
                                                          NSLayoutFormatAlignAllTrailing
                                                          metrics:nil
                                                          views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textFieldName
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeadingMargin
                                                       multiplier:1
                                                         constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textFieldName
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTrailingMargin
                                                       multiplier:1
                                                         constant:0]];
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
                                                  [NSLayoutConstraint constraintWithItem:textFieldName
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView.contentLayoutGuide
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1
                                                                                constant:20],
                                                  [NSLayoutConstraint constraintWithItem:textFieldMessage
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView.contentLayoutGuide
                                                                               attribute:NSLayoutAttributeBottomMargin
                                                                              multiplier:1
                                                                                constant:-20]
                                                  ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
                                                  [NSLayoutConstraint constraintWithItem:textFieldName
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1
                                                                                constant:20],
                                                  [NSLayoutConstraint constraintWithItem:textFieldMessage
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView
                                                                               attribute:NSLayoutAttributeBottomMargin
                                                                              multiplier:1
                                                                                constant:-20]
                                                  ]];
    }
#else
    [NSLayoutConstraint activateConstraints:@[
                                              [NSLayoutConstraint constraintWithItem:textFieldName
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1
                                                                            constant:20],
                                              [NSLayoutConstraint constraintWithItem:textFieldMessage
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollView
                                                                           attribute:NSLayoutAttributeBottomMargin
                                                                          multiplier:1
                                                                            constant:-20]
                                              ]];
#endif

    [constraints
     addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[state(80)]-[zip]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[state]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[zip]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];

    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[scrollView]|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"scrollView" : self.scrollView
                                  }]];
    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[scrollView]|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"scrollView" : self.scrollView
                                  }]];
    UIEdgeInsets margins = UIEdgeInsetsMake(0, 16, 0, 16);
    self.scrollView.layoutMargins = margins;

    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidTouch:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    if (textField == (UITextField *)self.phoneController.textInput &&
        ![self isValidPhoneNumber:textField.text partially:NO]) {
        [self.phoneController setErrorText:@"Invalid Phone Number" errorAccessibilityValue:nil];
    }

    return NO;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *finishedString =
    [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == (UITextField *)self.nameController.textInput) {
        if ([finishedString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length &&
            ![self.nameController.errorText isEqualToString:@"Error: You cannot enter numbers"]) {
            // The entered text contains numbers and we have not set an error
            [self.nameController setErrorText:@"You cannot enter numbers" errorAccessibilityValue:nil];

            // Since we are doing manual layout, we need to react to the expansion of the input that will
            // come from setting an error.
            [self.view setNeedsLayout];
        } else if (self.nameController.errorText != nil) {
            // There should be no error but error text is being shown.
            [self.nameController setErrorText:nil errorAccessibilityValue:nil];

            // Since we are doing manual layout, we need to react to the contraction of the input that
            // will come from setting an error.
            [self.view setNeedsLayout];
        }
    }

    if (textField == (UITextField *)self.cityController.textInput) {
        if ([finishedString rangeOfCharacterFromSet:[[NSCharacterSet letterCharacterSet] invertedSet]]
            .length > 0) {
            [self.cityController setErrorText:@"Error: City can only contain letters"
                      errorAccessibilityValue:nil];
        } else {
            [self.cityController setErrorText:nil errorAccessibilityValue:nil];
        }
    }

    if (textField == (UITextField *)self.zipController.textInput) {
        if ([finishedString rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].length > 0) {
            [self.zipController setErrorText:@"Error: Zip can only contain numbers"
                     errorAccessibilityValue:nil];
        } else if (finishedString.length > 5) {
            [self.zipController setErrorText:@"Error: Zip can only contain five digits"
                     errorAccessibilityValue:nil];
        } else {
            [self.zipController setErrorText:nil errorAccessibilityValue:nil];
        }
    }

    if (textField == (UITextField *)self.phoneController.textInput) {
        if (![self isValidPhoneNumber:finishedString partially:YES] &&
            ![self.phoneController.errorText isEqualToString:@"Error: Invalid phone number"]) {
            // The entered text is not valid and we have not set an error
            [self.phoneController setErrorText:@"Invalid phone number" errorAccessibilityValue:nil];

            // The text field has helper text that already expanded the frame so we don't need to call
            // setNeedsLayout.
        } else if (self.phoneController.errorText != nil) {
            [self.phoneController setErrorText:nil errorAccessibilityValue:nil];

            // The text field has helper text and cannot contract the frame so we don't need to call
            // setNeedsLayout.
        }
    }

    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@", textView.text);
}

#pragma mark - Gesture Handling

- (void)tapDidTouch:(UIGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Keyboard Handling

- (void)registerKeyboardNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(keyboardFrame), 0);
}

- (void)keyboardWillHide:(NSNotification *)notif {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - Phone Number Validation

- (BOOL)isValidPhoneNumber:(NSString *)inputString partially:(BOOL)isPartialCheck {
    // In real life there would be much more robust validation that takes locale into account, checks
    // against invalid phone numbers (like those that begin with 0), and perhaps even auto-inserts the
    // hyphens so the user doesn't have to.

    if (inputString.length == 0) {
        return YES;
    }

    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
    characterSet = [characterSet invertedSet];

    BOOL isValid = ![inputString rangeOfCharacterFromSet:characterSet].length;

    if (!isPartialCheck) {
        isValid = isValid && inputString.length == 12;
    } else {
        isValid = isValid && inputString.length <= 12;
    }
    return isValid;
}

@end

@implementation TextFieldOutlinedObjectiveCExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"Outlined text fields" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return YES;
}

+ (BOOL)catalogIsPresentable {
    return YES;
}

@end

