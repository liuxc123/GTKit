//
//  GTCOverlayUtilities.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCOverlayUtilities.h"

CGRect GTCOverlayConvertRectToView(CGRect screenRect, UIView *target) {
    if (target != nil && !CGRectIsNull(screenRect)) {
        UIScreen *screen = [UIScreen mainScreen];
        return [target convertRect:screenRect fromCoordinateSpace:screen.coordinateSpace];
    }
    return CGRectNull;
}
