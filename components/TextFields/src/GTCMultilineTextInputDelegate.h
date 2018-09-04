//
//  GTCMultilineTextInputDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

/**
 GTCMultilineTextInputDelegate has a method common to the UITextFieldDelegate protocol but not
 found in UITextViewDelegate.
 */

#import <UIKit/UIKit.h>
#import "GTCTextInput.h"

@protocol GTCMultilineTextInputDelegate <NSObject>

@optional

/**
 Called when the clear button is tapped.

 Return YES to set the textfield's .text to nil.
 Return NO to ignore and keep the .text.

 A direct mirror of UITextFieldDelegate's textFieldShouldClear:.

 UITextView's don't require this method already because they do not have clear buttons. The clear
 button in GTCMultilineTextField is custom.
 */
- (BOOL)multilineTextFieldShouldClear:(UIView<GTCTextInput> *)textField;

@end
