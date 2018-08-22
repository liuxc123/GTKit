//
//  GTCButtonBarButton.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import <UIKit/UIKit.h>

#import "GTCButtonBarButton.h"

static const CGFloat kMinimumItemWidth = 36.f;

@implementation GTCButtonBarButton


- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:size];
    fitSize.height = MAX(kMinimumItemWidth, fitSize.height);
    fitSize.width = MAX(kMinimumItemWidth, fitSize.width);

    return fitSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // TODO(featherless): Remove this conditional and always set the max ripple radius once
    // https://github.com/material-components/material-components-ios/issues/329 lands.
    if (self.inkStyle == GTCInkStyleUnbounded) {
        self.inkMaxRippleRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    } else {
        self.inkMaxRippleRadius = 0;
    }
}

// Because we are explicitly re-declaring this method in our header, we need to explictly
// re-define in our implementation. Therefore, this method just calls [super].
- (void)setTitleFont:(nullable UIFont *)font forState:(UIControlState)state {
    [super setTitleFont:font forState:state];
}


@end
