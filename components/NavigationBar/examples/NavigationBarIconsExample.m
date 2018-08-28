//
//  NavigationBarIconsExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

#import "supplemental/NavigationBarTypicalUseExampleSupplemental.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTIcons+ic_arrow_back.h"
#import "GTIcons+ic_info.h"
#import "GTIcons+ic_reorder.h"
#import "GTNavigationBar.h"
#import "GTNavigationBar+ColorThemer.h"
#import "GTNavigationBar+TypographyThemer.h"
#import "supplemental/NavigationBarTypicalUseExampleSupplemental.h"

@interface NavigationBarIconsExample()

@property(nonatomic, strong) GTCNavigationBar *navigationBar;
@property(nonatomic, weak) UIBarButtonItem *trailingBarButtonItem;
@property(nonatomic, weak) UIBarButtonItem *leadingBarButtonItem;
@end

@implementation NavigationBarIconsExample

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

    self.title = @"Title";
    self.view.backgroundColor = UIColor.darkGrayColor;

    self.navigationBar = [[GTCNavigationBar alloc] initWithFrame:CGRectZero];
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationBar observeNavigationItem:self.navigationItem];
    [GTCNavigationBarTypographyThemer applyTypographyScheme:self.typographyScheme toNavigationBar:self.navigationBar];
    [GTCNavigationBarColorThemer applySemanticColorScheme:self.colorScheme toNavigationBar:self.navigationBar];
    [self.view addSubview:self.navigationBar];



    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]
                                       initWithImage:[[[GTCIcons imageFor_ic_arrow_back] gtf_imageWithHorizontallyFlippedOrientation] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(didTapBackButton)];

    UIBarButtonItem *leadingButtonItem = [[UIBarButtonItem alloc]
                                          initWithImage:[[GTCIcons imageFor_ic_info]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                          style:UIBarButtonItemStylePlain
                                          target:nil
                                          action:nil];
    UIBarButtonItem *trailingButtonItem = [[UIBarButtonItem alloc]
                                           initWithImage:[[GTCIcons imageFor_ic_reorder]
                                                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                           style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];

    self.leadingBarButtonItem = leadingButtonItem;
    self.trailingBarButtonItem = trailingButtonItem;
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.leftBarButtonItems = @[ leadingButtonItem ];
    self.navigationItem.rightBarButtonItem = trailingButtonItem;
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem = backButtonItem;


#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        [self.view.safeAreaLayoutGuide.topAnchor constraintEqualToAnchor:self.navigationBar.topAnchor].active = YES;
    } else {
#endif
        [NSLayoutConstraint constraintWithItem:self.topLayoutGuide
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.navigationBar
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0].active = YES;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    }
#endif
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_navigationBar);

    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navigationBar]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsBindings]];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation NavigationBarIconsExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Navigation Bar", @"Navigation Bar With Icons" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
