//
//  BottomSheetTypicalUseExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>

#import "GTAppBar+ColorThemer.h"
#import "GTAppBar+TypographyThemer.h"
#import "GTAppBar.h"
#import "GTBottomSheet.h"
#import "GTBottomSheet+ShapeThemer.h"
#import "supplemental/BottomSheetSupplemental.h"
#import "supplemental/BottomSheetDummyCollectionViewController.h"

@interface BottomSheetTypicalUseExample ()
@property(nonatomic, strong) GTCShapeScheme *shapeScheme;
@end

@implementation BottomSheetTypicalUseExample

- (instancetype)init {
    self = [super init];
    if (self) {
        _shapeScheme = [[GTCShapeScheme alloc] init];
    }
    return self;
}

- (void)presentBottomSheet {

    BottomSheetDummyCollectionViewController *viewController = [[BottomSheetDummyCollectionViewController alloc] initWithNumItems:102];
    viewController.title = @"Bottom sheet example";

    GTCAppBarContainerViewController *container = [[GTCAppBarContainerViewController alloc] initWithContentViewController:viewController];
    container.preferredContentSize = CGSizeMake(500, 400);
    container.appBarViewController.headerView.trackingScrollView = viewController.collectionView;
    container.topLayoutGuideAdjustmentEnabled = YES;


    [GTCAppBarColorThemer applyColorScheme:self.colorScheme toAppBarViewController:container.appBarViewController];
    [GTCAppBarTypographyThemer applyTypographyScheme:self.typographyScheme toAppBarViewController:container.appBarViewController];


    GTCBottomSheetController *bottomSheet = [[GTCBottomSheetController alloc] initWithContentViewController:container];

    [GTCBottomSheetControllerShapeThemer applyShapeScheme:self.shapeScheme toBottomSheetController:bottomSheet];

    bottomSheet.isScrimAccessibilityElement = NO;
    bottomSheet.scrimAccessibilityLabel = @"Close";
    bottomSheet.trackingScrollView = viewController.collectionView;
    [self presentViewController:bottomSheet animated:YES completion:nil];
}

@end
