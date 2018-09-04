//
//  GTCTextFieldTypographyThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTTextFields.h"
#import "GTTypographyScheme.h"

/**
 The Material Design typography system's text field themer.
 */
@interface GTCTextFieldTypographyThemer : NSObject

/**
 Applies a typography scheme's properties to a text input controller.

 @param typographyScheme The color scheme to apply to the component instance.
 @param textInputController A component instance to which the color scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
        toTextInputController:(nonnull id<GTCTextInputController>)textInputController;

/**
 Applies a typography scheme to theme an specific class type responding to GTCTextInputController
 protocol. Will not apply to existing instances.

 @param typographyScheme The typography scheme that applies to a GTCTextInputController.
 @param textInputControllerClass A GTCTextInputController class that typography scheme will be
 applied to.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
toAllTextInputControllersOfClass:(nonnull Class<GTCTextInputController>)textInputControllerClass
NS_SWIFT_NAME(apply(_:toAllControllersOfClass:));

/**
 Applies a typography scheme's properties to a text input.

 @param typographyScheme The color scheme to apply to the component instance.
 @param textInput A component instance to which the color scheme should be applied.
 */
+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
                  toTextInput:(nonnull id<GTCTextInput>)textInput;

@end
