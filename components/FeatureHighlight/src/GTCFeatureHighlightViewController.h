//
//  GTCFeatureHighlightViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

/** The default alpha for the outer highlight circle. */
extern const CGFloat kGTCFeatureHighlightOuterHighlightAlpha;

/**
 Completion block called when the feature highlight is dismissed either by calling |acceptFeature|
 or |rejectFeature| on the feature highlight or the user accepts or rejects the highlight by tapping
 somewhere on the highlight view.

 @param accepted Whether the highlight was accepted or rejected
 */
typedef void (^GTCFeatureHighlightCompletion)(BOOL accepted);

/**
 GTCFeatureHighlightViewController highlights an element of a UI to introduce features or
 functionality that a user hasn’t tried.

 https://material.io/guidelines/growth-communications/feature-discovery.html

 GTCFeatureHighlightViewController should be presented modally and dismissed using either
 |acceptFeature| or |rejectFeature|.

 While GTCFeatureHighlightViewController supports changing state while presented, it is not
 recommended as the design spec does not specify any patterns for that behavior.

 @note Due to a bug in the iOS simulator it is possible that the feature highlight will not render
 correctly in the simulator. If you're encountering issues make sure to test on device.
 */
@interface GTCFeatureHighlightViewController : UIViewController

/**
 Initializes the controller.

 @param highlightedView The highlight will be presented above the |center| of |highlightedView|
 @param displayedView Added to the highlight view and centered at the |center| of |highlightedView|
 @param completion The completion block called when the highlight is dismissed
 */
- (nonnull instancetype)initWithHighlightedView:(nonnull UIView *)highlightedView
                                    andShowView:(nonnull UIView *)displayedView
                                     completion:(nullable GTCFeatureHighlightCompletion)completion
NS_DESIGNATED_INITIALIZER;

/**
 Initializes the controller.

 This is a convience method for |initWithHighlightedView:andShowView:| with a snapshot of
 |highlightedView| sent as |displayedView|.

 @param highlightedView The highlight will be presented above the |center| of |highlightedView|
 */
- (nonnull instancetype)initWithHighlightedView:(nonnull UIView *)highlightedView
                                     completion:(nullable GTCFeatureHighlightCompletion)completion;

/**
 Feature Highlight controllers must be created with either initWithHighlightedView: constructor.
 */
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 Sets the text to be displayed as the header of the help text.

 The header is displayed above the body text.
 */
@property(nonatomic, copy, nullable) NSString *titleText;

/**
 Sets the text to be displayed as the body of the help text.

 The body is displayed below the header text. If you are only showing a single block of text without
 any header/body distinction, prefer |titleText|.
 */
@property(nonatomic, copy, nullable) NSString *bodyText;

/**
 Sets the color to be used for the outer highlight. Defaults to blue with an alpha of
 kGTCFeatureHighlightOuterHighlightAlpha.

 Alpha should be set to kGTCFeatureHighlightOuterHighlightAlpha.
 */
@property(nonatomic, strong, null_resettable) UIColor *outerHighlightColor;

/**
 Sets the color to be used for the inner highlight. Defaults to white.

 Should be opaque.
 */
@property(nonatomic, strong, null_resettable) UIColor *innerHighlightColor;

/**
 Sets the color to be used for the title text. If nil upon presentation, a color of sufficient
 contrast to the |outerHighlightColor| will be automatically chosen.

 Defaults to nil.
 */
@property(nonatomic, strong, nullable) UIColor *titleColor;

/**
 Sets the color to be used for the body text. If nil upon presentation, a color of sufficient
 contrast to the |outerHighlightColor| will be automatically chosen upon presentation.

 Defaults to nil.
 */
@property(nonatomic, strong, nullable) UIColor *bodyColor;

/**
 Sets the custom font to be used for the title text.

 Defaults to nil.
 */
@property(nonatomic, strong, nullable) UIFont *titleFont;

/**
 Sets the custom font to be used for the body text.

 Defaults to nil.
 */
@property(nonatomic, strong, nullable) UIFont *bodyFont;

/**
 Indicates whether the feature highlight contents should automatically update their font when the
 device’s UIContentSizeCategory changes.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 Default value is NO.
 */
@property(nonatomic, readwrite, setter=gtc_setAdjustsFontForContentSizeCategory:)
BOOL gtc_adjustsFontForContentSizeCategory UI_APPEARANCE_SELECTOR;

/**
 Dismisses the feature highlight using the 'accept' style dismissal animation and triggers the
 completion block with accepted set to YES.

 Identical to the user tapping on the inner highlight.
 */
- (void)acceptFeature;

/**
 Dismisses the feature highlight using the 'reject' style dismissal animation and triggers the
 completion block with accepted set to NO.

 Identical to the user tapping outside of the inner highlight.
 */
- (void)rejectFeature;

@end
