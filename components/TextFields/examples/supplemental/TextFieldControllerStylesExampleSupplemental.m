//
//  TextFieldControllerStylesExampleSupplemental.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <UIKit/UIKit.h>

#import "TextFieldControllerStylesExampleSupplemental.h"

@implementation TextFieldControllerStylesExample (Supplemental)

- (void)setupExampleViews {
    [self setupScrollView];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

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

@end

@implementation TextFieldControllerStylesExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"Controller Styles" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return YES;
}

@end
