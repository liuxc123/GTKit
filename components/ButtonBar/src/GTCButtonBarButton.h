//
//  GTCButtonBarButton.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTButtons.h"

/**
 The GTCButtonBarButton class is used by GTCButtonBar.
 */
@interface GTCButtonBarButton : GTCFlatButton

/**
 The font used by the button's @c title.

 If left unset or reset to nil for a given state, then a default font is used.

 @param font The font.
 @param state The state.
 */
- (void)setTitleFont:(nullable UIFont *)font forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;

@end
