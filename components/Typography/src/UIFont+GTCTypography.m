//
//  UIFont+GTCTypography.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "UIFont+GTCTypography.h"

#import "GTCTypography.h"
#import "UIFontDescriptor+GTCTypography.h"

@implementation UIFont (GTCTypography)

+ (UIFont *)gtc_preferredFontForMaterialTextStyle:(GTCFontTextStyle)style {
    // Due to the way iOS handles missing glyphs in fonts, we do not support using
    // our font loader with Dynamic Type.
    id<GTCTypographyFontLoading> fontLoader = [GTCTypography fontLoader];
    if (![fontLoader isKindOfClass:[GTCSystemFontLoader class]]) {
        NSLog(@"GTCTypography : Custom font loaders are not compatible with Dynamic Type.");
    }

    UIFontDescriptor *fontDescriptor =
    [UIFontDescriptor gtc_preferredFontDescriptorForMaterialTextStyle:style];

    // Size is included in the fontDescriptor, so we pass in 0.0 in the parameter.
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:0.0];

    return font;
}

+ (nonnull UIFont *)gtc_standardFontForMaterialTextStyle:(GTCFontTextStyle)style {
    // Due to the way iOS handles missing glyphs in fonts, we do not support using our
    // font loader with standardFont.
    id<GTCTypographyFontLoading> fontLoader = [GTCTypography fontLoader];
    if (![fontLoader isKindOfClass:[GTCSystemFontLoader class]]) {
        NSLog(@"MaterialTypography : Custom font loaders are not compatible with Dynamic Type.");
    }

    UIFontDescriptor *fontDescriptor =
    [UIFontDescriptor gtc_standardFontDescriptorForMaterialTextStyle:style];

    // Size is included in the fontDescriptor, so we pass in 0.0 in the parameter.
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:0.0];

    return font;
}

- (nonnull UIFont *)gtc_fontSizedForMaterialTextStyle:(GTCFontTextStyle)style
                                 scaledForDynamicType:(BOOL)scaled {
    UIFontDescriptor *fontDescriptor;
    if (scaled) {
        fontDescriptor = [UIFontDescriptor gtc_preferredFontDescriptorForMaterialTextStyle:style];
    } else {
        fontDescriptor = [UIFontDescriptor gtc_standardFontDescriptorForMaterialTextStyle:style];
    }

    return [self fontWithSize:fontDescriptor.pointSize];
}

@end
