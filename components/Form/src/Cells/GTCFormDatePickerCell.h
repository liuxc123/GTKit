//
//  GTCFormDatePickerCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCForm.h"
#import "GTCFormBaseCell.h"

#import <UIKit/UIKit.h>

@interface GTCFormDatePickerCell : GTCFormBaseCell <GTCFormInlineRowDescriptorCell>

@property (nonatomic, readonly) UIDatePicker * datePicker;

@end
