//
//  GTCShapeScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTCShapeCategory.h"

/**
 A simple shape scheme that provides semantic meaning.
 Each GTCShapeCategory is mapped to a component.
 The mapping is based on the component's surface size.
 There are no optional properties and all shapes must be provided,
 supporting more reliable shape theming.
 */
@protocol GTCShapeScheming

/**
 The shape defining small sized components.
 */
@property(nonnull, readonly, nonatomic) GTCShapeCategory *smallComponentShape;

/**
 The shape defining medium sized components.
 */
@property(nonnull, readonly, nonatomic) GTCShapeCategory *mediumComponentShape;

/**
 The shape defining large sized components.
 */
@property(nonnull, readonly, nonatomic) GTCShapeCategory *largeComponentShape;

@end

/**
 An enum of default shape schemes that are supported.
 */
typedef NS_ENUM(NSInteger, GTCShapeSchemeDefaults) {
    /**
     The Material defaults, circa September 2018.
     */
    GTCShapeSchemeDefaultsMaterial201809
};

/**
 A simple implementation of @c GTCShapeScheming that provides Material default shape values from
 which basic customizations can be made.
 */
@interface GTCShapeScheme : NSObject <GTCShapeScheming>

// Redeclare protocol properties as readwrite
@property(nonnull, readwrite, nonatomic) GTCShapeCategory *smallComponentShape;
@property(nonnull, readwrite, nonatomic) GTCShapeCategory *mediumComponentShape;
@property(nonnull, readwrite, nonatomic) GTCShapeCategory *largeComponentShape;

/**
 Initializes the shape scheme with the latest material defaults.
 */
- (nonnull instancetype)init;

/**
 Initializes the shape scheme with the shapes associated with the given defaults.
 */
- (nonnull instancetype)initWithDefaults:(GTCShapeSchemeDefaults)defaults;

@end
