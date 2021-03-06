//
//  GTCFormSwitchCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormSwitchCell.h"
#import "GTCFormRowDescriptor.h"

@implementation GTCFormSwitchCell

#pragma mark - GTCFormDescriptorCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[UISwitch alloc] init];
    self.editingAccessoryView = self.accessoryView;
    [self.switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.switchControl.on = [self.rowDescriptor.value boolValue];
    self.switchControl.enabled = !self.rowDescriptor.isDisabled;
}

- (UISwitch *)switchControl
{
    return (UISwitch *)self.accessoryView;
}

- (void)valueChanged
{
    self.rowDescriptor.value = @(self.switchControl.on);
}


@end
