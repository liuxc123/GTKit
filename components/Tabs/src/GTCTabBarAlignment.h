//
//  GTCTabBarAlignment.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import <Foundation/Foundation.h>

/** Alignment styles for items in a tab bar. */
typedef NS_ENUM(NSInteger, GTCTabBarAlignment) {
    /** Items are aligned on the leading edge and sized to fit their content. */
    GTCTabBarAlignmentLeading,

    /**
     Items are justified to equal size across the width of the screen. Overscrolling is disabled
     for this alignment.
     */
    GTCTabBarAlignmentJustified,

    /**
     Items are sized to fit their content and center-aligned as a group. If they do not fit in view,
     they will be leading-aligned instead.
     */
    GTCTabBarAlignmentCenter,

    /** Tabs are center-aligned on the selected item. */
    GTCTabBarAlignmentCenterSelected,
};
