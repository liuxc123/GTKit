//
//  GTCFormDescriptorCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>

@class GTCFormRowDescriptor;
@class GTCFormViewController;

@protocol GTCFormDescriptorCell <NSObject>

@required

@property (nonatomic, weak) GTCFormRowDescriptor * rowDescriptor;
-(void)configure;
-(void)update;

@optional

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(GTCFormRowDescriptor *)rowDescriptor;
-(BOOL)formDescriptorCellCanBecomeFirstResponder;
-(BOOL)formDescriptorCellBecomeFirstResponder;
-(void)formDescriptorCellDidSelectedWithFormController:(GTCFormViewController *)controller;
-(NSString *)formDescriptorHttpParameterName;


-(void)highlight;
-(void)unhighlight;

@end
