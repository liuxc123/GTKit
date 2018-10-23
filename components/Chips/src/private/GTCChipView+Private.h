//
//  GTCChipView+Private.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCChipView.h"

@interface GTCChipView (Private)

- (void)startTouchBeganAnimationAtPoint:(CGPoint)point;
- (void)startTouchEndedAnimationAtPoint:(CGPoint)point;
- (BOOL)willChangeSizeWithSelectedValue:(BOOL)selected;

@end
