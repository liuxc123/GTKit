//
//  GTCTabBarIndicatorView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCTabBarIndicatorView.h"

#import "GTCTabBarIndicatorAttributes.h"

/** Content view that displays a filled path and supports animation between states. */
@interface GTCTabBarIndicatorShapeView: UIView

/** The path to display. It will be filled using the view's tintColor. */
@property(nonatomic, nullable) UIBezierPath *path;

@end

@implementation GTCTabBarIndicatorView {
    /// View responsible for drawing the indicator's path.
    GTCTabBarIndicatorShapeView *_shapeView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCTabBarIndicatorViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCTabBarIndicatorViewInit];
    }
    return self;
}

#pragma mark - Public

- (void)applySelectionIndicatorAttributes:(GTCTabBarIndicatorAttributes *)attributes {
    _shapeView.path = attributes.path;
}

#pragma mark - Private

- (void)commonGTCTabBarIndicatorViewInit {
    // Fill the indicator with the shape.
    _shapeView = [[GTCTabBarIndicatorShapeView alloc] initWithFrame:self.bounds];
    _shapeView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_shapeView];
}

@end

#pragma mark -

@implementation GTCTabBarIndicatorShapeView

- (UIBezierPath *)path {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    CGPathRef cgPath = shapeLayer.path;
    return cgPath ? [UIBezierPath bezierPathWithCGPath:cgPath] : nil;
}

- (void)setPath:(UIBezierPath *)path {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.path = path.CGPath;
}

#pragma mark - CALayerDelegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    id<CAAction> action = [super actionForLayer:layer forKey:event];
    // Support implicit animation of paths.
    if ((!action || action == [NSNull null]) && (layer == self.layer) && [event isEqual:@"path"]) {
        return [CABasicAnimation animationWithKeyPath:event];
    }
    return action;
}

#pragma mark - UIView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    // Update layer fill color
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.fillColor = self.tintColor.CGColor;
}

@end

