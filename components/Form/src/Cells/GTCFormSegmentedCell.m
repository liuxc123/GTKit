//
//  GTCFormSegmentedCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormSegmentedCell.h"

#import "NSObject+GTCFormAdditions.h"
#import "UIView+GTCFormAdditions.h"

@interface GTCFormSegmentedCell()

@property NSMutableArray * dynamicCustomConstraints;

@end

@implementation GTCFormSegmentedCell

@synthesize textLabel = _textLabel;
@synthesize segmentedControl = _segmentedControl;

#pragma mark - GTCFormDescriptorCell

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addSubview:self.textLabel];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)update
{
    [super update];
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    [self updateSegmentedControl];
    self.segmentedControl.selectedSegmentIndex = [self selectedIndex];
    self.segmentedControl.enabled = !self.rowDescriptor.isDisabled;
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.textLabel && [keyPath isEqualToString:@"text"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

#pragma mark - Properties

-(UISegmentedControl *)segmentedControl
{
    if (_segmentedControl) return _segmentedControl;

    _segmentedControl = [UISegmentedControl autolayoutView];
    [_segmentedControl setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    return _segmentedControl;
}

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    [_textLabel setContentCompressionResistancePriority:500
                                                forAxis:UILayoutConstraintAxisHorizontal];
    return _textLabel;
}

#pragma mark - Action

-(void)valueChanged
{
    self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - Helper

-(NSArray *)getItems
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (id option in self.rowDescriptor.selectorOptions)
        [result addObject:[option displayText]];
    return result;
}

-(void)updateSegmentedControl
{
    [self.segmentedControl removeAllSegments];

    [[self getItems] enumerateObjectsUsingBlock:^(id object, NSUInteger idex, __unused BOOL *stop){
        [self.segmentedControl insertSegmentWithTitle:[object displayText] atIndex:idex animated:NO];
    }];
}

-(NSInteger)selectedIndex
{
    if (self.rowDescriptor.value){
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option valueData] isEqual:[self.rowDescriptor.value valueData]]){
                return [self.rowDescriptor.selectorOptions indexOfObject:option];
            }
        }
    }
    return UISegmentedControlNoSegment;
}

#pragma mark - Layout Constraints


-(void)updateConstraints
{
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
    self.dynamicCustomConstraints = [NSMutableArray array];
    NSDictionary * views = @{@"segmentedControl": self.segmentedControl, @"textLabel": self.textLabel};
    if (self.textLabel.text.length > 0){
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-16-[segmentedControl]-|"
                                                                                                   options:NSLayoutFormatAlignAllCenterY
                                                                                                   metrics:0
                                                                                                     views:views]];
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[textLabel]-12-|"
                                                                                                   options:0
                                                                                                   metrics:0
                                                                                                     views:views]];

    }
    else{
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[segmentedControl]-|"
                                                                                                   options:NSLayoutFormatAlignAllCenterY
                                                                                                   metrics:0
                                                                                                     views:views]];
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[segmentedControl]-|"
                                                                                                   options:0
                                                                                                   metrics:0
                                                                                                     views:views]];

    }
    [self.contentView addConstraints:self.dynamicCustomConstraints];
    [super updateConstraints];
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

@end
