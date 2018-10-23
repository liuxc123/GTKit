//
//  GTCTabBarIndicatorView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

@class GTCTabBarIndicatorAttributes;

/** View responsible for drawing the indicator behind tab content and animating changes. */
@interface GTCTabBarIndicatorView : UIView

/**
 Called to indicate that the indicator should update to display new attributes. This method may be
 called from an implicit animation block.
 */
- (void)applySelectionIndicatorAttributes:(GTCTabBarIndicatorAttributes *)attributes;

@end
