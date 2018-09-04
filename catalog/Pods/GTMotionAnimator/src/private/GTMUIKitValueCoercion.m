//
//  GTMUIKitValueCoercion.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMUIKitValueCoercion.h"

#import <UIKit/UIKit.h>

static BOOL IsCGAffineTransformType(id someValue) {
    if ([someValue isKindOfClass:[NSValue class]]) {
        NSValue *asValue = (NSValue *)someValue;
        const char *objCType = @encode(CGAffineTransform);
        return strncmp(asValue.objCType, objCType, strlen(objCType)) == 0;
    }
    return NO;
}

NSArray* GTMCoerceUIKitValuesToCoreAnimationValues(NSArray *values) {
    if ([[values firstObject] isKindOfClass:[UIColor class]]) {
        NSMutableArray *convertedArray = [NSMutableArray arrayWithCapacity:values.count];
        for (UIColor *color in values) {
            [convertedArray addObject:(id)color.CGColor];
        }
        values = convertedArray;

    } else if ([[values firstObject] isKindOfClass:[UIBezierPath class]]) {
        NSMutableArray *convertedArray = [NSMutableArray arrayWithCapacity:values.count];
        for (UIBezierPath *bezierPath in values) {
            [convertedArray addObject:(id)bezierPath.CGPath];
        }
        values = convertedArray;

    } else if (IsCGAffineTransformType([values firstObject])) {
        NSMutableArray *convertedArray = [NSMutableArray arrayWithCapacity:values.count];
        for (NSValue *value in values) {
            CATransform3D asTransform3D = CATransform3DMakeAffineTransform(value.CGAffineTransformValue);
            [convertedArray addObject:[NSValue valueWithCATransform3D:asTransform3D]];
        }
        values = convertedArray;
    }
    return values;
}

