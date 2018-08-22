//
//  GTCInkLayer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/20.
//

#import "GTCInkLayer.h"
#import "GTMath.h"

static NSString *const GTCInkLayerAnimationDelegateClassNameKey = @"GTCInkLayerAnimationDelegateClassNameKey";
static NSString *const GTCInkLayerAnimationDelegateKey = @"GTCInkLayerAnimationDelegateKey";
static NSString *const GTCInkLayerEndAnimationDelayKey = @"GTCInkLayerEndAnimationDelayKey";
static NSString *const GTCInkLayerFinalRadiusKey = @"GTCInkLayerFinalRadiusKey";
static NSString *const GTCInkLayerInitialRadiusKey = @"GTCInkLayerInitialRadiusKey";
static NSString *const GTCInkLayerMaxRippleRadiusKey = @"GTCInkLayerMaxRippleRadiusKey";
static NSString *const GTCInkLayerInkColorKey = @"GTCInkLayerInkColorKey";

static const CGFloat GTCInkLayerCommonDuration = 0.083f;
static const CGFloat GTCInkLayerEndFadeOutDuration = 0.15f;
static const CGFloat GTCInkLayerStartScalePositionDuration = 0.333f;
static const CGFloat GTCInkLayerStartFadeHalfDuration = 0.167f;
static const CGFloat GTCInkLayerStartFadeHalfBeginTimeFadeOutDuration = 0.25f;

static const CGFloat GTCInkLayerScaleStartMin = 0.2f;
static const CGFloat GTCInkLayerScaleStartMax = 0.6f;
static const CGFloat GTCInkLayerScaleDivisor = 300.f;

static NSString *const GTCInkLayerOpacityString = @"opacity";
static NSString *const GTCInkLayerPositionString = @"position";
static NSString *const GTCInkLayerScaleString = @"transform.scale";

@implementation GTCInkLayer

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        _endAnimationDelay = 0;
        _finalRadius = 0;
        _initialRadius = 0;
        _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
        _startAnimationActive = NO;
        if ([layer isKindOfClass:[GTCInkLayer class]]) {
            GTCInkLayer *inkLayer = (GTCInkLayer *)layer;
            _endAnimationDelay = inkLayer.endAnimationDelay;
            _finalRadius = inkLayer.finalRadius;
            _initialRadius = inkLayer.initialRadius;
            _maxRippleRadius = inkLayer.maxRippleRadius;
            _inkColor = inkLayer.inkColor;
            _startAnimationActive = NO;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        NSString *delegateClassName;
        if ([aDecoder containsValueForKey:GTCInkLayerAnimationDelegateClassNameKey]) {
            delegateClassName = [aDecoder decodeObjectOfClass:[NSString class]
                                                       forKey:GTCInkLayerAnimationDelegateClassNameKey];
        }
        if (delegateClassName.length > 0 &&
            [aDecoder containsValueForKey:GTCInkLayerAnimationDelegateKey]) {
            _animationDelegate = [aDecoder decodeObjectOfClass:NSClassFromString(delegateClassName)
                                                        forKey:GTCInkLayerAnimationDelegateKey];
        }
        if ([aDecoder containsValueForKey:GTCInkLayerInkColorKey]) {
            _inkColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTCInkLayerInkColorKey];
        } else {
            _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
        }
        if ([aDecoder containsValueForKey:GTCInkLayerEndAnimationDelayKey]) {
            _endAnimationDelay = (CGFloat)[aDecoder decodeDoubleForKey:GTCInkLayerEndAnimationDelayKey];
        }
        if ([aDecoder containsValueForKey:GTCInkLayerFinalRadiusKey]) {
            _finalRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTCInkLayerFinalRadiusKey];
        }
        if ([aDecoder containsValueForKey:GTCInkLayerInitialRadiusKey]) {
            _initialRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTCInkLayerInitialRadiusKey];
        }
        if ([aDecoder containsValueForKey:GTCInkLayerMaxRippleRadiusKey]) {
            _maxRippleRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTCInkLayerMaxRippleRadiusKey];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    if (self.animationDelegate && [self.animationDelegate conformsToProtocol:@protocol(NSCoding)]) {
        [aCoder encodeObject:NSStringFromClass([self.animationDelegate class])
                      forKey:GTCInkLayerAnimationDelegateClassNameKey];
        [aCoder encodeObject:self.animationDelegate forKey:GTCInkLayerAnimationDelegateKey];
    }
    [aCoder encodeDouble:self.endAnimationDelay forKey:GTCInkLayerEndAnimationDelayKey];
    [aCoder encodeDouble:self.finalRadius forKey:GTCInkLayerFinalRadiusKey];
    [aCoder encodeDouble:self.initialRadius forKey:GTCInkLayerInitialRadiusKey];
    [aCoder encodeDouble:self.maxRippleRadius forKey:GTCInkLayerMaxRippleRadiusKey];
    [aCoder encodeObject:self.inkColor forKey:GTCInkLayerInkColorKey];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setRadiiWithRect:self.bounds];
}

- (void)setRadiiWithRect:(CGRect)rect {
    self.initialRadius = (CGFloat)(GTCHypot(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 * 0.6f);
    self.finalRadius = (CGFloat)(GTCHypot(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 + 10.f);
}

- (void)startAnimationAtPoint:(CGPoint)point {
    [self startInkAtPoint:point animated:YES];
}

- (void)startInkAtPoint:(CGPoint)point animated:(BOOL)animated {
    CGFloat radius = self.finalRadius;
    if (self.maxRippleRadius > 0) {
        radius = self.maxRippleRadius;
    }
    CGRect ovalRect = CGRectMake(CGRectGetWidth(self.bounds) / 2 - radius,
                                 CGRectGetHeight(self.bounds) / 2 - radius,
                                 radius * 2,
                                 radius * 2);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    self.path = circlePath.CGPath;
    self.fillColor = self.inkColor.CGColor;
    if (!animated) {
        self.opacity = 1;
        self.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    } else {
        self.opacity = 0;
        self.position = point;
        _startAnimationActive = YES;

        CAMediaTimingFunction *materialTimingFunction =
        [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0:0.2f:1.f];

        CGFloat scaleStart =
        MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / GTCInkLayerScaleDivisor;
        if (scaleStart < GTCInkLayerScaleStartMin) {
            scaleStart = GTCInkLayerScaleStartMin;
        } else if (scaleStart > GTCInkLayerScaleStartMax) {
            scaleStart = GTCInkLayerScaleStartMax;
        }

        CABasicAnimation *scaleAnim = [[CABasicAnimation alloc] init];
        scaleAnim.keyPath = GTCInkLayerScaleString;
        scaleAnim.fromValue = @(scaleStart);
        scaleAnim.toValue = @1.0f;
        scaleAnim.duration = GTCInkLayerStartScalePositionDuration;
        scaleAnim.beginTime = GTCInkLayerCommonDuration;
        scaleAnim.timingFunction = materialTimingFunction;
        scaleAnim.fillMode = kCAFillModeForwards;
        scaleAnim.removedOnCompletion = NO;

        UIBezierPath *centerPath = [UIBezierPath bezierPath];
        CGPoint startPoint = point;
        CGPoint endPoint = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        [centerPath moveToPoint:startPoint];
        [centerPath addLineToPoint:endPoint];
        [centerPath closePath];

        CAKeyframeAnimation *positionAnim = [[CAKeyframeAnimation alloc] init];
        positionAnim.keyPath = GTCInkLayerPositionString;
        positionAnim.path = centerPath.CGPath;
        positionAnim.keyTimes = @[ @0, @1.0f ];
        positionAnim.values = @[ @0, @1.0f ];
        positionAnim.duration = GTCInkLayerStartScalePositionDuration;
        positionAnim.beginTime = GTCInkLayerCommonDuration;
        positionAnim.timingFunction = materialTimingFunction;
        positionAnim.fillMode = kCAFillModeForwards;
        positionAnim.removedOnCompletion = NO;

        CABasicAnimation *fadeInAnim = [[CABasicAnimation alloc] init];
        fadeInAnim.keyPath = GTCInkLayerOpacityString;
        fadeInAnim.fromValue = @0;
        fadeInAnim.toValue = @1.0f;
        fadeInAnim.duration = GTCInkLayerCommonDuration;
        fadeInAnim.beginTime = GTCInkLayerCommonDuration;
        fadeInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        fadeInAnim.fillMode = kCAFillModeForwards;
        fadeInAnim.removedOnCompletion = NO;

        [CATransaction begin];
        CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
        animGroup.animations = @[ scaleAnim, positionAnim, fadeInAnim ];
        animGroup.duration = GTCInkLayerStartScalePositionDuration;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.removedOnCompletion = NO;
        [CATransaction setCompletionBlock:^{
            self->_startAnimationActive = NO;
        }];
        [self addAnimation:animGroup forKey:nil];
        [CATransaction commit];
    }
    if ([self.animationDelegate respondsToSelector:@selector(inkLayerAnimationDidStart:)]) {
        [self.animationDelegate inkLayerAnimationDidStart:self];
    }
}

- (void)changeAnimationAtPoint:(CGPoint)point {
    CGFloat animationDelay = 0;
    if (self.startAnimationActive) {
        animationDelay = GTCInkLayerStartFadeHalfBeginTimeFadeOutDuration +
        GTCInkLayerStartFadeHalfDuration;
    }

    BOOL viewContainsPoint = CGRectContainsPoint(self.bounds, point) ? YES : NO;
    CGFloat currOpacity = self.presentationLayer.opacity;
    CGFloat updatedOpacity = 0;
    if (viewContainsPoint) {
        updatedOpacity = 1.0f;
    }

    CABasicAnimation *changeAnim = [[CABasicAnimation alloc] init];
    changeAnim.keyPath = GTCInkLayerOpacityString;
    changeAnim.fromValue = @(currOpacity);
    changeAnim.toValue = @(updatedOpacity);
    changeAnim.duration = GTCInkLayerCommonDuration;
    changeAnim.beginTime = [self convertTime:(CACurrentMediaTime() + animationDelay) fromLayer:nil];
    changeAnim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    changeAnim.fillMode = kCAFillModeForwards;
    changeAnim.removedOnCompletion = NO;
    [self addAnimation:changeAnim forKey:nil];
}

- (void)endAnimationAtPoint:(CGPoint)point {
    [self endInkAtPoint:point animated:YES];
}

- (void)endInkAtPoint:(CGPoint)point animated:(BOOL)animated {
    if (self.startAnimationActive) {
        self.endAnimationDelay = GTCInkLayerStartFadeHalfBeginTimeFadeOutDuration;
    }

    CGFloat opacity = 1.0f;
    BOOL viewContainsPoint = CGRectContainsPoint(self.bounds, point) ? YES : NO;
    if (!viewContainsPoint) {
        opacity = 0;
    }

    if (!animated) {
        self.opacity = 0;
        if ([self.animationDelegate respondsToSelector:@selector(inkLayerAnimationDidEnd:)]) {
            [self.animationDelegate inkLayerAnimationDidEnd:self];
        }
        [self removeFromSuperlayer];
    } else {
        [CATransaction begin];
        CABasicAnimation *fadeOutAnim = [[CABasicAnimation alloc] init];
        fadeOutAnim.keyPath = GTCInkLayerOpacityString;
        fadeOutAnim.fromValue = @(opacity);
        fadeOutAnim.toValue = @0;
        fadeOutAnim.duration = GTCInkLayerEndFadeOutDuration;
        fadeOutAnim.beginTime = [self convertTime:(CACurrentMediaTime() + self.endAnimationDelay)
                                        fromLayer:nil];
        fadeOutAnim.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        fadeOutAnim.fillMode = kCAFillModeForwards;
        fadeOutAnim.removedOnCompletion = NO;
        [CATransaction setCompletionBlock:^{
            if ([self.animationDelegate respondsToSelector:@selector(inkLayerAnimationDidEnd:)]) {
                [self.animationDelegate inkLayerAnimationDidEnd:self];
            }
            [self removeFromSuperlayer];
        }];
        [self addAnimation:fadeOutAnim forKey:nil];
        [CATransaction commit];
    }
}

@end
