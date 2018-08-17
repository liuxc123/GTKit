//
//  GTCSlantedRectShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "GTShapes.h"

/**
 A slanted rectangle shape generator.

 Creates rectangles with the vertical edges at a slant.
 */
@interface GTCSlantedRectShapeGenerator : NSObject <GTCShapeGenerating>

/**
 The horizontal offset of the corners.
 */
@property(nonatomic, assign) CGFloat slant;

@end
