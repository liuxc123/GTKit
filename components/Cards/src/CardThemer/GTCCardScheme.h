//
//  GTCCardScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCards.h"
#import "GTColorScheme.h"
#import "GTShapeScheme.h"

#import <Foundation/Foundation.h>

/** Defines a readonly immutable interface for cards style data to be applied by a themer. */
@protocol GTCCardScheming

/** The color scheme to apply to cards. */
@property(nonnull, readonly, nonatomic) id <GTCColorScheming> colorScheme;

/** The shape scheme to apply to cards. */
@property(nonnull, readonly, nonatomic) id<GTCShapeScheming> shapeScheme;

@end

/** Defines the cards style data that will be applied to a card by a themer. */
@interface GTCCardScheme : NSObject <GTCCardScheming>

// Redeclare protocol properties as readwrite
@property(nonnull, readwrite, nonatomic) GTCSemanticColorScheme *colorScheme;
@property(nonnull, readwrite, nonatomic) GTCShapeScheme *shapeScheme;

@end


