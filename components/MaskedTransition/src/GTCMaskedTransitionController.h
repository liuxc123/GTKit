//
//  GTCMaskedTransitionController.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 GTCMaskedTransitionController implements a custom view controller transition that animates the
 presented view controller using a mask reveal effect from a circular source view.

 The presenting view controller will typically store a reference to an instance of this class and
 assign it to the transitioningDelegate of a view controller prior to presenting it.

 With zero additional configuration, the transition will perform a fullscreen masked reveal
 presentation, with a slide down dismissal.

 It's possible to configure the presented view controller's frame by setting the
 calculateFrameOfPresentedView property. The provided block should return the desired frame of the
 presented view controller. When using calculateFrameOfPresentedView you must also change the
 modalPresentationStyle on the view controller to be presented to `UIModalPresentationCustom`.

 Once the view controller to be presented has been fully configured, you can present the view
 controller using any of the available view controller presentation APIs.
 */
@interface GTCMaskedTransitionController : NSObject <UIViewControllerTransitioningDelegate>
/**
 Initializes the transition controller with a given source view.
 */
- (nonnull instancetype)initWithSourceView:(nullable UIView *)sourceView;

/**
 Initializes the transition controller without a source view.

 Note that if no source view is available at the time of presentation, the transition will fall back
 to the default system presentation.
 */
- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 The view from which the next masked transition should emanate.
 */
@property(nonatomic, strong, nullable, readonly) UIView *sourceView;

/**
 An optional block that may be used to calculate the frame of the presented view controller's view.

 If provided, the block will be invoked once the presentation transition is initiated. The
 returned rect will be assigned to the presented view controller's frame.

 You must set the view controller-to-be-presented's modalPresentationStyle property to
 `UIModalPresentationCustom` in order to use this property.
 */
@property(nonatomic, copy, nullable)
CGRect (^calculateFrameOfPresentedView)(UIPresentationController * _Nonnull);

@end
