//
//  GTCTextInputCharacterCounter.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import <UIKit/UIKit.h>

@protocol GTCTextInput;

/**
 Protocol for custom character counters.

 Instead of relying on the default character count which is naive (counts each character regardless
 of context), this object can instead choose to do sophisticated counting (ie: ignoring whitespace,
 ignoring url strings, ignoring usernames, etc).
 */
@protocol GTCTextInputCharacterCounter <NSObject>

/**
 Returns the count of characters for the text field.

 @param textInput   The text input to count from.

 @return            The count of characters.
 */
- (NSUInteger)characterCountForTextInput:(nullable UIView<GTCTextInput> *)textInput;

@end

/**
 The default character counter.

 GTCTextInputAllCharactersCounter is naive (counts each character regardless of context).
 */
@interface GTCTextInputAllCharactersCounter : NSObject <GTCTextInputCharacterCounter>

@end
