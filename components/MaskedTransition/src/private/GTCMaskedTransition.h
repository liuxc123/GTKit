//
//  GTCMaskedTransition.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <UIKit/UIKit.h>

#import <GTMotionTransitioning/GTMotionTransitioning.h>

/**
 A masked transition will animate between two view controllers using an expanding mask effect.

 It is presently assumed that the mask will be a circular mask and that the source view is a view
 with equal width and height and a corner radius equal to half the view's width.
 */
@interface GTCMaskedTransition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Initializes the transition with the view from which the mask should emanate.

 @param sourceView The view from which the mask should emanate. The view is assumed to be in the
 presenting view controller's view hierarchy.
 */
- (nonnull instancetype)initWithSourceView:(nonnull UIView *)sourceView
                                 direction:(GTMTransitionDirection)direction
NS_DESIGNATED_INITIALIZER;

/**
 An optional block that may be used to calculate the frame of the presented view controller's view.

 If provided, the block will be invoked immediately before the transition is initiated and the
 returned rect will be assigned to the presented view controller's frame.
 */
@property(nonatomic, copy, nullable) CGRect (^calculateFrameOfPresentedView)(UIPresentationController * _Nonnull);

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
