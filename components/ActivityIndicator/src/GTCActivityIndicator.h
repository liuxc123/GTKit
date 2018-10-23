//
//  GTCActivityIndicator.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

@interface GTCActivityIndicator : UIView

//- (id)initWithType:(GTCActivityIndicatorAnimationType)type;
//- (id)initWithType:(GTCActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
//- (id)initWithType:(GTCActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;
//
//@property (nonatomic) GTCActivityIndicatorAnimationType type;
//@property (nonatomic, strong) UIColor *tintColor;
//@property (nonatomic) CGFloat size;
//
///**
// Whether or not the activity indicator is currently animating.
// */
//@property(nonatomic, assign, getter=isAnimating) BOOL animating;
//
//
//- (void)startAnimating;
//- (void)stopAnimating;

@end


/**
 Delegate protocol for the GTCActivityIndicator.
 */
@protocol GTCActivityIndicatorDelegate <NSObject>

@optional
/**
 When stop is called, the spinner gracefully animates out using opacity and stroke width.
 This method is called after that fade-out animation completes.

 @param activityIndicator Caller
 */
- (void)activityIndicatorAnimationDidFinish:(nonnull GTCActivityIndicator *)activityIndicator;

/**
 When setIndicatorMode:animated: is called the spinner animates the transition from the current
 mode to the new mode. This method is called after the animation completes or immediately if no
 animation is requested.

 @param activityIndicator Caller
 */
- (void)activityIndicatorModeTransitionDidFinish:(nonnull GTCActivityIndicator *)activityIndicator;

@end
