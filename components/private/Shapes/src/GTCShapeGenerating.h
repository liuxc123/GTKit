//
//  GTCShapeGenerating.h
//  Pods
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

/**
 A protocol for objects that create closed CGPaths of varying sizes.
 */
@protocol GTCShapeGenerating <NSCopying, NSSecureCoding>

/**
 Creates a CGPath for the given size.

 @param size The expected size of the generated path.
 @return CGPathRef A closed path of the provided size. If size is empty, may return NULL.
 */
- (nullable CGPathRef)pathForSize:(CGSize)size;

@end
