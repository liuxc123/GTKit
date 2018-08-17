//
//  GTCLayoutMetrics.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 On devices with hardware safe areas, returns the top safe area for the key window. On all other
 devices, returns the fixed status bar height regardless of status bar visibility.

 This method is only meant for use with views that are placed behind the top safe area of a device
 and that can be shifted off-screen along with the status bar. These kinds of views must not change
 their top margin when shifting off-screen because it would cause a visible jump in layout. iOS
 does not have an API for fetching the status bar's dimensions if it is hidden, so this method
 ensures that we can always retrieve a non-zero value for our top safe area inset on devices without
 hardware safe areas, while also ensuring that we receive the proper top safe area inset on devices
 with hardware safe areas (iPhone X).
 */
FOUNDATION_EXPORT CGFloat GTCDeviceTopSafeAreaInset(void);
