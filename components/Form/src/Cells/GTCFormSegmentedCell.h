//
//  GTCFormSegmentedCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormBaseCell.h"

@interface GTCFormSegmentedCell : GTCFormBaseCell

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;

@end
