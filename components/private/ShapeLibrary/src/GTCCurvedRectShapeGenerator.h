//
//  GTCCurvedRectShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A curved rectangle shape generator.
 */
@interface GTCCurvedRectShapeGenerator : NSObject <GTCShapeGenerating>

/**
 The size of the curved corner.
 */
@property(nonatomic, assign) CGSize cornerSize;

/**
 Initializes an GTCCurvedRectShapeGenerator instance with a given cornerSize.
 */
- (instancetype)initWithCornerSize:(CGSize)cornerSize NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

