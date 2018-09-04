//
//  GTMUIKitValueCoercion.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>

// Coerces the following UIKit/CoreGraphics values to Core Animation values:
//
// - UIBezierPath -> CGPath
// - UIColor -> CGColor
// - CGAffineTransform -> CATransform3D
//
// @param values All values of this array must be the same type.
FOUNDATION_EXPORT NSArray* GTMCoerceUIKitValuesToCoreAnimationValues(NSArray *values);
