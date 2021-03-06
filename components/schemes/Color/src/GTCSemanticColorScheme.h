//
//  GTCSemanticColorScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 A simple color scheme that provides semantic context for the colors it uses. There are no optional
 properties and all colors must be provided, supporting more reliable color theming.
 */
@protocol GTCColorScheming

/**
 Displayed most frequently across your app.
 */
@property(nonnull, readonly, nonatomic) UIColor *primaryColor;

/**
 A tonal variation of primary color.
 */
@property(nonnull, readonly, nonatomic) UIColor *primaryColorVariant;

/**
 Accents select parts of your UI.
 */
@property(nonnull, readonly, nonatomic) UIColor *secondaryColor;

/**
 The color used to indicate error status.
 */
@property(nonnull, readonly, nonatomic) UIColor *errorColor;

/**
 The color of surfaces such as cards, sheets, menus.
 */
@property(nonnull, readonly, nonatomic) UIColor *surfaceColor;

/**
 The underlying color of an app’s content.
 */
@property(nonnull, readonly, nonatomic) UIColor *backgroundColor;

/**
 A color that passes accessibility guidelines for text/iconography when drawn on top of
 @c primaryColor.
 */
@property(nonnull, readonly, nonatomic) UIColor *onPrimaryColor;

/**
 A color that passes accessibility guidelines for text/iconography when drawn on top of
 @c secondaryColor.
 */
@property(nonnull, readonly, nonatomic) UIColor *onSecondaryColor;

/**
 A color that passes accessibility guidelines for text/iconography when drawn on top of
 @c surfaceColor.
 */
@property(nonnull, readonly, nonatomic) UIColor *onSurfaceColor;

/**
 A color that passes accessibility guidelines for text/iconography when drawn on top of
 @c backgroundColor.
 */
@property(nonnull, readonly, nonatomic) UIColor *onBackgroundColor;
@end

/**
 An enum of default color schemes that are supported.
 */
typedef NS_ENUM(NSInteger, GTCColorSchemeDefaults) {
    /**
     The Material defaults, circa April 2018.
     */
    GTCColorSchemeDefaultsMaterial201804
};

/**
 A simple implementation of @c GTCColorScheming that provides Material default color values from
 which basic customizations can be made.
 */
@interface GTCSemanticColorScheme : NSObject <GTCColorScheming>

// Redeclare protocol properties as readwrite
@property(nonnull, readwrite, nonatomic) UIColor *primaryColor;
@property(nonnull, readwrite, nonatomic) UIColor *primaryColorVariant;
@property(nonnull, readwrite, nonatomic) UIColor *secondaryColor;
@property(nonnull, readwrite, nonatomic) UIColor *errorColor;
@property(nonnull, readwrite, nonatomic) UIColor *surfaceColor;
@property(nonnull, readwrite, nonatomic) UIColor *backgroundColor;
@property(nonnull, readwrite, nonatomic) UIColor *onPrimaryColor;
@property(nonnull, readwrite, nonatomic) UIColor *onSecondaryColor;
@property(nonnull, readwrite, nonatomic) UIColor *onSurfaceColor;
@property(nonnull, readwrite, nonatomic) UIColor *onBackgroundColor;

/**
 Initializes the color scheme with the latest material defaults.
 */
- (nonnull instancetype)init;

/**
 Initializes the color scheme with the colors associated with the given defaults.
 */
- (nonnull instancetype)initWithDefaults:(GTCColorSchemeDefaults)defaults;

/**
 Blending a color over a background color using Alpha compositing technique.
 More info about Alpha compositing: https://en.wikipedia.org/wiki/Alpha_compositing

 @param color UIColor value that sits on top.
 @param backgroundColor UIColor on the background.
 */
+ (nonnull UIColor *)blendColor:(nonnull UIColor *)color
            withBackgroundColor:(nonnull UIColor *)backgroundColor;

@end
