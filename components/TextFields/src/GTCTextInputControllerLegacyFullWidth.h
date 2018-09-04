//
//  GTCTextInputControllerLegacyFullWidth.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerFullWidth.h"

/**
 Material Design compliant text field. The logic for 'automagic' error states changes:
 underline color, underline text color.
 https://www.google.com/design/spec/components/text-fields.html#text-fields-single-line-text-field

 The placeholder is laid out inline and the character count is also inline to the right.

 Defaults:

 Active Color - Blue A700

 Border Fill Color - Clear
 Border Stroke Color - Clear

 Disabled Color = [UIColor lightGrayColor]

 Error Color - Red A400

 Floating Placeholder Color Active - Blue A700
 Floating Placeholder Color Normal - Black, 54% opacity

 Inline Placeholder Color - Black, 54% opacity

 Leading Underline Label Text Color - Black, 54% opacity

 Normal Color - Black, 54% opacity

 Rounded Corners - None

 Trailing Underline Label Text Color - Black, 54% opacity

 Underline Height Active - 0p
 Underline Height Normal - 0p

 Underline View Mode - While editing
 */
@interface GTCTextInputControllerLegacyFullWidth : GTCTextInputControllerFullWidth

@end
