//
//  GTCFlatButton.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/21.
//

#import <Foundation/Foundation.h>

#import "GTCButton.h"
/**
 A "flat" GTCButton.

 Flat buttons should be considered the default button. They do not have their own background color,
 do not raise when touched, and have uppercased text to indicate to the user that they are buttons.
 Flat buttons should be used in most situations requiring a button. For layouts with many UI
 elements in which a flat button might get visually lost, consider using a GTCRaisedButton instead.

 @warning This class will be deprecated soon. Consider using @c GTCTextButtonThemer with an
 @c GTCButton instead.

 @see https://material.io/go/design-buttons#buttons-flat-buttons
 */

@interface GTCFlatButton : GTCButton

/**
 Use an opaque background color (default is NO).

 Flat buttons normally have a transparent background and blend seamlessly with their underlying
 color, but occasionally a flat button with an opaque background will be required. Consider using
 a raised button instead if possible.
 */
@property(nonatomic) BOOL hasOpaqueBackground;

@end
