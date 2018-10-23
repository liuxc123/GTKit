//
//  BottomSheetAutolayoutDummyViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "BottomSheetAutolayoutDummyViewController.h"

@implementation BottomSheetAutolayoutDummyViewController

- (IBAction)dismissButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
