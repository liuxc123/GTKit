//
//  UIFont+GTTypographyPrivate.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "UIFont+GTCTypographyPrivate.h"

@implementation UIFont (GTCTypographyPrivate)

/*
 Returns a string indicating the weight of the font.  These weights were added in iOS 8.2.
 */
+ (NSString *)gtc_fontWeightDescription:(CGFloat)weight {
    // The UIFontWeight enumeration was added in iOS 8.2
    NSString *description = [NSString stringWithFormat:@"(%.3f)", weight];
#if defined(__IPHONE_8_2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
    if (&UIFontWeightMedium != NULL) {
        if (weight == UIFontWeightUltraLight) {
            return @"UltraLight";
        } else if (weight == UIFontWeightThin) {
            return @"Thin";
        } else if (weight == UIFontWeightLight) {
            return @"Light";
        } else if (weight == UIFontWeightRegular) {
            return @"Regular";
        } else if (weight == UIFontWeightMedium) {
            return @"Medium";
        } else if (weight == UIFontWeightSemibold) {
            return @"Semibold";
        } else if (weight == UIFontWeightBold) {
            return @"Bold";
        } else if (weight == UIFontWeightHeavy) {
            return @"Heavy";
        } else if (weight == UIFontWeightBlack) {
            return @"Black";
        } else {
            return description;
        }
    } else {
        return description;
    }
#pragma clang diagnostic pop
#else
    return description;
#endif
}

- (CGFloat)gtc_weight {
    // The default font weight is UIFontWeightRegular, which is 0.0.
    CGFloat weight = 0.0;

    NSDictionary *fontTraits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    if (fontTraits) {
        NSNumber *weightNumber = fontTraits[UIFontWeightTrait];
        if (weightNumber != nil) {
            weight = [weightNumber floatValue];
        }
    }

    return weight;
}

- (CGFloat)gtc_slant {
    CGFloat slant = 0.0;

    NSDictionary *fontTraits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    if (fontTraits) {
        NSNumber *slantNumber = fontTraits[UIFontSlantTrait];
        if (slantNumber != nil) {
            slant = [slantNumber floatValue];
        }
    }

    return slant;
}

- (NSString *)gtc_weightString {
    CGFloat weight = [self gtc_weight];
    NSString *weightString = [UIFont gtc_fontWeightDescription:weight];

    return weightString;
}

- (NSString *)gtc_extendedDescription {
    NSMutableString *extendedDescription = [[NSMutableString alloc] init];
    [extendedDescription appendFormat:@"%@ : ", self.fontName];
    [extendedDescription appendFormat:@"%@ : ", self.familyName];
    [extendedDescription appendFormat:@"%.1f pt : ", self.pointSize];
    [extendedDescription appendFormat:@"%@", [self gtc_weightString]];

    return extendedDescription;
}

@end
