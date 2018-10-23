//
//  UIViewController+GTBottomSheet.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>

@class GTCBottomSheetPresentationController;

/**
 Material Dialog UIViewController Category
 */
@interface UIViewController (GTBottomSheet)
/**
 The Material bottom sheet presentation controller that is managing the current view controller.

 @return nil if the view controller is not managed by a Material bottom sheet presentation
 controller.
 */
@property(nonatomic, nullable, readonly)
GTCBottomSheetPresentationController *gtc_bottomSheetPresentationController;

@end
