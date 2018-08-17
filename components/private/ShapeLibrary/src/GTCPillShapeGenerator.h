//
//  GTCPillShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <Foundation/Foundation.h>

#import "GTShapes.h"

/**
 A pill shape generator. Rounds the corners such that the shorter sides of the generated shape are
 entirely rounded.
 */
@interface GTCPillShapeGenerator : NSObject <GTCShapeGenerating>
@end
