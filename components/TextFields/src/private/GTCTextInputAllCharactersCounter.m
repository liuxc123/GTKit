//
//  GTCTextInputAllCharactersCounter.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import "GTCTextInputCharacterCounter.h"

#import "GTCTextInput.h"

@implementation GTCTextInputAllCharactersCounter

- (NSUInteger)characterCountForTextInput:(UIView<GTCTextInput> *)textInput {
    return textInput.text.length;
}

@end
