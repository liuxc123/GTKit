//
//  GTCFilledTextFieldColorThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <Foundation/Foundation.h>

#import "GTColorScheme.h"
#import "GTTextFields.h"

/**
 The Material Design color system's filled text field themer.
 */
@interface GTCFilledTextFieldColorThemer : NSObject

/**
 Applies a color scheme's properties to a text field using the filled style.

 @param colorScheme The color scheme to apply to the component instance.
 @param textInputControllerFilled A component instance to which the color scheme should be applied.
 */
+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
     toTextInputControllerFilled:(nonnull GTCTextInputControllerFilled *)textInputControllerFilled;

@end
