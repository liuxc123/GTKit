//
//  GTCTextFieldTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextFieldTypographyThemer.h"

@implementation GTCTextFieldTypographyThemer

+ (void)applyTypographyScheme:(id<GTCTypographyScheming>)typographyScheme
        toTextInputController:(id<GTCTextInputController>)textInputController {
    textInputController.inlinePlaceholderFont = typographyScheme.subtitle1;
    textInputController.leadingUnderlineLabelFont = typographyScheme.caption;
    textInputController.trailingUnderlineLabelFont = typographyScheme.caption;
    if ([textInputController
         conformsToProtocol:@protocol(GTCTextInputControllerFloatingPlaceholder)]) {
        id<GTCTextInputControllerFloatingPlaceholder> textInputControllerFloatingPlaceholder =
        (id<GTCTextInputControllerFloatingPlaceholder>)textInputController;

        // if caption.pointSize <= 0 there is no meaningful ratio so we fallback to default.
        if (typographyScheme.caption.pointSize <= 0) {
            textInputControllerFloatingPlaceholder.floatingPlaceholderScale = nil;
        } else {
            double ratio = typographyScheme.caption.pointSize/typographyScheme.subtitle1.pointSize;
            textInputControllerFloatingPlaceholder.floatingPlaceholderScale =
            [NSNumber numberWithDouble:ratio];
        }
    }
}

+ (void)applyTypographyScheme:(id<GTCTypographyScheming>)typographyScheme
                  toTextInput:(id<GTCTextInput>)textInput {
    textInput.font = typographyScheme.subtitle1;
    textInput.placeholderLabel.font = typographyScheme.subtitle1;
    textInput.leadingUnderlineLabel.font = typographyScheme.caption;
    textInput.trailingUnderlineLabel.font = typographyScheme.caption;
}

// TODO: (larche) Drop this "#if !defined..." and the pragmas when we drop Xcode 8 support.
// This is to silence a warning that doesn't appear in Xcode 9 when you use Class as an object.
#if !defined(__IPHONE_11_0)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
#endif
+ (void)applyTypographyScheme:(id<GTCTypographyScheming>)typographyScheme
toAllTextInputControllersOfClass:(Class<GTCTextInputController>)textInputControllerClass {
    [textInputControllerClass setInlinePlaceholderFontDefault:typographyScheme.subtitle1];
    [textInputControllerClass setTrailingUnderlineLabelFontDefault:typographyScheme.caption];
    [textInputControllerClass setLeadingUnderlineLabelFontDefault:typographyScheme.caption];
    if ([textInputControllerClass
         conformsToProtocol:@protocol(GTCTextInputControllerFloatingPlaceholder)]) {
        Class<GTCTextInputControllerFloatingPlaceholder> textInputControllerFloatingPlaceholderClass =
        (Class<GTCTextInputControllerFloatingPlaceholder>)textInputControllerClass;
        // if caption.pointSize <= 0 there is no meaningful ratio so we fallback to default.
        if (typographyScheme.caption.pointSize <= 0) {
            [textInputControllerFloatingPlaceholderClass setFloatingPlaceholderScaleDefault:0];
        } else {
            CGFloat scale = typographyScheme.caption.pointSize/typographyScheme.subtitle1.pointSize;
            [textInputControllerFloatingPlaceholderClass setFloatingPlaceholderScaleDefault:scale];
        }
    }
}
#if !defined(__IPHONE_11_0)
#pragma clang diagnostic pop
#endif

@end
