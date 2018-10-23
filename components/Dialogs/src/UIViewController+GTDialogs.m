//
//  UIViewController+GTDialogs.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/11.
//

#import "UIViewController+GTDialogs.h"

#import "GTCDialogPresentationController.h"

@implementation UIViewController (GTDialogs)

- (GTCDialogPresentationController *)gtc_dialogPresentationController {
    id presentationController = self.presentationController;
    if ([presentationController isKindOfClass:[GTCDialogPresentationController class]]) {
        return (GTCDialogPresentationController *)presentationController;
    }

    return nil;
}
@end
