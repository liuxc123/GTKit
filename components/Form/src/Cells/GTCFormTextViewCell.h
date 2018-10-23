//
//  GTCFormTextViewCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCFormTextView.h"
#import "GTCFormBaseCell.h"
#import <UIKit/UIKit.h>

extern NSString *const GTCFormTextViewLengthPercentage;
extern NSString *const GTCFormTextViewMaxNumberOfCharacters;

@interface GTCFormTextViewCell : GTCFormBaseCell

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) GTCFormTextView * textView;

@property (nonatomic) NSNumber *textViewLengthPercentage;
@property (nonatomic) NSNumber *textViewMaxNumberOfCharacters;

@end
