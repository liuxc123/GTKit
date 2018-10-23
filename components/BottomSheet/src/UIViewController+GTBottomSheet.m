//
//  UIViewController+GTBottomSheet.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "UIViewController+GTBottomSheet.h"

#import "GTCBottomSheetPresentationController.h"

@implementation UIViewController (GTBottomSheet)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (GTCBottomSheetPresentationController *)gtc_bottomSheetPresentationController {
    id presentationController = self.presentationController;
    if ([presentationController isKindOfClass:[GTCBottomSheetPresentationController class]]) {
        return (GTCBottomSheetPresentationController *)presentationController;
    }
#pragma clang diagnostic pop

    return nil;
}
@end
