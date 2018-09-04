//
//  GTCTextFieldColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <Foundation/Foundation.h>

#import "GTColorScheme.h"
#import "GTTextFields.h"

/**
 The Material Design color system's text field themer.
 */
@interface GTCTextFieldColorThemer : NSObject

/**
 Applies a color scheme to theme GTCTextField in GTCTextInputController.

 @param colorScheme The color scheme to apply.
 @param textInputController A GTCTextInputController instance to apply a color scheme.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
           toTextInputController:(nonnull id<GTCTextInputController>)textInputController;

/**
 Applies a color scheme to GTCTextField for all instances of the class
 using the default color class properties.

 @param colorScheme The color scheme to apply.
 @param textInputControllerClass A Class that conforms to GTCTextInputController (at least.)
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
toAllTextInputControllersOfClass:(nonnull Class<GTCTextInputController>)textInputControllerClass
NS_SWIFT_NAME(apply(_:toAllControllersOfClass:));

/**
 Applies a color scheme to theme an GTCTextField.

 @param colorScheme The color scheme to apply.
 @param textInput A GTCTextInput instance to apply a color scheme.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                     toTextInput:(nonnull id<GTCTextInput>)textInput;

@end
