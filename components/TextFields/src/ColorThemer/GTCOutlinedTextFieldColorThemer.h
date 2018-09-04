//
//  GTCOutlinedTextFieldColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <Foundation/Foundation.h>

#import "GTColorScheme.h"
#import "GTTextFields.h"

/**
 The Material Design color system's outlined text field themer.
 */
@interface GTCOutlinedTextFieldColorThemer : NSObject

/**
 Applies a color scheme's properties to a text field using the outlined style.

 @param colorScheme The color scheme to apply to the component instance.
 @param textInputController A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
           toTextInputController:(nonnull id<GTCTextInputController>)textInputController;

@end
