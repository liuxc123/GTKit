//
//  NavigationBarIconsExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

#import "supplemental/NavigationBarTypicalUseExampleSupplemental.h"

#import <GTFInternationalization/GTFInternationalization.h>

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
    // Do any additional setup after loading the view.
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
