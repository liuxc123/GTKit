//
//  TextFieldStatesViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/5.
//

#import "GTTextFields.h"

#import <UIKit/UIKit.h>

@interface TextFieldStatesViewController : UIViewController

@property(nonatomic) Class selectedClass;
@property(nonatomic) NSArray<Class> *classes;

@property(nonatomic) id<GTCTextInputController> enabledController;
@property(nonatomic) GTCTextField *enabled;

@property(nonatomic) id<GTCTextInputController> disabledController;
@property(nonatomic) GTCTextField *disabled;

@property(nonatomic) id<GTCTextInputController> erroredController;
@property(nonatomic) GTCTextField *errored;

@property(nonatomic) id<GTCTextInputController> erroredDisabledController;
@property(nonatomic) GTCTextField *erroredDisabled;

@property(nonatomic) UIScrollView *scrollView;

@end

@implementation TextFieldStatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Text Field States";
    [self setupScrollView];

    self.enabled = [[GTCTextField alloc] initWithFrame:CGRectZero];
    self.enabled.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.enabled];

    self.disabled = [[GTCTextField alloc] initWithFrame:CGRectZero];
    self.disabled.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.disabled];
    self.disabled.enabled = NO;

    self.errored = [[GTCTextField alloc] initWithFrame:CGRectZero];
    self.errored.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.errored];

    self.erroredDisabled = [[GTCTextField alloc] initWithFrame:CGRectZero];
    self.erroredDisabled.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.erroredDisabled];
    self.erroredDisabled.enabled = NO;

    [self setupControllers];

    UIBarButtonItem *styleButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Style"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(styleButtonDidTouch:)];
    self.navigationItem.rightBarButtonItem = styleButton;

    [NSLayoutConstraint constraintWithItem:self.enabled
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeadingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:self.enabled
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:self.enabled
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;

    NSDictionary *views = @{
                            @"enabled" : self.enabled,
                            @"disabled" : self.disabled,
                            @"errored" : self.errored,
                            @"erroredDisabled" : self.erroredDisabled
                            };
    [NSLayoutConstraint
     activateConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[enabled]-[disabled]-[errored]-[erroredDisabled]"
      options:NSLayoutFormatAlignAllLeading |
      NSLayoutFormatAlignAllTrailing
      metrics:nil
      views:views]];

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint constraintWithItem:self.enabled
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView.contentLayoutGuide
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:20]
        .active = YES;
        [NSLayoutConstraint constraintWithItem:self.erroredDisabled
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView.contentLayoutGuide
                                     attribute:NSLayoutAttributeBottomMargin
                                    multiplier:1
                                      constant:-20]
        .active = YES;

    } else {
        [NSLayoutConstraint constraintWithItem:self.enabled
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:20]
        .active = YES;
        [NSLayoutConstraint constraintWithItem:self.erroredDisabled
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView
                                     attribute:NSLayoutAttributeBottomMargin
                                    multiplier:1
                                      constant:-20]
        .active = YES;
    }
#else
    [NSLayoutConstraint constraintWithItem:self.enabled
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:20]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:self.erroredDisabled
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeBottomMargin
                                multiplier:1
                                  constant:-20]
    .active = YES;
#endif
}

- (void)setupControllers {
    if (!self.classes) {
        // TODO: (larche) When more classes (other than full width) are added, put them in here so they
        // can be showcased.
        self.classes = @[
                         [GTCTextInputControllerFilled self], [GTCTextInputControllerOutlined self],
                         [GTCTextInputControllerUnderline self]
                         ];
        self.selectedClass = self.classes.firstObject;
    }

    if ([self.selectedClass conformsToProtocol:@protocol(GTCTextInputController)]) {
        self.enabledController =
        [(id<GTCTextInputController>)[self.selectedClass alloc] initWithTextInput:self.enabled];
        self.enabledController.placeholderText = @"Enabled";

        self.disabledController =
        [(id<GTCTextInputController>)[self.selectedClass alloc] initWithTextInput:self.disabled];
        self.disabledController.placeholderText = @"Disabled";

        self.erroredController =
        [(id<GTCTextInputController>)[self.selectedClass alloc] initWithTextInput:self.errored];
        self.erroredController.placeholderText = @"Errored";
        [self.erroredController setErrorText:@"Errored" errorAccessibilityValue:nil];

        self.erroredDisabledController = [(id<GTCTextInputController>)[self.selectedClass alloc]
                                          initWithTextInput:self.erroredDisabled];
        self.erroredDisabledController.placeholderText = @"Errored Disabled";
        [self.erroredDisabledController setErrorText:@"Errored Disabled" errorAccessibilityValue:nil];
    }
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = UIColor.whiteColor;

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

    CGFloat marginOffset = 16;
    UIEdgeInsets margins = UIEdgeInsetsMake(0, marginOffset, 0, marginOffset);
    self.scrollView.layoutMargins = margins;

    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidTouch)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)tapDidTouch {
    [self.view endEditing:YES];
}

- (void)styleButtonDidTouch:(UIBarButtonItem *)sender {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Controller Class"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];

    __weak TextFieldStatesViewController *weakSelf = self;
    for (Class class in self.classes) {
        NSString *title = NSStringFromClass(class);
        title = [title stringByReplacingOccurrencesOfString:@"GTCTextInputController" withString:@""];
        if ([class isEqual:self.selectedClass]) {
            title = [title stringByAppendingString:@" ✓"];
        }
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:title
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *__unused _Nonnull unusedAction) {
                                   weakSelf.selectedClass = class;
                                   [weakSelf setupControllers];
                               }];
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end

@implementation TextFieldStatesViewController (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"States" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

@end

