//
//  AppBarImageryExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import <UIKit/UIKit.h>

#import "GTAppBar.h"
#import "GTAppBar+ColorThemer.h"

@interface AppBarImageryExample : UITableViewController
@property(nonatomic, strong) GTCAppBarViewController *appBarViewController;
@property(nonatomic, strong) GTCSemanticColorScheme *colorScheme;
@end

@implementation AppBarImageryExample

- (void)dealloc {
    // Required for pre-iOS 11 devices because we've enabled observesTrackingScrollViewScrollEvents.
    self.appBarViewController.headerView.trackingScrollView = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        _colorScheme = [[GTCSemanticColorScheme alloc] init];

        _appBarViewController = [[GTCAppBarViewController alloc] init];

        // Behavioral flags.
        _appBarViewController.inferTopSafeAreaInsetFromViewController = YES;
        _appBarViewController.headerView.minMaxHeightIncludesSafeArea = NO;

        self.title = @"Imagery";

        [self addChildViewController:_appBarViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create our custom image view and add it to the header view.
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:
                              [UIImage imageNamed:@"gtc_theme"
                                         inBundle:[NSBundle bundleForClass:[AppBarImageryExample class]]
                    compatibleWithTraitCollection:nil]];
    imageView.frame = self.appBarViewController.headerView.bounds;

    // Ensure that the image view resizes in reaction to the header view bounds changing.
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.appBarViewController.headerView insertSubview:imageView atIndex:0];

    imageView.contentMode = UIViewContentModeScaleToFill;

    imageView.clipsToBounds = YES;

    [GTCAppBarColorThemer applyColorScheme:self.colorScheme toAppBarViewController:self.appBarViewController];

    self.appBarViewController.navigationBar.backgroundColor = [UIColor clearColor];

    self.appBarViewController.headerView.maximumHeight = 300;

    self.appBarViewController.headerView.observesTrackingScrollViewScrollEvents = YES;

    self.appBarViewController.headerView.trackingScrollView = self.tableView;

    [self.view addSubview:self.appBarViewController.view];
    [self.appBarViewController didMoveToParentViewController:self];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // Ensure that our status bar is white.
    return UIStatusBarStyleLightContent;
}

@end

@implementation AppBarImageryExample (TypicalUse)

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end

@implementation AppBarImageryExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"App Bar", @"Imagery" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

+ (BOOL)catalogIsPresentable {
    return YES;
}

@end

#pragma mark - Typical application code (not Material-specific)

@implementation AppBarImageryExample (UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
