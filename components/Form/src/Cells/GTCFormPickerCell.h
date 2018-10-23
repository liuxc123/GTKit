//
//  GTCFormPickerCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCForm.h"
#import "GTCFormBaseCell.h"

@interface GTCFormPickerCell : GTCFormBaseCell <GTCFormInlineRowDescriptorCell>

@property (nonatomic) UIPickerView * pickerView;

@end
