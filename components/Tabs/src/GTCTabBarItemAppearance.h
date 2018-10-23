//
//  GTComponentsExamples.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

/** Appearance for content within tab bar items. */
typedef NS_ENUM(NSInteger, GTCTabBarItemAppearance) {
    /** Tabs are shown as titles. Badges are not supported for this appearance. */
    GTCTabBarItemAppearanceTitles,

    /** Tabs are shown as images. */
    GTCTabBarItemAppearanceImages,

    /** Tabs are shown as images with titles underneath. */
    GTCTabBarItemAppearanceTitledImages,
};
