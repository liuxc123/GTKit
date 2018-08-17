//
//  GTCFontTextStyle.h
//  Pods
//
//  Created by liuxc on 2018/8/17.
//

#import <Foundation/Foundation.h>

/**
 Material font text styles

 These styles are defined in:
 https://material.io/go/design-typography
 This enumeration is a set of semantic descriptions intended to describe the fonts returned by
 + [UIFont GTC_preferredFontForMaterialTextStyle:]
 + [UIFontDescriptor GTC_preferredFontDescriptorForMaterialTextStyle:]
 */
typedef NS_ENUM(NSInteger, GTCFontTextStyle) {
    GTCFontTextStyleBody1,
    GTCFontTextStyleBody2,
    GTCFontTextStyleCaption,
    GTCFontTextStyleHeadline,
    GTCFontTextStyleSubheadline,
    GTCFontTextStyleTitle,
    GTCFontTextStyleDisplay1,
    GTCFontTextStyleDisplay2,
    GTCFontTextStyleDisplay3,
    GTCFontTextStyleDisplay4,
    GTCFontTextStyleButton,
};
