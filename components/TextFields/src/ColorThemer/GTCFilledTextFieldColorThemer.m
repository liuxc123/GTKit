//
//  GTCFilledTextFieldColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCFilledTextFieldColorThemer.h"

static CGFloat const kFilledTextFieldActiveAlpha = 0.87f;
static CGFloat const kFilledTextFieldOnSurfaceAlpha = 0.6f;
static CGFloat const kFilledTextFieldDisabledAlpha = 0.38f;
static CGFloat const kFilledTextFieldSurfaceOverlayAlpha = 0.04f;
static CGFloat const kFilledTextFieldIndicatorLineAlpha = 0.42f;
static CGFloat const kFilledTextFieldIconAlpha = 0.54f;

@implementation GTCFilledTextFieldColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
     toTextInputControllerFilled:(nonnull GTCTextInputControllerFilled *)textInputControllerFilled {
    textInputControllerFilled.borderFillColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldSurfaceOverlayAlpha];
    textInputControllerFilled.normalColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldIndicatorLineAlpha];
    textInputControllerFilled.inlinePlaceholderColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldOnSurfaceAlpha];
    textInputControllerFilled.leadingUnderlineLabelTextColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldOnSurfaceAlpha];
    textInputControllerFilled.activeColor = colorScheme.primaryColor;
    textInputControllerFilled.textInput.textColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldActiveAlpha];
    textInputControllerFilled.errorColor = colorScheme.errorColor;
    textInputControllerFilled.disabledColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldDisabledAlpha];
    textInputControllerFilled.floatingPlaceholderNormalColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldOnSurfaceAlpha];
    textInputControllerFilled.floatingPlaceholderActiveColor =
    [colorScheme.primaryColor colorWithAlphaComponent:kFilledTextFieldActiveAlpha];
    textInputControllerFilled.textInputClearButtonTintColor =
    [colorScheme.onSurfaceColor colorWithAlphaComponent:kFilledTextFieldIconAlpha];
}

@end


