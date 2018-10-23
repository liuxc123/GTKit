//
//  GTCFormTextFieldCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormBaseCell.h"
#import <UIKit/UIKit.h>

extern NSString *const GTCFormTextFieldLengthPercentage;
extern NSString *const GTCFormTextFieldMaxNumberOfCharacters;

@interface GTCFormTextFieldCell : GTCFormBaseCell <GTCFormReturnKeyProtocol>

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) UITextField * textField;

@property (nonatomic) NSNumber *textFieldLengthPercentage;
@property (nonatomic) NSNumber *textFieldMaxNumberOfCharacters;

@end
