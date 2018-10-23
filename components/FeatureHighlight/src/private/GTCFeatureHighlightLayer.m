//
//  GTCFeatureHighlightLayer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import "GTCFeatureHighlightLayer.h"

#import <UIKit/UIKit.h>

@implementation GTCFeatureHighlightLayer {
    CGFloat _radius;
}

- (void)setPosition:(CGPoint)position animated:(BOOL)animated {
    if (CGPointEqualToPoint(self.position , position)) {
        return;
    }
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = [CATransaction animationDuration];
        animation.timingFunction = [CATransaction animationTimingFunction];
        animation.fromValue = [NSValue valueWithCGPoint:self.position];
        animation.toValue = [NSValue valueWithCGPoint:position];
        [self addAnimation:animation forKey:@"position"];
    }
    self.position = position;
}

- (void)setRadius:(CGFloat)radius animated:(BOOL)animated {
    if (_radius == radius) {
        return;
    }
    _radius = radius;

    CGRect circleRect = CGRectMake(-radius, -radius, radius * 2, radius * 2);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = [CATransaction animationDuration];
        animation.timingFunction = [CATransaction animationTimingFunction];
        if (self.path) {
            animation.fromValue = (__bridge id)self.path;
        } else {
            animation.fromValue = CFBridgingRelease(
                                                    CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 0, 0), NULL));
        }
        self.path = (__bridge CGPathRef _Nullable)CFBridgingRelease(
                                                                    CGPathCreateWithEllipseInRect(circleRect, NULL));
        [self addAnimation:animation forKey:@"path"];
    } else {
        self.path = (__bridge CGPathRef _Nullable)CFBridgingRelease(
                                                                    CGPathCreateWithEllipseInRect(circleRect, NULL));
    }
}

- (void)setFillColor:(CGColorRef)fillColor animated:(BOOL)animated {
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        animation.duration = [CATransaction animationDuration];
        animation.timingFunction = [CATransaction animationTimingFunction];
        animation.fromValue = (__bridge id)self.fillColor;
        self.fillColor = fillColor;
        [self addAnimation:animation forKey:@"fillColor"];
    } else {
        self.fillColor = fillColor;
    }
}

- (void)animateRadiusOverKeyframes:(NSArray *)radii
                          keyTimes:(NSArray *)keyTimes {
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:radii.count];
    for (NSNumber *radius in radii) {
        CGFloat r = radius.floatValue;
        CGRect circleRect = CGRectMake(-r, -r, r * 2, r * 2);
        [values addObject:CFBridgingRelease(CGPathCreateWithEllipseInRect(circleRect, NULL))];
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    animation.duration = [CATransaction animationDuration];
    animation.timingFunction = [CATransaction animationTimingFunction];
    animation.values = values;
    animation.keyTimes = keyTimes;
    [self addAnimation:animation forKey:@"path"];
}

- (void)animateFillColorOverKeyframes:(NSArray *)colors keyTimes:(NSArray *)keyTimes {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    animation.duration = [CATransaction animationDuration];
    animation.timingFunction = [CATransaction animationTimingFunction];
    animation.values = colors;
    animation.keyTimes = keyTimes;
    [self addAnimation:animation forKey:@"fillColor"];
}

@end

