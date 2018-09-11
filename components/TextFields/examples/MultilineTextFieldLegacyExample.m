//
//  MultilineTextFieldLegacyExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/5.
//

#import "GTTextFields.h"

@interface MultilineTextFieldLegacyExample : UIViewController <UITextViewDelegate>

// Be sure to keep your controllers in memory somewhere like a property:
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *textFieldControllerDefaultCharMax;
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *textFieldControllerFloating;
@property(nonatomic, strong) GTCTextInputControllerLegacyFullWidth *textFieldControllerFullWidth;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MultilineTextFieldLegacyExample

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];

    self.title = @"Legacy Multi-line Styles";

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    UIEdgeInsets margins = UIEdgeInsetsMake(0, 16, 0, 16);
    self.scrollView.layoutMargins = margins;

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

    GTCMultilineTextField *multilineTextFieldUnstyled = [[GTCMultilineTextField alloc] init];
    [self.scrollView addSubview:multilineTextFieldUnstyled];
    multilineTextFieldUnstyled.translatesAutoresizingMaskIntoConstraints = NO;

    multilineTextFieldUnstyled.placeholder = @"No Controller (unstyled)";
    multilineTextFieldUnstyled.textView.delegate = self;
    multilineTextFieldUnstyled.leadingUnderlineLabel.text = @"Leading";
    multilineTextFieldUnstyled.trailingUnderlineLabel.text = @"Trailing";

    GTCMultilineTextField *multilineTextFieldUnstyledArea = [[GTCMultilineTextField alloc] init];
    [self.scrollView addSubview:multilineTextFieldUnstyledArea];
    multilineTextFieldUnstyledArea.translatesAutoresizingMaskIntoConstraints = NO;

    multilineTextFieldUnstyledArea.placeholder = @"No Controller (unstyled) minimum of 3 lines";
    multilineTextFieldUnstyledArea.textView.delegate = self;
    multilineTextFieldUnstyledArea.leadingUnderlineLabel.text = @"Leading";
    multilineTextFieldUnstyledArea.trailingUnderlineLabel.text = @"Trailing";
    multilineTextFieldUnstyledArea.minimumLines = 3;
    multilineTextFieldUnstyledArea.expandsOnOverflow = NO;

    GTCMultilineTextField *multilineTextFieldFloating = [[GTCMultilineTextField alloc] init];
    [self.scrollView addSubview:multilineTextFieldFloating];
    multilineTextFieldFloating.translatesAutoresizingMaskIntoConstraints = NO;

    multilineTextFieldFloating.textView.delegate = self;

    self.textFieldControllerFloating =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:multilineTextFieldFloating];
    self.textFieldControllerFloating.placeholderText = @"Floating Controller";

    GTCMultilineTextField *multilineTextFieldCharMaxDefault = [[GTCMultilineTextField alloc] init];
    [self.scrollView addSubview:multilineTextFieldCharMaxDefault];
    multilineTextFieldCharMaxDefault.translatesAutoresizingMaskIntoConstraints = NO;

    multilineTextFieldCharMaxDefault.textView.delegate = self;

    self.textFieldControllerDefaultCharMax = [[GTCTextInputControllerLegacyDefault alloc]
                                              initWithTextInput:multilineTextFieldCharMaxDefault];
    self.textFieldControllerDefaultCharMax.characterCountMax = 30;
    self.textFieldControllerDefaultCharMax.floatingEnabled = NO;
    self.textFieldControllerDefaultCharMax.placeholderText = @"Inline Placeholder Only";

    GTCMultilineTextField *multilineTextFieldCharMaxFullWidth = [[GTCMultilineTextField alloc] init];
    [self.scrollView addSubview:multilineTextFieldCharMaxFullWidth];
    multilineTextFieldCharMaxFullWidth.translatesAutoresizingMaskIntoConstraints = NO;

    multilineTextFieldCharMaxFullWidth.textView.delegate = self;

    self.textFieldControllerFullWidth = [[GTCTextInputControllerLegacyFullWidth alloc]
                                         initWithTextInput:multilineTextFieldCharMaxFullWidth];
    self.textFieldControllerFullWidth.characterCountMax = 140;
    self.textFieldControllerFullWidth.placeholderText = @"Full Width Controller";

    [NSLayoutConstraint
     activateConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[unstyled]-[area]-[floating]-[charMax]-[fullWidth]"
      options:0
      metrics:nil
      views:@{
              @"unstyled" : multilineTextFieldUnstyled,
              @"area" : multilineTextFieldUnstyledArea,
              @"charMax" : multilineTextFieldCharMaxDefault,
              @"floating" : multilineTextFieldFloating,
              @"fullWidth" : multilineTextFieldCharMaxFullWidth
              }]];
    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[unstyled]-|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"unstyled" : multilineTextFieldUnstyled
                                  }]];
    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[area]-|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"area" : multilineTextFieldUnstyledArea
                                  }]];
    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[floating]-|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"floating" : multilineTextFieldFloating
                                  }]];
    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[charMax]-|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"charMax" : multilineTextFieldCharMaxDefault
                                  }]];

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
                                                  [NSLayoutConstraint constraintWithItem:multilineTextFieldUnstyled
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView.contentLayoutGuide
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1
                                                                                constant:20],
                                                  [NSLayoutConstraint constraintWithItem:multilineTextFieldCharMaxFullWidth
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView.contentLayoutGuide
                                                                               attribute:NSLayoutAttributeBottomMargin
                                                                              multiplier:1
                                                                                constant:-20]
                                                  ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
                                                  [NSLayoutConstraint constraintWithItem:multilineTextFieldUnstyled
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.scrollView
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1
                                                                                constant:20],
                                                  [NSLayoutConstraint constraintWithItem:multilineTextFieldCharMaxFullWidth
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
                                              [NSLayoutConstraint constraintWithItem:multilineTextFieldUnstyled
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1
                                                                            constant:20],
                                              [NSLayoutConstraint constraintWithItem:multilineTextFieldCharMaxFullWidth
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollView
                                                                           attribute:NSLayoutAttributeBottomMargin
                                                                          multiplier:1
                                                                            constant:-20]
                                              ]];
#endif

    [NSLayoutConstraint constraintWithItem:multilineTextFieldCharMaxFullWidth
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:multilineTextFieldCharMaxFullWidth
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[fullWidth]|"
                          options:0
                          metrics:nil
                          views:@{
                                  @"fullWidth" :
                                      multilineTextFieldCharMaxFullWidth
                                  }]];

    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidTouch)];
    [self.view addGestureRecognizer:tapRecognizer];

    [self registerKeyboardNotifications];
}

- (void)tapDidTouch {
    [self.view endEditing:YES];
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"[Legacy] Multi-line" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
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

@implementation MultilineTextFieldLegacyExample (UITextViewDelegate)

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@", textView.text);
}

@end

