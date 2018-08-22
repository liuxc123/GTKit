//
//  GTCLayoutMetrics.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCLayoutMetrics.h"
#import "GTApplication.h"


static const CGFloat kFixedStatusBarHeightOnPreiPhoneXDevices = 20;

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
static BOOL HasHardwareSafeAreas(void) {
    static BOOL hasHardwareSafeAreas = NO;
    if (@available(iOS 11.0, *)) {
        static BOOL hasCheckedForHardwareSafeAreas = NO;
        static dispatch_once_t onceToken;
        if (!hasCheckedForHardwareSafeAreas && [UIApplication gtc_safeSharedApplication].keyWindow) {
            dispatch_once(&onceToken, ^{
                UIEdgeInsets insets = [UIApplication gtc_safeSharedApplication].keyWindow.safeAreaInsets;
                hasHardwareSafeAreas = (insets.top > kFixedStatusBarHeightOnPreiPhoneXDevices
                                        || insets.left > 0
                                        || insets.bottom > 0
                                        || insets.right > 0);

                hasCheckedForHardwareSafeAreas = YES;
            });
        }
    }
    return hasHardwareSafeAreas;
}
#endif

CGFloat GTCDeviceTopSafeAreaInset(void) {
    CGFloat topInset = kFixedStatusBarHeightOnPreiPhoneXDevices;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        // Devices with hardware safe area insets have fixed insets that depend on the device
        // orientation. On such devices, we aren't interested in the status bar's height because the
        // hardware safe area insets are what ultimately define the margins for the app. If we are
        // running on such a device, we read from the safe area insets instead of the fixed status bar
        // height so that we react to changes in safe area insets (usually due to orientation changes)
        // and update the fixed margin accordingly.
        if (HasHardwareSafeAreas()) {
            UIEdgeInsets insets = [UIApplication gtc_safeSharedApplication].keyWindow.safeAreaInsets;
            topInset = insets.top;
        }
    }
#endif
    return topInset;
}

