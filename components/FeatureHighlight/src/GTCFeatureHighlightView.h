//
//  GTCFeatureHighlightView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

@interface GTCFeatureHighlightView : UIView

@property(nonatomic, strong, nullable) UIColor *innerHighlightColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *outerHighlightColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, strong, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *titleColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, strong, nullable) UIFont *bodyFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *bodyColor UI_APPEARANCE_SELECTOR;

/*
 Indicates whether the view's contents should automatically update their font when the device’s
 UIContentSizeCategory changes.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 Default value is NO.
 */
@property(nonatomic, readwrite, setter=gtc_setAdjustsFontForContentSizeCategory:)
BOOL gtc_adjustsFontForContentSizeCategory UI_APPEARANCE_SELECTOR;

@end
