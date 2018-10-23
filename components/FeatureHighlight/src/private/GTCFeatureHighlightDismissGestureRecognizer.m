//
//  GTCFeatureHighlightDismissGestureRecognizer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

#import "GTCFeatureHighlightDismissGestureRecognizer.h"
#import "GTCFeatureHighlightView+Private.h"

#import "GTMath.h"

@interface GTCFeatureHighlightDismissGestureRecognizer ()

@property(nullable, nonatomic, readonly) GTCFeatureHighlightView *view;

@end

@implementation GTCFeatureHighlightDismissGestureRecognizer {
    CGFloat _startProgress;
    CGFloat _previousProgress;
    NSTimeInterval _eventTimeStamp;
    NSTimeInterval _previousEventTimeStamp;
    BOOL _hasTouch;
}

@dynamic view;

- (void)reset {
    [super reset];

    _hasTouch = NO;
    _velocity = 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSCAssert([self.view isKindOfClass:[GTCFeatureHighlightView class]],
              @"%@ was attached to a view not of type GTCFeatureHighlightView", self);

    if (_hasTouch) {
        for (UITouch *touch in touches) {
            [self ignoreTouch:touch forEvent:event];
        }
        return;
    }

    [super touchesBegan:touches withEvent:event];

    _hasTouch = YES;
    _startProgress = [self dismissPercentOfTouches:touches];
    _progress = _previousProgress = 1;
    _eventTimeStamp = _previousEventTimeStamp = event.timestamp;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    // first touch that can be considered a pan
    if (self.state == UIGestureRecognizerStatePossible && !GTCCGFloatEqual(_progress, 1.0)) {
        self.state = UIGestureRecognizerStateBegan;
    }

    _previousEventTimeStamp = _eventTimeStamp;
    _eventTimeStamp = event.timestamp;

    NSTimeInterval deltaTime = _eventTimeStamp - _previousEventTimeStamp;
    if (deltaTime > 0) {
        _velocity = (CGFloat)((_progress - _previousProgress) / deltaTime);
    }

    [self updateState:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (_hasTouch) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    if (_hasTouch) {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (void)updateState:(NSSet<UITouch *> *)touches {
    _previousProgress = _progress;
    CGFloat newProgress = [self dismissPercentOfTouches:touches];
    if (newProgress < _startProgress) {
        _startProgress = newProgress;
    }
    _progress = 1.0f - [self dismissPercentOfTouches:touches] + _startProgress;
    _progress = MIN(1.0f, MAX(0.0f, _progress));
}

- (CGFloat)progressForTouchPosition:(CGPoint)touchPos {
    CGPoint c1 = self.view.highlightCenter;
    CGPoint c2 = self.view.highlightPoint;
    CGFloat r1 = self.view.highlightRadius;
    CGFloat r2 = 0;
    CGPoint p = touchPos;

    // Center and radius as paramaterized functions of t
    // c(t) = c1 + (c2 - c1)t
    // r(t) = r1 + (r2 - r1)t

    // Radius in terms of distance from the center to the touch point
    // r(t) = ||c(t) - p)||
    // r(t)^2 = || c(t) - p ||^2
    // r(t)^2 = (c(t).x - p.x)^2 + (c(t).y - p.y)^2
    // (r1 + (r2 - r1)t)^2 = (c1.x + (c2.x - c1.x)t - p.x)^2 + (c1.y + (c2.y - c1.y)t - p.y)^2

    // r1^2 + 2r1(r2 - r1)t + (r2 - r1)^2*t^2
    //   = c1.x^2 + 2c1.x(c2.x - c1.x)t - 2c1.x*p.x - 2(c2.x - c1.x)t*p.x + (c2.x - c1.x)^2t^2 + p.x^2
    //   + c1.y^2 + 2c1.y(c2.y - c1.y)t - 2c1.y*p.y - 2(c2.y - c1.y)t*p.y + (c2.y - c1.y)^2t^2 + p.y^2

    // Moving everything to left side so that ... = 0
    // r1^2 + 2r1(r2 - r1)t + (r2 - r1)^2*t^2
    // - c1.x^2 - 2c1.x(c2.x - c1.x)t + 2c1.x*p.x + 2(c2.x - c1.x)t*p.x - (c2.x - c1.x)^2t^2 - p.x^2
    // - c1.y^2 - 2c1.y(c2.y - c1.y)t + 2c1.y*p.y + 2(c2.y - c1.y)t*p.y - (c2.y - c1.y)^2t^2 - p.y^2
    //  = 0

    // Now compute in the form at^2 + bt + c = 0
    // a = (r2 - r1)^2 - (c2.x - c1.x)^2 - (c2.y - c1.y)^2
    CGFloat a = GTCPow(r2 - r1, 2) - GTCPow(c2.x - c1.x, 2) - GTCPow(c2.y - c1.y, 2);
    // b = 2r1(r2 - r1) - 2c1.x(c2.x - c1.x) + 2(c2.x - c1.x)p.x - 2c1.y(c2.y - c1.y) + 2(c2.y - c1.y)p.y
    CGFloat b = 2*r1*(r2 - r1) - 2*c1.x*(c2.x - c1.x) + 2*(c2.x - c1.x)*p.x - 2*c1.y*(c2.y - c1.y)
    + 2*(c2.y - c1.y)*p.y;
    // c = r1^2 - c1.x^2 + 2c1.x*p.x - p.x^2 - c1.y^2 + 2c1.y*p.y - p.y^2
    CGFloat c = GTCPow(r1, 2) - GTCPow(c1.x, 2) + 2*c1.x*p.x - GTCPow(p.x, 2) - GTCPow(c1.y, 2)
    + 2*c1.y*p.y - GTCPow(p.y, 2);

    // Apply the quadratic equation
    CGFloat t = (-b - GTCSqrt(b*b - 4*a*c))/(2*a);

    return MIN(1, MAX(0, t));
}

- (CGFloat)dismissPercentOfTouches:(NSSet<UITouch *> *)touches {
    if (touches.count == 0) {
        return 0.0;
    }

    CGFloat dismissSum = 0;
    for (UITouch *touch in touches) {
        CGPoint touchPos = [touch locationInView:self.view];
        dismissSum += [self progressForTouchPosition:touchPos];
    }

    CGFloat progress = dismissSum / touches.count;
    return MIN(1.0f, MAX(0.0f, progress));
}

@end
