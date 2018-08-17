//
//  GTCFontTraits.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

#import "GTCFontTextStyle.h"

/**
 Provides a means of storing defining font metrics based on size categories.

 This class is based off Apple recommendation in WWDC 2016 - 803 - Typography and Fonts @ 17:33.
 */
@interface GTCFontTraits : NSObject

/**
 The size to which the font is scaled.

 This value, in points, must be greater than 0.0.
 */
@property(nonatomic, readonly) CGFloat pointSize;

/**
 The weight of the font, specified as a font weight constant.

 For a list of possible values, see "Font Weights” in UIFontDescriptor. Avoid passing an arbitrary
 floating-point number for weight, because a font might not include a variant for every weight.
 */
@property(nonatomic, readonly) CGFloat weight;

/**
 The leading value represents additional space between lines of text and is measured in points.
 */
@property(nonatomic, readonly) CGFloat leading;

/**
 The tracking value represents additional horizontal space between glyphs and is measured in points.
 */
@property(nonatomic, readonly) CGFloat tracking;

/**
 @param style GTCFontStyle of font traits being requested.
 @param sizeCategory UIContentSizeCategory of the font traits being requested.

 @return Font traits that can be used to initialize a UIFont or UIFontDescriptor.
 */
+ (nonnull GTCFontTraits *)traitsForTextStyle:(GTCFontTextStyle)style
                                 sizeCategory:(nonnull NSString *)sizeCategory;

@end

