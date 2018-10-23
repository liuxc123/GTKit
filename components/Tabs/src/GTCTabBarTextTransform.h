//
//  GTCTabBarTextTransform.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

/** Appearance for content within tab bar items. */
typedef NS_ENUM(NSInteger, GTCTabBarTextTransform) {
    /** The default text transform is applied based on the bar's position. */
    GTCTabBarTextTransformAutomatic = 0,

    /** Text on tabs is displayed verbatim with no transform. */
    GTCTabBarTextTransformNone = 1,

    /** Text on tabs is uppercased for display. */
    GTCTabBarTextTransformUppercase = 2,
};
