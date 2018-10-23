//
//  UIViewController+GTDialogs.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/11.
//

#import <UIKit/UIKit.h>

@class GTCDialogPresentationController;

@interface UIViewController (GTDialogs)

/**
 The Material dialog presentation controller that is managing the current view controller.

 @return nil if the view controller is not managed by a Material dialog presentaiton controller.
 */
@property(nonatomic, nullable, readonly) GTCDialogPresentationController *gtc_dialogPresentationController;

@end
