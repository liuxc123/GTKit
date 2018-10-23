//
//  GTCFormDateCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormBaseCell.h"

typedef NS_ENUM(NSUInteger, GTCFormDateDatePickerMode) {
    GTCFormDateDatePickerModeGetFromRowDescriptor,
    GTCFormDateDatePickerModeDate,
    GTCFormDateDatePickerModeDateTime,
    GTCFormDateDatePickerModeTime
};

@interface GTCFormDateCell : GTCFormBaseCell

@property (nonatomic) GTCFormDateDatePickerMode formDatePickerMode;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;
@property (nonatomic) NSInteger minuteInterval;
@property (nonatomic) NSLocale *locale;

@end
