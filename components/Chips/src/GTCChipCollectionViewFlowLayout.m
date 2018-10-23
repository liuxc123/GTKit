//
//  GTCChipCollectionViewFlowLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTCChipCollectionViewFlowLayout.h"

/* Left aligns one rect to another with a given padding */
static inline CGRect CGRectLeftAlignToRect(CGRect rect, CGRect staticRect, CGFloat padding) {
    return CGRectMake(CGRectGetMaxX(staticRect) + padding,
                      CGRectGetMinY(rect),
                      CGRectGetWidth(rect),
                      CGRectGetHeight(rect));
}

static inline CGRect CGRectLeftAlign(CGRect rect) {
    return CGRectMake(0,
                      CGRectGetMinY(rect),
                      CGRectGetWidth(rect),
                      CGRectGetHeight(rect));
}

@implementation GTCChipCollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *customLayoutAttributes =
    [NSMutableArray arrayWithCapacity:layoutAttributes.count];

    if (layoutAttributes.count > 0) {
        UICollectionViewLayoutAttributes *attrs = [layoutAttributes[0] copy];
        attrs.frame = CGRectLeftAlign(attrs.frame);
        [customLayoutAttributes addObject:attrs];
    }

    for (NSUInteger i = 1; i < layoutAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attrs = [layoutAttributes[i] copy];
        UICollectionViewLayoutAttributes *prevAttrs = customLayoutAttributes[i - 1];

        if (CGRectGetMinY(prevAttrs.frame) == CGRectGetMinY(attrs.frame)) {
            attrs.frame =
            CGRectLeftAlignToRect(attrs.frame, prevAttrs.frame, self.minimumInteritemSpacing);
        } else {
            attrs.frame = CGRectLeftAlign(attrs.frame);
        }
        [customLayoutAttributes addObject:attrs];
    }

    return [customLayoutAttributes copy];
}

- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return YES;
}

@end

