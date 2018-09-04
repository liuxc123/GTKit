//
//  GTCIntrinsicHeightTextView.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import "GTCIntrinsicHeightTextView.h"

@implementation GTCIntrinsicHeightTextView

/**
 When a value in the CGSize of intrinsicContentSize is -1, it's considered undefined. For the
 GTCMultilineTextField, we want this to always be defined so our layouts are not ambiguous.
 */
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if (size.height == UIViewNoIntrinsicMetric) {
        size.height = [self contentSize].height;
    }
    return size;
}

@end
