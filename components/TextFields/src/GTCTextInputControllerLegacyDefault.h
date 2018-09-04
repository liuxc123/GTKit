//
//  GTCTextInputControllerLegacyDefault.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerBase.h"

/**
 Material Design compliant text field from 2016. The logic for 'automagic' error states changes:
 underline color, underline text color.
 https://www.google.com/design/spec/components/text-fields.html#text-fields-single-line-text-field

 The placeholder text is laid out inline. If floating is enabled, it will float above the field when
 there is content or the field is being edited. The character count is below text. The Material
 Design guidelines call this 'Floating inline labels.'
 https://material.io/go/design-text-fields#text-fields-labels

 NOTE: This design doesn't exactly match the 2015 text fields that had slightly different colors.

 Defaults:

 Active Color - Blue A700

 Border Stroke Color - Clear
 Border Fill Color - Clear

 Disabled Color = [UIColor lightGrayColor]

 Error Color - Red A400

 Floating Placeholder Color Active - Blue A700
 Floating Placeholder Color Normal - Black, 54% opacity

 Inline Placeholder Color - Black, 54% opacity

 Leading Underline Label Text Color - Black, 54% opacity

 Normal Color - Black, 54% opacity

 Rounded Corners - None

 Trailing Underline Label Text Color - Black, 54% opacity

 Underline Color Normal - Black, 54% opacity

 Underline Height Active - 2p
 Underline Height Normal - 1p

 Underline View Mode - While editing
 */
@interface GTCTextInputControllerLegacyDefault : GTCTextInputControllerBase

@end
