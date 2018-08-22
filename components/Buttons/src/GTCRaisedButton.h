//
//  GTCRaisedButton.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/21.
//

#import "GTCButton.h"

/**
 A "raised" GTCButton.

 Raised buttons have their own background color, float above their parent slightly, and raise
 briefly when touched. Raised buttons should be used when flat buttons would get lost among other
 UI elements on the screen.

 @warning This class will be deprecated soon. Consider using @c GTCContainedButtonThemer with an
 @c GTCButton instead.

 @see https://material.io/go/design-buttons#buttons-raised-buttons
 */
@interface GTCRaisedButton : GTCButton

@end
