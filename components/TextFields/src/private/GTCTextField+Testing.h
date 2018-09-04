//
//  GTCTextField+Testing.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import <UIKit/UIKit.h>

#import "GTCTextField.h"

/**
 Exposes parts of GTCTextField for testing.
 */
@interface GTCTextField (Testing)

/**
 Synthesizes a touch on the clear button of the text field.
 */
- (void)clearButtonDidTouch;

@end
