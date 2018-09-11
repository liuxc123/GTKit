//
//  TextFieldManualLayoutLegacyExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/5.
//

#import "GTTextFields.h"

@interface TextFieldManualLayoutLegacyExample : UIViewController <UITextFieldDelegate>

@property(nonatomic) GTCTextInputControllerLegacyDefault *nameController;
@property(nonatomic) GTCTextInputControllerLegacyDefault *phoneController;

@end

@implementation TextFieldManualLayoutLegacyExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    GTCTextField *textFieldName = [[GTCTextField alloc] init];
    [self.view addSubview:textFieldName];

    textFieldName.delegate = self;
    textFieldName.clearButtonMode = UITextFieldViewModeUnlessEditing;

    self.nameController =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:textFieldName];

    textFieldName.frame = CGRectMake(10, 40, CGRectGetWidth(self.view.bounds) - 20, 0);

    self.nameController.placeholderText = @"Full Name";

    GTCTextField *textFieldPhone = [[GTCTextField alloc] init];
    [self.view addSubview:textFieldPhone];

    textFieldPhone.delegate = self;
    textFieldPhone.clearButtonMode = UITextFieldViewModeUnlessEditing;

    self.phoneController =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:textFieldPhone];

    textFieldPhone.frame = CGRectMake(10, CGRectGetMaxY(self.nameController.textInput.frame) + 20,
                                      CGRectGetWidth(self.view.bounds) - 20, 0);

    self.phoneController.placeholderText = @"Phone Number";
    self.phoneController.helperText = @"XXX-XXX-XXXX";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.nameController.textInput sizeToFit];
    [self.phoneController.textInput sizeToFit];
    self.phoneController.textInput.frame = CGRectMake(
                                                      10, CGRectGetMaxY(self.nameController.textInput.frame) + 20,
                                                      CGRectGetWidth(self.view.bounds) - 20, CGRectGetHeight(self.phoneController.textInput.frame));
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
            ![self.nameController.errorText isEqualToString:@"You cannot enter numbers"]) {
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

    if (textField == (UITextField *)self.phoneController.textInput) {
        if (![self isValidPhoneNumber:finishedString partially:YES] &&
            ![self.phoneController.errorText isEqualToString:@"Invalid phone number"]) {
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

@implementation TextFieldManualLayoutLegacyExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"[Legacy] Manual Layout" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end

