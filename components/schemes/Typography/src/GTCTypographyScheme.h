//
//  GTCTypographyScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import <UIKit/UIKit.h>

/**
 A simple typography scheme that provides semantic fonts. There are no optional
 properties, all fonts must be provided, supporting more reliable typography theming.
 */
@protocol GTCTypographyScheming


/**
 The headline 1 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *headline1;

/**
 The headline 2 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *headline2;

/**
 The headline 3 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *headline3;

/**
 The headline 4 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *headline4;

/**
 The headline 5 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *headline5;

/**
 The headline 6 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *headline6;

/**
 The subtitle 1 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *subtitle1;

/**
 The subtitle 2 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *subtitle2;

/**
 The body 1 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *body1;

/**
 Return the body 2 font.
 */
@property(nonatomic, nonnull, readonly) UIFont *body2;

/**
 Return the caption font.
 */
@property(nonatomic, nonnull, readonly) UIFont *caption;

/**
 Return the button font.
 */
@property(nonatomic, nonnull, readonly) UIFont *button;

/**
 Return the overline font.
 */
@property(nonatomic, nonnull, readonly) UIFont *overline;

@end

/**
 An enum of default typography schemes that are supported.
 */
typedef NS_ENUM(NSInteger, GTCTypographySchemeDefaults) {
    /**
     The Material defaults, circa April 2018.
     */
    GTCTypographySchemeDefaultsMaterial201804
};

/**
 A simple implementation of @c GTCTypographyScheming that provides Material default fonts
 from which basic customizations can be made.
 */
@interface GTCTypographyScheme : NSObject <GTCTypographyScheming>

// Redeclare protocol properties as readwrite
@property(nonatomic, nonnull, readwrite) UIFont *headline1;
@property(nonatomic, nonnull, readwrite) UIFont *headline2;
@property(nonatomic, nonnull, readwrite) UIFont *headline3;
@property(nonatomic, nonnull, readwrite) UIFont *headline4;
@property(nonatomic, nonnull, readwrite) UIFont *headline5;
@property(nonatomic, nonnull, readwrite) UIFont *headline6;
@property(nonatomic, nonnull, readwrite) UIFont *subtitle1;
@property(nonatomic, nonnull, readwrite) UIFont *subtitle2;
@property(nonatomic, nonnull, readwrite) UIFont *body1;
@property(nonatomic, nonnull, readwrite) UIFont *body2;
@property(nonatomic, nonnull, readwrite) UIFont *caption;
@property(nonatomic, nonnull, readwrite) UIFont *button;
@property(nonatomic, nonnull, readwrite) UIFont *overline;

/**
 Initializes the typography scheme with the latest material defaults.
 */
- (nonnull instancetype)init;

/**
 Initializes the typography scheme with the values associated with the given defaults.
 */
- (nonnull instancetype)initWithDefaults:(GTCTypographySchemeDefaults)defaults;

@end

