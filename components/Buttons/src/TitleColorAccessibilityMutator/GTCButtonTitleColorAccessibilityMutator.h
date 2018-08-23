//
//  GTCButtonTitleColorAccessibilityMutator.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import <Foundation/Foundation.h>

#import "GTButtons.h"

/**
 A Mutator that will change an instance of GTCButton to have a high enough contrast text between
 its background.
 */
@interface GTCButtonTitleColorAccessibilityMutator : NSObject

/**
 This method will change the title color for each state of the button to ensure a high accessiblity
 contrast with its background.
 */
+ (void)changeTitleColorOfButton:(GTCButton *)button;

@end
