//
//  GTCButtonBar+Private.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTCButtonBar.h"

@interface GTCButtonBar (Private)

/**
 Finds the corresponding UIBarButtonItem and calls its target/action with the item as the first
 parameter.
 */
- (void)didTapButton:(UIButton *)button event:(UIEvent *)event;

@end
