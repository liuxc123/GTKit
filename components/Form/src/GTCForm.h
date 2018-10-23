//
//  GTCForm.h
//  Pods-GTForm_Example
//
//  Created by liuxc on 2018/10/23.
//

#import <Foundation/Foundation.h>

//Descriptors
#import "GTCFormDescriptor.h"
#import "GTCFormRowDescriptor.h"
#import "GTCFormSectionDescriptor.h"

// Categories
#import "NSArray+GTCFormAdditions.h"
#import "NSExpression+GTCFormAdditions.h"
#import "NSObject+GTCFormAdditions.h"
#import "NSPredicate+GTCFormAdditions.h"
#import "NSString+GTCFormAdditions.h"
#import "UIView+GTCFormAdditions.h"
#import "UIView+GTCFrame.h"

//helpers
#import "GTCFormOptionsObject.h"

//Controllers
#import "GTCFormOptionsViewController.h"
#import "GTCFormViewController.h"

//Protocols
#import "GTCFormDescriptorCell.h"
#import "GTCFormInlineRowDescriptorCell.h"
#import "GTCFormRowDescriptorViewController.h"

//Cells
#import "GTCFormBaseCell.h"
#import "GTCFormButtonCell.h"
#import "GTCFormCheckCell.h"
#import "GTCFormDateCell.h"
#import "GTCFormDatePickerCell.h"
#import "GTCFormInlineSelectorCell.h"
#import "GTCFormLeftRightSelectorCell.h"
#import "GTCFormPickerCell.h"
#import "GTCFormRightDetailCell.h"
#import "GTCFormRightImageButton.h"
#import "GTCFormSegmentedCell.h"
#import "GTCFormSelectorCell.h"
#import "GTCFormSliderCell.h"
#import "GTCFormStepCounterCell.h"
#import "GTCFormSwitchCell.h"
#import "GTCFormTextFieldCell.h"
#import "GTCFormTextViewCell.h"
#import "GTCFormImageCell.h"

//Validation
#import "GTCFormRegexValidator.h"


extern NSString *const GTCFormRowDescriptorTypeAccount;
extern NSString *const GTCFormRowDescriptorTypeBooleanCheck;
extern NSString *const GTCFormRowDescriptorTypeBooleanSwitch;
extern NSString *const GTCFormRowDescriptorTypeButton;
extern NSString *const GTCFormRowDescriptorTypeCountDownTimer;
extern NSString *const GTCFormRowDescriptorTypeCountDownTimerInline;
extern NSString *const GTCFormRowDescriptorTypeDate;
extern NSString *const GTCFormRowDescriptorTypeDateInline;
extern NSString *const GTCFormRowDescriptorTypeDatePicker;
extern NSString *const GTCFormRowDescriptorTypeDateTime;
extern NSString *const GTCFormRowDescriptorTypeDateTimeInline;
extern NSString *const GTCFormRowDescriptorTypeDecimal;
extern NSString *const GTCFormRowDescriptorTypeEmail;
extern NSString *const GTCFormRowDescriptorTypeImage;
extern NSString *const GTCFormRowDescriptorTypeInfo;
extern NSString *const GTCFormRowDescriptorTypeInteger;
extern NSString *const GTCFormRowDescriptorTypeMultipleSelector;
extern NSString *const GTCFormRowDescriptorTypeMultipleSelectorPopover;
extern NSString *const GTCFormRowDescriptorTypeName;
extern NSString *const GTCFormRowDescriptorTypeNumber;
extern NSString *const GTCFormRowDescriptorTypePassword;
extern NSString *const GTCFormRowDescriptorTypePhone;
extern NSString *const GTCFormRowDescriptorTypePicker;
extern NSString *const GTCFormRowDescriptorTypeSelectorActionSheet;
extern NSString *const GTCFormRowDescriptorTypeSelectorAlertView;
extern NSString *const GTCFormRowDescriptorTypeSelectorLeftRight;
extern NSString *const GTCFormRowDescriptorTypeSelectorPickerView;
extern NSString *const GTCFormRowDescriptorTypeSelectorPickerViewInline;
extern NSString *const GTCFormRowDescriptorTypeSelectorPopover;
extern NSString *const GTCFormRowDescriptorTypeSelectorPush;
extern NSString *const GTCFormRowDescriptorTypeSelectorSegmentedControl;
extern NSString *const GTCFormRowDescriptorTypeSlider;
extern NSString *const GTCFormRowDescriptorTypeStepCounter;
extern NSString *const GTCFormRowDescriptorTypeText;
extern NSString *const GTCFormRowDescriptorTypeTextView;
extern NSString *const GTCFormRowDescriptorTypeTime;
extern NSString *const GTCFormRowDescriptorTypeTimeInline;
extern NSString *const GTCFormRowDescriptorTypeTwitter;
extern NSString *const GTCFormRowDescriptorTypeURL;
extern NSString *const GTCFormRowDescriptorTypeZipCode;


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending
