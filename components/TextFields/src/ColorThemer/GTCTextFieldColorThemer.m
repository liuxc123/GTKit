//
//  GTCTextFieldColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextFieldColorThemer.h"

@implementation GTCTextFieldColorThemer

+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
           toTextInputController:(id<GTCTextInputController>)textInputController {
    UIColor *onSurface87Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.87f];
    UIColor *onSurface60Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.60f];
    textInputController.activeColor = colorScheme.primaryColor;
    textInputController.errorColor = colorScheme.errorColor;
    textInputController.normalColor = onSurface87Opacity;
    textInputController.inlinePlaceholderColor = onSurface60Opacity;
    textInputController.trailingUnderlineLabelTextColor = onSurface60Opacity;
    textInputController.leadingUnderlineLabelTextColor = onSurface60Opacity;

    if ([textInputController
         conformsToProtocol:@protocol(GTCTextInputControllerFloatingPlaceholder)]) {
        id<GTCTextInputControllerFloatingPlaceholder> textInputControllerFloatingPlaceholder =
        (id<GTCTextInputControllerFloatingPlaceholder>)textInputController;
        UIColor *primary87Opacity = [colorScheme.primaryColor colorWithAlphaComponent:0.87f];
        textInputControllerFloatingPlaceholder.floatingPlaceholderNormalColor = onSurface60Opacity;
        textInputControllerFloatingPlaceholder.floatingPlaceholderActiveColor = primary87Opacity;
    }
}

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                     toTextInput:(nonnull id<GTCTextInput>)textInput {
    UIColor *onSurface87Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.87f];
    UIColor *onSurface60Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.60f];
    textInput.cursorColor = colorScheme.primaryColor;
    textInput.textColor = onSurface87Opacity;
    textInput.placeholderLabel.textColor = onSurface60Opacity;
    textInput.trailingUnderlineLabel.textColor = onSurface60Opacity;
    textInput.leadingUnderlineLabel.textColor = onSurface60Opacity;
}

// TODO: (larche) Drop this if defined and the pragmas when we drop Xcode 8 support.
// This is to silence a warning that doesn't appear in Xcode 9 when you use Class as an object.
#if !defined(__IPHONE_11_0)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
#endif
+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
toAllTextInputControllersOfClass:(Class<GTCTextInputController>)textInputControllerClass {
    UIColor *onSurface87Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.87f];
    UIColor *onSurface60Opacity = [colorScheme.onSurfaceColor colorWithAlphaComponent:0.60f];
    [textInputControllerClass setActiveColorDefault:colorScheme.primaryColor];
    [textInputControllerClass setErrorColorDefault:colorScheme.errorColor];
    [textInputControllerClass setNormalColorDefault:onSurface87Opacity];
    [textInputControllerClass setInlinePlaceholderColorDefault:onSurface60Opacity];
    [textInputControllerClass setTrailingUnderlineLabelTextColorDefault:onSurface60Opacity];
    [textInputControllerClass setLeadingUnderlineLabelTextColorDefault:onSurface60Opacity];

    if ([textInputControllerClass
         conformsToProtocol:@protocol(GTCTextInputControllerFloatingPlaceholder)]) {
        Class<GTCTextInputControllerFloatingPlaceholder> textInputControllerFloatingPlaceholderClass =
        (Class<GTCTextInputControllerFloatingPlaceholder>)textInputControllerClass;
        UIColor *primary87Opacity = [colorScheme.primaryColor colorWithAlphaComponent:0.87f];
        [textInputControllerFloatingPlaceholderClass
         setFloatingPlaceholderNormalColorDefault:onSurface60Opacity];
        [textInputControllerFloatingPlaceholderClass
         setFloatingPlaceholderActiveColorDefault:primary87Opacity];
    }
}
#if !defined(__IPHONE_11_0)
#pragma clang diagnostic pop
#endif

@end
