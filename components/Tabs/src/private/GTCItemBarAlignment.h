//
//  GTCItemBarAlignment.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import <Foundation/Foundation.h>

/** Alignment styles for items in a tab bar. */
typedef NS_ENUM(NSInteger, GTCItemBarAlignment) {
    /** Items are aligned on the leading edge and sized to fit their content. */
    GTCItemBarAlignmentLeading,

    /** Items are justified to equal size across the width of the screen. */
    GTCItemBarAlignmentJustified,

    /**
     * Items are sized to fit their content and center-aligned as a group. If they do not fit in view,
     * they will be leading-aligned instead.
     */
    GTCItemBarAlignmentCenter,

    /** Items are center-aligned on the selected item. */
    GTCItemBarAlignmentCenterSelected,
};

