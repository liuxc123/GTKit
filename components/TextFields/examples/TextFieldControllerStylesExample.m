//
//  TextFieldControllerStylesExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <UIKit/UIKit.h>

#import "GTTextFields.h"

#import "supplemental/TextFieldControllerStylesExampleSupplemental.h"

@interface TextFieldControllerStylesExample ()

// Be sure to keep your controllers in memory somewhere like a property:
@property(nonatomic, strong) GTCTextInputControllerOutlined *textFieldControllerOutlined;
@property(nonatomic, strong) GTCTextInputControllerFilled *textFieldControllerFilled;
@property(nonatomic, strong) GTCTextInputControllerUnderline *textFieldControllerUnderline;
@property(nonatomic, strong) GTCTextInputControllerFullWidth *textFieldControllerFullWidth;


@property(nonatomic, strong) UIImage *leadingImage;
@property(nonatomic, strong) UIImage *trailingImage;

@end

@implementation TextFieldControllerStylesExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
    self.title = @"Material Text Fields";

    [self setupExampleViews];
    [self setupImages];
    [self setupTextFields];
    [self registerKeyboardNotifications];
}

- (void)setupImages {
    self.leadingImage = [UIImage imageNamed:@"ic_search"
                                   inBundle:[NSBundle bundleForClass:[TextFieldControllerStylesExample
                                                                      class]]
              compatibleWithTraitCollection:nil];
    self.trailingImage =
    [UIImage imageNamed:@"ic_done"
               inBundle:[NSBundle
                         bundleForClass:[TextFieldControllerStylesExample class]]
compatibleWithTraitCollection:nil];
}

- (void)extracted {
    [self.textFieldControllerFullWidth gtc_setAdjustsFontForContentSizeCategory:true];
}

- (void)setupTextFields {
    // Default with Character Count and Floating Placeholder Text Fields

    // First the text field is added to the view hierarchy
    GTCTextField *textFieldOutlined = [[GTCTextField alloc] init];
    [self.scrollView addSubview:textFieldOutlined];
    textFieldOutlined.translatesAutoresizingMaskIntoConstraints = NO;

    int characterCountMax = 25;
    textFieldOutlined.delegate = self;
    textFieldOutlined.clearButtonMode = UITextFieldViewModeAlways;

    textFieldOutlined.leadingView = [[UIImageView alloc] initWithImage:self.leadingImage];
    textFieldOutlined.leadingViewMode = UITextFieldViewModeAlways;
    textFieldOutlined.trailingView = [[UIImageView alloc] initWithImage:self.trailingImage];
    textFieldOutlined.trailingViewMode = UITextFieldViewModeAlways;

    // Second the controller is created to manage the text field
    self.textFieldControllerOutlined =
    [[GTCTextInputControllerOutlined alloc] initWithTextInput:textFieldOutlined];
    self.textFieldControllerOutlined.placeholderText =
    @"GTCTextInputControllerOutlined";
    self.textFieldControllerOutlined.characterCountMax = characterCountMax;

    [self.textFieldControllerOutlined gtc_setAdjustsFontForContentSizeCategory:YES];

    GTCTextField *textFieldFilled = [[GTCTextField alloc] init];
    [self.scrollView addSubview:textFieldFilled];
    textFieldFilled.translatesAutoresizingMaskIntoConstraints = NO;

    textFieldFilled.delegate = self;
    textFieldFilled.clearButtonMode = UITextFieldViewModeUnlessEditing;

    textFieldFilled.leadingView = [[UIImageView alloc] initWithImage:self.leadingImage];
    textFieldFilled.leadingViewMode = UITextFieldViewModeAlways;
    textFieldFilled.trailingView = [[UIImageView alloc] initWithImage:self.trailingImage];
    textFieldFilled.trailingViewMode = UITextFieldViewModeAlways;

    self.textFieldControllerFilled =
    [[GTCTextInputControllerFilled alloc] initWithTextInput:textFieldFilled];
    self.textFieldControllerFilled.placeholderText = @"GTCTextInputControllerFilled";
    self.textFieldControllerFilled.characterCountMax = characterCountMax;

    [self.textFieldControllerFilled gtc_setAdjustsFontForContentSizeCategory:YES];

    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[charMax]-[floating]"
                          options:NSLayoutFormatAlignAllLeading |
                          NSLayoutFormatAlignAllTrailing
                          metrics:nil
                          views:@{
                                  @"charMax" : textFieldOutlined,
                                  @"floating" : textFieldFilled
                                  }]];
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeadingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;

    // Full Width Text Field
    GTCTextField *textFieldUnderline = [[GTCTextField alloc] init];
    [self.scrollView addSubview:textFieldUnderline];
    textFieldUnderline.translatesAutoresizingMaskIntoConstraints = NO;

    textFieldUnderline.delegate = self;
    textFieldUnderline.clearButtonMode = UITextFieldViewModeUnlessEditing;

    textFieldUnderline.leadingView = [[UIImageView alloc] initWithImage:self.leadingImage];
    textFieldUnderline.leadingViewMode = UITextFieldViewModeAlways;
    textFieldUnderline.trailingView = [[UIImageView alloc] initWithImage:self.trailingImage];
    textFieldUnderline.trailingViewMode = UITextFieldViewModeAlways;

    self.textFieldControllerUnderline =
    [[GTCTextInputControllerUnderline alloc] initWithTextInput:textFieldUnderline];
    self.textFieldControllerUnderline.placeholderText = @"GTCTextInputControllerUnderline";
    self.textFieldControllerUnderline.characterCountMax = characterCountMax;

    [self.textFieldControllerUnderline gtc_setAdjustsFontForContentSizeCategory:YES];

    [NSLayoutConstraint constraintWithItem:textFieldUnderline
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:textFieldFilled
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:1]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldUnderline
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeadingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldUnderline
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView.contentLayoutGuide
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:20]
        .active = YES;
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView.contentLayoutGuide
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:-20]
        .active = YES;
    } else {
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:20]
        .active = YES;
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:-20]
        .active = YES;
    }
#else
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:20]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:-20]
    .active = YES;
#endif

}

#pragma mark - UITextFieldDelegate

// All the usual UITextFieldDelegate methods work with GTCTextField
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
                          name:UIKeyboardDidChangeFrameNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(frame), 0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
