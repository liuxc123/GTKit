//
//  BottomSheetPresenterViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "BottomSheetPresenterViewController.h"

#import "GTButtons.h"

@implementation BottomSheetPresenterViewController {
    GTCButton *_button;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _colorScheme = [[GTCSemanticColorScheme alloc] init];
        _typographyScheme = [[GTCTypographyScheme alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _button = [[GTCButton alloc] initWithFrame:CGRectZero];
    [_button setTitle:@"Show Bottom Sheet" forState:UIControlStateNormal];
    _button.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_button addTarget:self
                action:@selector(presentBottomSheet)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_button sizeToFit];
    _button.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

- (void)presentBottomSheet {
    // implement in subclasses
}

@end

