//
//  GTCTabBarUnderlineIndicatorTemplate.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCTabBarUnderlineIndicatorTemplate.h"

#import "GTCTabBarIndicatorAttributes.h"
#import "GTCTabBarIndicatorContext.h"

/// Height in points of the underline shown under selected items.
static const CGFloat kUnderlineIndicatorHeight = 2.0f;

@implementation GTCTabBarUnderlineIndicatorTemplate

- (GTCTabBarIndicatorAttributes *)
indicatorAttributesForContext:(id<GTCTabBarIndicatorContext>)context {
    CGRect bounds = context.bounds;
    GTCTabBarIndicatorAttributes *attributes = [[GTCTabBarIndicatorAttributes alloc] init];
    CGRect underlineFrame = CGRectMake(CGRectGetMinX(bounds),
                                       CGRectGetMaxY(bounds) - kUnderlineIndicatorHeight,
                                       CGRectGetWidth(bounds),
                                       kUnderlineIndicatorHeight);
    attributes.path = [UIBezierPath bezierPathWithRect:underlineFrame];
    return attributes;
}

@end
