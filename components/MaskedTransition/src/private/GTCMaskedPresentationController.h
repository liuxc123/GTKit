//
//  GTCMaskedPresentationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <UIKit/UIKit.h>

@protocol GTMTransitionContext;

@interface GTCMaskedPresentationController : UIPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                  calculateFrameOfPresentedView:(CGRect (^)(UIPresentationController *))calculateFrameOfPresentedView
                                     sourceView:(UIView *)sourceView
NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
NS_UNAVAILABLE;

@property(nonatomic, strong) UIView *sourceView;
@property(nonatomic, strong) UIView *scrimView;

@end
