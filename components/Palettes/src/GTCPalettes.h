//
//  GTCPalettes.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

/** Tint color name. */
typedef NSString *GTCPaletteTint NS_EXTENSIBLE_STRING_ENUM;

/** The name of the tint 50 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint50Name;

/** The name of the tint 100 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint100Name;

/** The name of the tint 200 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint200Name;

/** The name of the tint 300 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint300Name;

/** The name of the tint 400 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint400Name;

/** The name of the tint 500 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint500Name;

/** The name of the tint 600 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint600Name;

/** The name of the tint 700 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint700Name;

/** The name of the tint 800 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint800Name;

/** The name of the tint 900 color when creating a custom palette. */
CG_EXTERN const GTCPaletteTint _Nonnull GTCPaletteTint900Name;

/** Accent color name. */
typedef NSString *GTCPaletteAccent NS_EXTENSIBLE_STRING_ENUM;

/** The name of the accent 100 color when creating a custom palette. */
CG_EXTERN const GTCPaletteAccent _Nonnull GTCPaletteAccent100Name;

/** The name of the accent 200 color when creating a custom palette. */
CG_EXTERN const GTCPaletteAccent _Nonnull GTCPaletteAccent200Name;

/** The name of the accent 400 color when creating a custom palette. */
CG_EXTERN const GTCPaletteAccent _Nonnull GTCPaletteAccent400Name;

/** The name of the accent 700 color when creating a custom palette. */
CG_EXTERN const GTCPaletteAccent _Nonnull GTCPaletteAccent700Name;

/**
 A palette of Material colors.

 Material palettes have a set of named tint colors and an optional set of named accent colors. This
 class provides access to the pre-defined set of Material palettes. GTCPalette objects are
 immutable; it is safe to use them from multiple threads in your app.

 @see https://material.io/go/design-color-theming#color-color-palette
 */
@interface GTCPalette : NSObject

/** The red palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *redPalette;

/** The pink palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *pinkPalette;

/** The purple palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *purplePalette;

/** The deep purple palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *deepPurplePalette;

/** The indigo palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *indigoPalette;

/** The blue palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *bluePalette;

/** The light blue palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *lightBluePalette;

/** The cyan palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *cyanPalette;

/** The teal palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *tealPalette;

/** The green palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *greenPalette;

/** The light green palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *lightGreenPalette;

/** The lime palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *limePalette;

/** The yellow palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *yellowPalette;

/** The amber palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *amberPalette;

/** The orange palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *orangePalette;

/** The deep orange palette. */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *deepOrangePalette;

/** The brown palette (no accents). */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *brownPalette;

/** The grey palette (no accents). */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *greyPalette;

/** The blue grey palette (no accents). */
@property(class, nonatomic, readonly, strong, nonnull) GTCPalette *blueGreyPalette;

/**
 Returns a palette generated from a single target 500 tint color.

 TODO(ajsecord): Document the algorithm used to generate the palette.

 @param target500Color The target "500" color in the palette.
 @return A palette generated with a 500 color matching the target color.
 */
+ (nonnull instancetype)paletteGeneratedFromColor:(nonnull UIColor *)target500Color;

/**
 Returns a palette with a custom set of tints and accents.

 The tints dictionary must have values for each key matching GTCPaletteTint.*Name. The accents
 dictionary, if specified, may have entries for each key matching GTCPaletteAccent.*Name. Missing
 accent values will cause an assert in debug mode and will return +[UIColor clearColor] in release
 mode when the corresponding property is acccessed.

 @param tints A dictionary mapping GTCPaletteTint.*Name keys to UIColors.
 @param accents An optional dictionary mapping GTCPaletteAccent.*Name keys to UIColors.
 @return An palette containing the custom colors.
 */
+ (nonnull instancetype)paletteWithTints:(nonnull NSDictionary<GTCPaletteTint, UIColor *> *)tints
                                 accents:
(nullable NSDictionary<GTCPaletteAccent, UIColor *> *)accents;

/**
 Returns an initialized palette object with a custom set of tints and accents.

 The tints dictionary must have values for each key matching GTCPaletteTint.*Name. The accents
 dictionary, if specified, may have entries for each key matching GTCPaletteAccent.*Name. Missing
 accent values will cause an assert in debug mode and will return +[UIColor clearColor] in release
 mode when the corresponding property is acccessed.

 @param tints A dictionary mapping GTCPaletteTint.*Name keys to UIColors.
 @param accents An optional dictionary mapping GTCPaletteAccent.*Name keys to UIColors.
 @return An initialized GTCPalette object containing the custom colors.
 */
- (nonnull instancetype)initWithTints:(nonnull NSDictionary<GTCPaletteTint, UIColor *> *)tints
                              accents:(nullable NSDictionary<GTCPaletteAccent, UIColor *> *)accents;

/** The 50 tint color, the lightest tint of the palette. */
@property(nonatomic, nonnull, readonly) UIColor *tint50;

/** The 100 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint100;

/** The 200 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint200;

/** The 300 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint300;

/** The 400 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint400;

/** The 500 tint color, the representative tint of the palette. */
@property(nonatomic, nonnull, readonly) UIColor *tint500;

/** The 600 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint600;

/** The 700 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint700;

/** The 800 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint800;

/** The 900 tint color, the darkest tint of the palette. */
@property(nonatomic, nonnull, readonly) UIColor *tint900;

/** The A100 accent color, the lightest accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent100;

/** The A200 accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent200;

/** The A400 accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent400;

/** The A700 accent color, the darkest accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent700;

@end

