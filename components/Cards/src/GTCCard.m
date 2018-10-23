//
//  GTCCard.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCard.h"


#import "GTMath.h"
#import "GTShapes.h"

static const CGFloat GTCCardShadowElevationNormal = 1.f;
static const CGFloat GTCCardShadowElevationHighlighted = 8.f;
static const CGFloat GTCCardCornerRadiusDefault = 4.f;
static const BOOL GTCCardIsInteractableDefault = YES;

@interface GTCCard ()
@property(nonatomic, readonly, strong) GTCShapedShadowLayer *layer;
@end

@implementation GTCCard {
    NSMutableDictionary<NSNumber *, NSNumber *> *_shadowElevations;
    NSMutableDictionary<NSNumber *, UIColor *> *_shadowColors;
    NSMutableDictionary<NSNumber *, NSNumber *> *_borderWidths;
    NSMutableDictionary<NSNumber *, UIColor *> *_borderColors;
    UIColor *_backgroundColor;
    CGPoint _lastTouch;
}

@dynamic layer;

+ (Class)layerClass {
    return [GTCShapedShadowLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonGTCCardInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCCardInit];
    }
    return self;
}

- (void)commonGTCCardInit {
    self.layer.cornerRadius = GTCCardCornerRadiusDefault;
    _interactable = GTCCardIsInteractableDefault;

    if (_inkView == nil) {
        _inkView = [[GTCInkView alloc] initWithFrame:self.bounds];
        _inkView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight);
        _inkView.usesLegacyInkRipple = NO;
        _inkView.layer.zPosition = FLT_MAX;
        [self addSubview:_inkView];
    }

    if (_shadowElevations == nil) {
        _shadowElevations = [NSMutableDictionary dictionary];
        _shadowElevations[@(UIControlStateNormal)] = @(GTCCardShadowElevationNormal);
        _shadowElevations[@(UIControlStateHighlighted)] = @(GTCCardShadowElevationHighlighted);
    }

    if (_shadowColors == nil) {
        _shadowColors = [NSMutableDictionary dictionary];
        _shadowColors[@(UIControlStateNormal)] = UIColor.blackColor;
    }

    if (_borderColors == nil) {
        _borderColors = [NSMutableDictionary dictionary];
    }

    if (_borderWidths == nil) {
        _borderWidths = [NSMutableDictionary dictionary];
    }

    if (_backgroundColor == nil) {
        _backgroundColor = UIColor.whiteColor;
    }

    [self updateShadowElevation];
    [self updateShadowColor];
    [self updateBorderWidth];
    [self updateBorderColor];
    [self updateBackgroundColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.layer.shapeGenerator) {
        self.layer.shadowPath = [self boundingPath].CGPath;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (UIBezierPath *)boundingPath {
    CGFloat cornerRadius = self.cornerRadius;
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
}

- (GTCShadowElevation)shadowElevationForState:(UIControlState)state {
    NSNumber *elevation = _shadowElevations[@(state)];
    if (state != UIControlStateNormal && elevation == nil) {
        elevation = _shadowElevations[@(UIControlStateNormal)];
    }
    if (elevation != nil) {
        return (CGFloat)[elevation doubleValue];
    }
    return 0;
}

- (void)setShadowElevation:(GTCShadowElevation)shadowElevation forState:(UIControlState)state {
    _shadowElevations[@(state)] = @(shadowElevation);

    [self updateShadowElevation];
}

- (void)updateShadowElevation {
    CGFloat elevation = [self shadowElevationForState:self.state];
    if (!GTCCGFloatEqual(((GTCShadowLayer *)self.layer).elevation, elevation)) {
        if (!self.layer.shapeGenerator) {
            self.layer.shadowPath = [self boundingPath].CGPath;
        }
        [(GTCShadowLayer *)self.layer setElevation:elevation];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth forState:(UIControlState)state {
    _borderWidths[@(state)] = @(borderWidth);

    [self updateBorderWidth];
}

- (void)updateBorderWidth {
    CGFloat borderWidth = [self borderWidthForState:self.state];
    self.layer.shapedBorderWidth = borderWidth;
}

- (CGFloat)borderWidthForState:(UIControlState)state {
    NSNumber *borderWidth = _borderWidths[@(state)];
    if (state != UIControlStateNormal && borderWidth == nil) {
        borderWidth = _borderWidths[@(UIControlStateNormal)];
    }
    if (borderWidth != nil) {
        return (CGFloat)[borderWidth doubleValue];
    }
    return 0;
}

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state {
    _borderColors[@(state)] = borderColor;

    [self updateBorderColor];
}

- (void)updateBorderColor {
    UIColor *borderColor = [self borderColorForState:self.state];
    self.layer.shapedBorderColor = borderColor;
}

- (UIColor *)borderColorForState:(UIControlState)state {
    UIColor *borderColor = _borderColors[@(state)];
    if (state != UIControlStateNormal && borderColor == nil) {
        borderColor = _borderColors[@(UIControlStateNormal)];
    }
    return borderColor;
}

- (void)setShadowColor:(UIColor *)shadowColor forState:(UIControlState)state {
    _shadowColors[@(state)] = shadowColor;

    [self updateShadowColor];
}

- (void)updateShadowColor {
    CGColorRef shadowColor = [self shadowColorForState:self.state].CGColor;
    self.layer.shadowColor = shadowColor;
}

- (UIColor *)shadowColorForState:(UIControlState)state {
    UIColor *shadowColor = _shadowColors[@(state)];
    if (state != UIControlStateNormal && shadowColor == nil) {
        shadowColor = _shadowColors[@(UIControlStateNormal)];
    }
    if (shadowColor != nil) {
        return shadowColor;
    }
    return [UIColor blackColor];
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted && !self.highlighted) {
        [self.inkView startTouchBeganAnimationAtPoint:_lastTouch completion:nil];
    } else if (!highlighted && self.highlighted) {
        [self.inkView startTouchEndedAnimationAtPoint:_lastTouch completion:nil];
    }
    [super setHighlighted:highlighted];
    [self updateShadowElevation];
    [self updateBorderColor];
    [self updateBorderWidth];
    [self updateShadowColor];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    BOOL beginTracking = [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint location = [touch locationInView:self];
    _lastTouch = location;
    return beginTracking;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (!_interactable && result == self) {
        return nil;
    }
    if (self.layer.shapeGenerator) {
        if (!CGPathContainsPoint(self.layer.shapeLayer.path, nil, point, true)) {
            return nil;
        }
    }
    return result;
}

- (void)setShapeGenerator:(id<GTCShapeGenerating>)shapeGenerator {
    if (shapeGenerator) {
        self.layer.shadowPath = nil;
    } else {
        self.layer.shadowPath = [self boundingPath].CGPath;
    }

    self.layer.shapeGenerator = shapeGenerator;
    self.layer.shadowMaskEnabled = NO;
    [self updateBackgroundColor];
    [self updateInkForShape];
}

- (id<GTCShapeGenerating>)shapeGenerator {
    return self.layer.shapeGenerator;
}

- (void)updateInkForShape {
    CGRect boundingBox = CGPathGetBoundingBox(self.layer.shapeLayer.path);
    self.inkView.maxRippleRadius =
    (CGFloat)(GTCHypot(CGRectGetHeight(boundingBox), CGRectGetWidth(boundingBox)) / 2 + 10.f);
    self.inkView.layer.masksToBounds = NO;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self updateBackgroundColor];
}

- (UIColor *)backgroundColor {
    return _backgroundColor;
}

- (void)updateBackgroundColor {
    self.layer.shapedBackgroundColor = _backgroundColor;
}

@end
