//
//  GTCOutlinedTextFieldColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCOutlinedTextFieldColorThemer.h"
#import "GTCTextInputControllerBase.h"

static CGFloat const kOutlinedTextFieldActiveAlpha = 0.87f;
static CGFloat const kOutlinedTextFieldOnSurfaceAlpha = 0.6f;
static CGFloat const kOutlinedTextFieldDisabledAlpha = 0.38f;
static CGFloat const kOutlinedTextFieldIconAlpha = 0.54f;

@implementation GTCOutlinedTextFieldColorThemer

+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
           toTextInputController:(id<GTCTextInputController>)textInputController {
    UIColor *onSurfaceOpacity =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kOutlinedTextFieldOnSurfaceAlpha];
    textInputController.activeColor = colorScheme.primaryColor;
    textInputController.errorColor = colorScheme.errorColor;
    textInputController.trailingUnderlineLabelTextColor = onSurfaceOpacity;
    textInputController.normalColor = onSurfaceOpacity;
    textInputController.inlinePlaceholderColor = onSurfaceOpacity;
    textInputController.textInput.textColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kOutlinedTextFieldActiveAlpha];
    textInputController.leadingUnderlineLabelTextColor = onSurfaceOpacity;
    textInputController.disabledColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kOutlinedTextFieldDisabledAlpha];

    if ([textInputController isKindOfClass:[GTCTextInputControllerBase class]]) {
        GTCTextInputControllerBase *baseController =
        (GTCTextInputControllerBase *)textInputController;
        baseController.textInputClearButtonTintColor =
        [colorScheme.onSurfaceColor colorWithAlphaComponent:kOutlinedTextFieldIconAlpha];
    }

    if ([textInputController
         conformsToProtocol:@protocol(GTCTextInputControllerFloatingPlaceholder)]) {
        id<GTCTextInputControllerFloatingPlaceholder> textInputControllerFloatingPlaceholder =
        (id<GTCTextInputControllerFloatingPlaceholder>)textInputController;
        if ([textInputControllerFloatingPlaceholder
             respondsToSelector:@selector(setFloatingPlaceholderNormalColor:)]) {
            textInputControllerFloatingPlaceholder.floatingPlaceholderNormalColor = onSurfaceOpacity;
            textInputControllerFloatingPlaceholder.floatingPlaceholderActiveColor =
            [colorScheme.primaryColor colorWithAlphaComponent:kOutlinedTextFieldActiveAlpha];
        }
    }
}

@end

