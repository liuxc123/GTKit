//
//  GTCOverlayUtilities.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

/**
 Utility function which converts a rectangle in overlay coordinates into the local coordinate
 space of the given @c target
 */
OBJC_EXPORT CGRect GTCOverlayConvertRectToView(CGRect overlayFrame, UIView *targetView);
