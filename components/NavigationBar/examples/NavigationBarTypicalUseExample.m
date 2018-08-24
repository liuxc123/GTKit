//
//  NavigationBarTypicalUseExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

#import "GTNavigationBar.h"
#import "GTNavigationBar+ColorThemer.h"
#import "supplemental/NavigationBarTypicalUseExampleSupplemental.h"

@interface NavigationBarTypicalUseExample ()

@end

@implementation NavigationBarTypicalUseExample

- (id)init {
    self = [super init];
    if (self) {
        self.colorScheme = [[GTCSemanticColorScheme alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"aaa";
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
