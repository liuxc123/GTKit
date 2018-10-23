//
//  GTCFormDateCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormDateCell.h"
#import "GTCForm.h"
#import "GTCFormRowDescriptor.h"

@interface GTCFormDateCell()

@property (nonatomic) UIDatePicker *datePicker;

@end


@implementation GTCFormDateCell
{
    UIColor * _beforeChangeColor;
    NSDateFormatter *_dateFormatter;
}

- (UIView *)inputView
{
    if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDate] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTime] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateTime] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimer]){
        if (self.rowDescriptor.value){
            [self.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimer]];
        }
        [self setModeToDatePicker:self.datePicker];
        return self.datePicker;
    }
    return [super inputView];
}

- (BOOL)canBecomeFirstResponder
{
    return !self.rowDescriptor.isDisabled;
}

-(BOOL)becomeFirstResponder
{
    if (self.isFirstResponder){
        return [super becomeFirstResponder];
    }
    _beforeChangeColor = self.detailTextLabel.textColor;
    BOOL result = [super becomeFirstResponder];
    if (result){
        if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimerInline])
        {
            NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
            NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:(selectedRowPath.row + 1) inSection:selectedRowPath.section];
            GTCFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
            GTCFormRowDescriptor * datePickerRowDescriptor = [GTCFormRowDescriptor formRowDescriptorWithTag:nil rowType:GTCFormRowDescriptorTypeDatePicker];
            GTCFormDatePickerCell * datePickerCell = (GTCFormDatePickerCell *)[datePickerRowDescriptor cellForFormController:self.formViewController];
            [self setModeToDatePicker:datePickerCell.datePicker];
            if (self.rowDescriptor.value){
                [datePickerCell.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimerInline]];
            }
            NSAssert([datePickerCell conformsToProtocol:@protocol(GTCFormInlineRowDescriptorCell)], @"inline cell must conform to GTCFormInlineRowDescriptorCell");
            UITableViewCell<GTCFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<GTCFormInlineRowDescriptorCell> *)datePickerCell;
            inlineCell.inlineRowDescriptor = self.rowDescriptor;

            [formSection addFormRow:datePickerRowDescriptor afterRow:self.rowDescriptor];
            [self.formViewController ensureRowIsVisible:datePickerRowDescriptor];
        }
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimerInline])
    {
        NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
        NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
        GTCFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
        BOOL result = [super resignFirstResponder];
        if ([nextFormRow.rowType isEqualToString:GTCFormRowDescriptorTypeDatePicker]){
            [self.rowDescriptor.sectionDescriptor removeFormRow:nextFormRow];
        }
        return result;
    }
    return [super resignFirstResponder];
}

#pragma mark - GTCFormDescriptorCell

-(void)configure
{
    [super configure];
    self.formDatePickerMode = GTCFormDateDatePickerModeGetFromRowDescriptor;
    _dateFormatter = [[NSDateFormatter alloc] init];
}

-(void)update
{
    [super update];
    self.accessoryType =  UITableViewCellAccessoryNone;
    self.editingAccessoryType =  UITableViewCellAccessoryNone;
    [self.textLabel setText:self.rowDescriptor.title];
    self.selectionStyle = self.rowDescriptor.isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
}

-(void)formDescriptorCellDidSelectedWithFormController:(GTCFormViewController *)controller
{
    [self.formViewController.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return [self canBecomeFirstResponder];
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    if ([self isFirstResponder]){
        return [self resignFirstResponder];
    }
    return [self becomeFirstResponder];

}

-(void)highlight
{
    [super highlight];
    self.detailTextLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    self.detailTextLabel.textColor = _beforeChangeColor;
}

#pragma mark - helpers

-(NSString *)valueDisplayText
{
    return self.rowDescriptor.value ? [self formattedDate:self.rowDescriptor.value] : self.rowDescriptor.noValueDisplayText;
}


- (NSString *)formattedDate:(NSDate *)date
{
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
        if (tranformedValue){
            return tranformedValue;
        }
    }
    if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDate] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateInline]){
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
        return [_dateFormatter stringFromDate:date];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTime] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTimeInline]){
        _dateFormatter.dateStyle = NSDateFormatterNoStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        return [_dateFormatter stringFromDate:date];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimer] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimerInline]){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDateComponents *time = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        return [NSString stringWithFormat:@"%ld%@ %ldmin", (long)[time hour], (long)[time hour] == 1 ? @"hour" : @"hours", (long)[time minute]];
    }
    _dateFormatter.dateStyle = NSDateFormatterShortStyle;
    _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [_dateFormatter stringFromDate:date];
}

-(void)setModeToDatePicker:(UIDatePicker *)datePicker
{
    if ((([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDate]) && self.formDatePickerMode == GTCFormDateDatePickerModeGetFromRowDescriptor) || self.formDatePickerMode == GTCFormDateDatePickerModeDate){
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ((([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTime]) && self.formDatePickerMode == GTCFormDateDatePickerModeGetFromRowDescriptor) || self.formDatePickerMode == GTCFormDateDatePickerModeTime){
        datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimer] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimerInline]){
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    else{
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }

    if (self.minuteInterval)
        datePicker.minuteInterval = self.minuteInterval;

    if (self.minimumDate)
        datePicker.minimumDate = self.minimumDate;

    if (self.maximumDate)
        datePicker.maximumDate = self.maximumDate;

    if (self.locale) {
        datePicker.locale = self.locale;
    }
}

#pragma mark - Properties

-(UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;
    _datePicker = [[UIDatePicker alloc] init];
    [self setModeToDatePicker:_datePicker];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _datePicker;
}

-(void)setLocale:(NSLocale *)locale
{
    _locale = locale;
    _dateFormatter.locale = locale;
}

#pragma mark - Target Action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.rowDescriptor.value = sender.date;
    [self.formViewController updateFormRow:self.rowDescriptor];
}

-(void)setFormDatePickerMode:(GTCFormDateDatePickerMode)formDatePickerMode
{
    _formDatePickerMode = formDatePickerMode;
    if ([self isFirstResponder]){
        if ([self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeDateTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTCFormRowDescriptorTypeCountDownTimerInline])
        {
            NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
            NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
            GTCFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
            if ([nextFormRow.rowType isEqualToString:GTCFormRowDescriptorTypeDatePicker]){
                GTCFormDatePickerCell * datePickerCell = (GTCFormDatePickerCell *)[nextFormRow cellForFormController:self.formViewController];
                [self setModeToDatePicker:datePickerCell.datePicker];
            }
        }
    }
}


@end
