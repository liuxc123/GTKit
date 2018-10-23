//
//  GTCThumbView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCThumbView.h"

#import "GTShadowElevations.h"
#import "GTShadowLayer.h"

@interface GTCThumbView ()

@property(nonatomic, strong) UIImageView *iconView;

@end

@implementation GTCThumbView

static const CGFloat kMinTouchSize = 48;

+ (Class)layerClass {
    return [GTCShadowLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // TODO: Remove once GTCShadowLayer is rasterized by default.
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setHasShadow:(BOOL)hasShadow {
    self.elevation = hasShadow ? GTCShadowElevationCardResting : GTCShadowElevationNone;
}

- (GTCShadowElevation)elevation {
    return [self shadowLayer].elevation;
}

- (void)setElevation:(GTCShadowElevation)elevation {
    [self shadowLayer].elevation = elevation;
}

- (GTCShadowLayer *)shadowLayer {
    return (GTCShadowLayer *)self.layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shadowPath =
    [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius].CGPath;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(__unused UIEvent *)event {
    CGFloat dx = MIN(0, _cornerRadius - kMinTouchSize / 2);
    // Converts point to presentation layer coordinate system so gesture will land on the right visual
    // position. Assuming superview is not animated.
    if (self.layer.presentationLayer) {
        point = [(CALayer *)self.layer.presentationLayer convertPoint:point
                                                            fromLayer:self.layer.modelLayer];
    }
    CGRect rect = CGRectInset(self.bounds, dx, dx);
    return CGRectContainsPoint(rect, point);
}

- (void)setIcon:(nullable UIImage *)icon {
    if (icon == _iconView.image || [icon isEqual:_iconView.image])
        return;

    if (_iconView) {
        [_iconView removeFromSuperview];
        _iconView = nil;
    }
    if (icon) {
        _iconView = [[UIImageView alloc] initWithImage:icon];
        [self addSubview:_iconView];
        // Calculate the inner square of the thumbs circle.
        CGFloat sideLength = (CGFloat)sin(45.0 / 180.0 * M_PI) * _cornerRadius * 2;
        CGFloat topLeft = _cornerRadius - (sideLength / 2);
        _iconView.frame = CGRectMake(topLeft, topLeft, sideLength, sideLength);
    }
}

@end

