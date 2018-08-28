//
//  ButtonsTypicalUseExampleViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import "GTButtons.h"
#import "GTButtons+ButtonThemer.h"
#import "GTButtons+ColorThemer.h"
#import "GTButtons+TypographyThemer.h"
#import "GTTypography.h"

#import "supplemental/ButtonsTypicalUseSupplemental.h"

const CGSize kMinimumAccessibleButtonSize = {64.0, 48.0};

@interface ButtonsTypicalUseExampleViewController()
@property(nonatomic, strong) GTCFloatingButton *floatingButton;
@end

@implementation ButtonsTypicalUseExampleViewController

- (id)init {
    self = [super init];
    if (self) {
        self.colorScheme = [[GTCSemanticColorScheme alloc] init];
        self.typographyScheme = [[GTCTypographyScheme alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    GTCButtonScheme *buttonScheme = [[GTCButtonScheme alloc] init];
    buttonScheme.colorScheme = self.colorScheme;
    buttonScheme.typographyScheme = self.typographyScheme;

    // Contained button
    GTCButton *containedButton = [[GTCButton alloc] init];
    [containedButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCContainedButtonThemer applyScheme:buttonScheme toButton:containedButton];
    [containedButton sizeToFit];
    CGFloat containedButtonVerticalInset =
    MIN(0, -(kMinimumAccessibleButtonSize.height - CGRectGetHeight(containedButton.bounds)) / 2);
    CGFloat containedButtonHorizontalInset =
    MIN(0, -(kMinimumAccessibleButtonSize.width - CGRectGetWidth(containedButton.bounds)) / 2);
    containedButton.hitAreaInsets =
    UIEdgeInsetsMake(containedButtonVerticalInset, containedButtonHorizontalInset,
                     containedButtonVerticalInset, containedButtonHorizontalInset);
    [containedButton addTarget:self
                        action:@selector(didTap:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:containedButton];

    // Disabled contained button

    GTCButton *disabledContainedButton = [[GTCButton alloc] init];
    [disabledContainedButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCContainedButtonThemer applyScheme:buttonScheme toButton:disabledContainedButton];
    [disabledContainedButton sizeToFit];
    [disabledContainedButton addTarget:self
                                action:@selector(didTap:)
                      forControlEvents:UIControlEventTouchUpInside];
    [disabledContainedButton setEnabled:NO];
    [self.view addSubview:disabledContainedButton];

    // Text button

    GTCButton *textButton = [[GTCButton alloc] init];
    [GTCTextButtonThemer applyScheme:buttonScheme toButton:textButton];
    [textButton setTitle:@"Button" forState:UIControlStateNormal];
    [textButton sizeToFit];
    CGFloat textButtonVerticalInset =
    MIN(0, -(kMinimumAccessibleButtonSize.height - CGRectGetHeight(textButton.bounds)) / 2);
    CGFloat textButtonHorizontalInset =
    MIN(0, -(kMinimumAccessibleButtonSize.width - CGRectGetWidth(textButton.bounds)) / 2);
    textButton.hitAreaInsets =
    UIEdgeInsetsMake(textButtonVerticalInset, textButtonHorizontalInset,
                     textButtonVerticalInset, textButtonHorizontalInset);
    [textButton addTarget:self
                   action:@selector(didTap:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];

    // Disabled Text button

    GTCButton *disabledTextButton = [[GTCButton alloc] init];
    [disabledTextButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCTextButtonThemer applyScheme:buttonScheme toButton:disabledTextButton];
    [disabledTextButton sizeToFit];
    [disabledTextButton addTarget:self
                           action:@selector(didTap:)
                 forControlEvents:UIControlEventTouchUpInside];
    [disabledTextButton setEnabled:NO];
    [self.view addSubview:disabledTextButton];

    // Outlined button

    GTCButton *outlinedButton = [[GTCButton alloc] init];
    [outlinedButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCOutlinedButtonThemer applyScheme:buttonScheme toButton:outlinedButton];
    [outlinedButton sizeToFit];
    CGFloat outlineButtonVerticalInset =
    MIN(0, -(kMinimumAccessibleButtonSize.height - CGRectGetHeight(outlinedButton.frame)) / 2);
    CGFloat outlineButtonHorizontalInset =
    MIN(0, -(kMinimumAccessibleButtonSize.width - CGRectGetWidth(outlinedButton.frame)) / 2);
    outlinedButton.hitAreaInsets =
    UIEdgeInsetsMake(outlineButtonVerticalInset, outlineButtonHorizontalInset,
                     outlineButtonVerticalInset, outlineButtonHorizontalInset);
    [outlinedButton addTarget:self
                       action:@selector(didTap:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outlinedButton];

    // Disabled outlined button

    GTCButton *disabledOutlinedButton = [[GTCButton alloc] init];
    [disabledOutlinedButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCOutlinedButtonThemer applyScheme:buttonScheme toButton:disabledOutlinedButton];
    [disabledOutlinedButton sizeToFit];
    [disabledOutlinedButton addTarget:self
                               action:@selector(didTap:)
                     forControlEvents:UIControlEventTouchUpInside];
    [disabledOutlinedButton setEnabled:NO];
    [self.view addSubview:disabledOutlinedButton];

    // Floating action button

    self.floatingButton = [[GTCFloatingButton alloc] init];
    [self.floatingButton sizeToFit];
    [self.floatingButton addTarget:self
                            action:@selector(didTap:)
                  forControlEvents:UIControlEventTouchUpInside];
    self.floatingButton.mode = GTCFloatingButtonModeExpanded;
    self.floatingButton.imageLocation = GTCFloatingButtonImageLocationTrailing;
    UIImage *plusImage =
    [[UIImage imageNamed:@"Plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.floatingButton setImage:plusImage forState:UIControlStateNormal];
    [self.floatingButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCFloatingActionButtonThemer applyScheme:buttonScheme toButton:self.floatingButton];
    self.floatingButton.accessibilityLabel = @"Create";
    [self.view addSubview:self.floatingButton];



    // Img text button

    GTCFloatingButton *imgButton = [[GTCFloatingButton alloc] init];
    [imgButton setTitle:@"Button" forState:UIControlStateNormal];
    [imgButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
    [GTCContainedButtonThemer applyScheme:buttonScheme toButton:imgButton];
    imgButton.mode = GTCFloatingButtonModeExpanded;
    imgButton.imageLocation = GTCFloatingButtonImageLocationLeading;
    imgButton.imageTitleSpace = 0;
    [imgButton sizeToFit];
    [imgButton addTarget:self
                  action:@selector(didTap:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imgButton];

    self.buttons = @[
                     containedButton, disabledContainedButton, textButton, disabledTextButton, outlinedButton,
                     disabledOutlinedButton,self.floatingButton, imgButton];

    [self setupExampleViews];

    NSMutableArray *accessibilityElements = [@[] mutableCopy];
    for (NSUInteger index = 0; index < self.buttons.count; ++index) {
        [accessibilityElements addObject:self.labels[index]];
        [accessibilityElements addObject:self.buttons[index]];
    }
    self.view.accessibilityElements = [accessibilityElements copy];
}

- (void)setupExampleViews {
    UILabel *containedButtonLabel = [self addLabelWithText:@"Contained"];
    UILabel *disabledContainedButtonLabel = [self addLabelWithText:@"Disabled Contained"];
    UILabel *textButtonLabel = [self addLabelWithText:@"Text button"];
    UILabel *disabledTextButtonLabel = [self addLabelWithText:@"Disabled text button"];
    UILabel *outlinedButtonLabel = [self addLabelWithText:@"Outlined"];
    UILabel *disabledOutlinedButtonLabel = [self addLabelWithText:@"Disabled Outlined"];
    UILabel *floatingButtonLabel = [self addLabelWithText:@"Floating Action"];
    UILabel *imgButtonLabel = [self addLabelWithText:@"Img Action"];


    self.labels = @[
                    containedButtonLabel, disabledContainedButtonLabel, textButtonLabel, disabledTextButtonLabel,
                    outlinedButtonLabel, disabledOutlinedButtonLabel, floatingButtonLabel
                    , imgButtonLabel];
}


- (void)didTap:(id)sender {
    NSLog(@"%@ was tapped.", NSStringFromClass([sender class]));
    if (!UIAccessibilityIsVoiceOverRunning()) {
        if (sender == self.floatingButton) {
            [self.floatingButton
             collapse:YES
             completion:^{
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                                dispatch_get_main_queue(), ^{
                                    [self.floatingButton expand:YES completion:nil];
                                });
             }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (animated && !UIAccessibilityIsVoiceOverRunning()) {
        [self.floatingButton collapse:NO completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated && !UIAccessibilityIsVoiceOverRunning()) {
        [self.floatingButton expand:YES completion:nil];
    }
}

@end
