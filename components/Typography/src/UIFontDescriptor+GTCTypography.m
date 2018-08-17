//
//  UIFontDescriptor+GTCTypography.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "UIFontDescriptor+GTCTypography.h"

#import "GTApplication.h"

#import "private/GTCFontTraits.h"

@implementation UIFontDescriptor (GTCTypography)

+ (nonnull UIFontDescriptor *)gtc_fontDescriptorForMaterialTextStyle:(GTCFontTextStyle)style
                                                        sizeCategory:(NSString *)sizeCategory {
    // TODO(#1179): We should include our leading and tracking metrics when creating this descriptor.
    GTCFontTraits *materialTraits =
    [GTCFontTraits traitsForTextStyle:style sizeCategory:sizeCategory];

    // Store the system font family name to ensure that we load the system font.
    // If we do not explicitly include this UIFontDescriptorFamilyAttribute in the
    // FontDescriptor the OS will default to Helvetica. On iOS 9+, the Font Family
    // changes from San Francisco to San Francisco Display at point size 20.
    static NSString *smallSystemFontFamilyName;
    static NSString *largeSystemFontFamilyName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIFont *smallSystemFont;
        UIFont *largeSystemFont;
        if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
            smallSystemFont = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
            largeSystemFont = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
#pragma clang diagnostic pop
        } else {
            // TODO: Remove this fallback once we are 8.2+
            smallSystemFont = [UIFont systemFontOfSize:12];
            largeSystemFont = [UIFont systemFontOfSize:20];
        }
        smallSystemFontFamilyName = [smallSystemFont.familyName copy];
        largeSystemFontFamilyName = [largeSystemFont.familyName copy];
    });

    NSDictionary *traits = @{ UIFontWeightTrait : @(materialTraits.weight) };
    NSString *fontFamily =
    materialTraits.pointSize < 19.5 ? smallSystemFontFamilyName : largeSystemFontFamilyName;
    NSDictionary *attributes = @{
                                 UIFontDescriptorSizeAttribute : @(materialTraits.pointSize),
                                 UIFontDescriptorTraitsAttribute : traits,
                                 UIFontDescriptorFamilyAttribute : fontFamily
                                 };

    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:attributes];

    return fontDescriptor;
}

+ (nonnull UIFontDescriptor *)gtc_preferredFontDescriptorForMaterialTextStyle:
(GTCFontTextStyle)style {
    // iOS' default UIContentSizeCategory is Large.
    NSString *sizeCategory = UIContentSizeCategoryLarge;

    // If we are within an application, query the preferredContentSizeCategory.
    if ([UIApplication gtc_safeSharedApplication]) {
        sizeCategory = [UIApplication gtc_safeSharedApplication].preferredContentSizeCategory;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    } else if (@available(iOS 10.0, *)) {
        sizeCategory = UIScreen.mainScreen.traitCollection.preferredContentSizeCategory;
#endif
    }

    return [UIFontDescriptor gtc_fontDescriptorForMaterialTextStyle:style sizeCategory:sizeCategory];
}

+ (nonnull UIFontDescriptor *)gtc_standardFontDescriptorForMaterialTextStyle:
(GTCFontTextStyle)style {
    // iOS' default UIContentSizeCategory is Large.
    // Since we don't want to scale with Dynamic Type create the font descriptor based on that.
    NSString *sizeCategory = UIContentSizeCategoryLarge;

    return [UIFontDescriptor gtc_fontDescriptorForMaterialTextStyle:style sizeCategory:sizeCategory];
}

@end
