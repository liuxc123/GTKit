//
//  GTCAlertControllerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/12.
//

#import <UIKit/UIKit.h>

@interface GTCAlertControllerView : UIView

@property(nonatomic, strong, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *titleColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, assign) NSTextAlignment titleAlignment;
@property(nonatomic, strong, nullable) UIImage *titleIcon;
@property(nonatomic, strong, nullable) UIColor *titleIconTintColor;

@property(nonatomic, strong, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *messageColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, strong, nullable) UIFont *buttonFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *buttonColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) UIColor *buttonInkColor UI_APPEARANCE_SELECTOR;

@property(nonatomic, assign) CGFloat cornerRadius;

/*
 Indicates whether the view's contents should automatically update their font when the device’s
 UIContentSizeCategory changes.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.

 Default value is NO.
 */
@property(nonatomic, readwrite, setter=gtc_setAdjustsFontForContentSizeCategory:)
BOOL gtc_adjustsFontForContentSizeCategory UI_APPEARANCE_SELECTOR;

@end
