//
//  UIView+GTCTimingFunction.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import "UIView+GTCTimingFunction.h"

@implementation UIView (GTCTimingFunction)

+ (void)gtc_animateWithTimingFunction:(CAMediaTimingFunction *)timingFunction
                             duration:(NSTimeInterval)duration
                                delay:(NSTimeInterval)delay
                              options:(UIViewAnimationOptions)options
                           animations:(void (^)(void))animations
                           completion:(void (^)(BOOL finished))completion {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:timingFunction];
    [UIView animateWithDuration:duration
                          delay:delay
                        options:options
                     animations:animations
                     completion:completion];
    [CATransaction commit];
}

@end
