//
//  GTCOutlinedButtonThemer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTButtons.h"

#import "GTCButtonScheme.h"

/**
 The Material Design outlined button themer for instances of GTCButton.
 */
@interface GTCOutlinedButtonThemer : NSObject

/**
 Applies a button scheme's properties to an GTCButton using the outlined button style.

 @param scheme The button scheme to apply to the component instance.
 @param button A component instance to which the scheme should be applied.
 */
+ (void)applyScheme:(nonnull id<GTCButtonScheming>)scheme
           toButton:(nonnull GTCButton *)button;

@end
