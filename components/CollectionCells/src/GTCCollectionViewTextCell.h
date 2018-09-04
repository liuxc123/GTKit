//
//  GTCCollectionViewTextCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import "GTCCollectionViewCell.h"

/** Default cell height for single line of text. Defaults to 48.0f. */
extern const CGFloat GTCCellDefaultOneLineHeight;

/** Default cell height for single line of text with avatar. Defaults to 56.0f. */
extern const CGFloat GTCCellDefaultOneLineWithAvatarHeight;

/** Default cell height for two lines of text. Defaults to 72.0f. */
extern const CGFloat GTCCellDefaultTwoLineHeight;

/** Default cell height for three lines of text. Defaults to 88.0f. */
extern const CGFloat GTCCellDefaultThreeLineHeight;

/**
 The GTCCollectionViewTextCell class provides an implementation of UICollectionViewCell that
 supports Material Design layout and styling. It provides two labels for text as well as an
 image view. The default layout specifications can be found at the following link.

 @see https://material.io/go/design-lists#lists-specs
 */
@interface GTCCollectionViewTextCell : GTCCollectionViewCell

/**
 A text label. Typically this will be the first line of text in the cell.

 Default text label properties:
 - text            defaults to nil.
 - font            defaults to [GTCTypography subheadFont].
 - textColor       defaults to [UIColor colorWithWhite:0 alpha:GTCTypography subheadFontOpacity]].
 - shadowColor     defaults to nil.
 - shadowOffset    defaults to CGSizeZero.
 - textAlignment   defaults to NSTextAlignmentNatural.
 - lineBreakMode   defaults to NSLineBreakByTruncatingTail.
 - numberOfLines   defaults to 1.
 */
@property(nonatomic, readonly, strong, nullable) UILabel *textLabel;

/**
 A detail text label. Typically this will be the second line of text in the cell.

 Default detail text label properties:
 - text            defaults to nil.
 - font            defaults to [GTCTypography body1Font].
 - textColor       defaults to [UIColor colorWithWhite:0 alpha:GTCTypography captionFontOpacity]].
 - shadowColor     defaults to nil.
 - shadowOffset    defaults to CGSizeZero.
 - textAlignment   defaults to NSTextAlignmentNatural.
 - lineBreakMode   defaults to NSLineBreakByTruncatingTail.
 - numberOfLines   defaults to 1.
 */
@property(nonatomic, readonly, strong, nullable) UILabel *detailTextLabel;

/**
 An image view on the leading side of cell. Default leading padding is 16.0f.
 */
@property(nonatomic, readonly, strong, nullable) UIImageView *imageView;

@end
