//
//  GTCNumericValueLabel.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

@interface GTCNumericValueLabel : UIView

/** The background color of the value label. */
@property(nonatomic, retain) UIColor *backgroundColor;

/** The text color of the label. */
@property(nonatomic, retain) UIColor *textColor;

/** The size of the value label. */
@property(nonatomic) CGFloat fontSize;

/** The text to be displayed in the value label. */
@property(nonatomic, copy) NSString *text;

@end
