//
//  UIFont+GTCTypography.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

#import "GTCFontTextStyle.h"

@interface UIFont (GTCTypography)

/**
 Returns an instance of the font associated with the Material text style and scaled based on the
 content size category.

 @param style The Material font text style for which to return a font.
 @return The font associated with the specified style.
 */
+ (nonnull UIFont *)gtc_preferredFontForMaterialTextStyle:(GTCFontTextStyle)style;

/**
 Returns an instance of the font associated with the Material text style
 This font is *not* scaled based on the content size category (Dynamic Type).

 @param style The Material font text style for which to return a font.
 @return The font associated with the specified style.
 */
+ (nonnull UIFont *)gtc_standardFontForMaterialTextStyle:(GTCFontTextStyle)style;

/**
 Returns an new instance of the font sized according to the text-style and whether the content
 size category (Dynamic Type) should be taken into account.

 @param style The Material font text style that will determine the fontSize of the new font
 @param scaled Should the new font be scaled according to the content size category (Dynamic Type)
 */
- (nonnull UIFont *)gtc_fontSizedForMaterialTextStyle:(GTCFontTextStyle)style
                                 scaledForDynamicType:(BOOL)scaled;

@end
