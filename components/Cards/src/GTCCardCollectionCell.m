//
//  GTCCardCollectionCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCardCollectionCell.h"

#import "GTMath.h"
#import "GTIcons+ic_check_circle.h"
#import "GTShapes.h"

static NSString *const GTCCardCellBackgroundColorsKey = @"GTCCardCellBackgroundColorsKey";
static NSString *const GTCCardCellBorderWidthsKey = @"GTCCardCellBorderWidthsKey";
static NSString *const GTCCardCellBorderColorsKey = @"GTCCardCellBorderColorsKey";
static NSString *const GTCCardCellCornerRadiusKey = @"GTCCardCellCornerRadiusKey";
static NSString *const GTCCardCellHorizontalImageAlignmentsKey =
@"GTCCardCellHorizontalImageAlignmentsKey";
static NSString *const GTCCardCellImageTintColorsKey = @"GTCCardCellImageTintColorsKey";
static NSString *const GTCCardCellImagesKey = @"GTCCardCellImagesKey";
static NSString *const GTCCardCellInkViewKey = @"GTCCardCellInkViewKey";
static NSString *const GTCCardCellSelectableKey = @"GTCCardCellSelectableKey";
static NSString *const GTCCardCellSelectedImageViewKey = @"GTCCardCellSelectedImageViewKey";
static NSString *const GTCCardCellShadowElevationsKey = @"GTCCardCellShadowElevationsKey";
static NSString *const GTCCardCellShadowColorsKey = @"GTCCardCellShadowColorsKey";
static NSString *const GTCCardCellStateKey = @"GTCCardCellStateKey";
static NSString *const GTCCardCellVerticalImageAlignmentsKey =
@"GTCCardCellVerticalImageAlignmentsKey";
static NSString *const GTCCardCellIsInteractableKey = @"GTCCardCellIsInteractableKey";

static const CGFloat GTCCardCellCornerRadiusDefault = 4.f;
static const CGFloat GTCCardCellSelectedImagePadding = 8;
static const CGFloat GTCCardCellShadowElevationHighlighted = 8.f;
static const CGFloat GTCCardCellShadowElevationNormal = 1.f;
static const CGFloat GTCCardCellShadowElevationSelected = 8.f;
static const BOOL GTCCardCellIsInteractableDefault = YES;

@interface GTCCardCollectionCell ()
@property(nonatomic, strong, nullable) UIImageView *selectedImageView;
@property(nonatomic, readonly, strong) GTCShapedShadowLayer *layer;
@end

@implementation GTCCardCollectionCell  {
    NSMutableDictionary<NSNumber *, NSNumber *> *_shadowElevations;
    NSMutableDictionary<NSNumber *, UIColor *> *_shadowColors;
    NSMutableDictionary<NSNumber *, NSNumber *> *_borderWidths;
    NSMutableDictionary<NSNumber *, UIColor *> *_borderColors;
    NSMutableDictionary<NSNumber *, UIImage *> *_images;
    NSMutableDictionary<NSNumber *, NSNumber *> *_horizontalImageAlignments;
    NSMutableDictionary<NSNumber *, NSNumber *> *_verticalImageAlignments;
    NSMutableDictionary<NSNumber *, UIColor *> *_imageTintColors;
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
        _shadowElevations = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                                forKey:GTCCardCellShadowElevationsKey];
        _shadowColors = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                            forKey:GTCCardCellShadowColorsKey];
        _borderWidths = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                            forKey:GTCCardCellBorderWidthsKey];
        _borderColors = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                            forKey:GTCCardCellBorderColorsKey];
        _inkView = [coder decodeObjectOfClass:[GTCInkView class] forKey:GTCCardCellInkViewKey];
        _selectedImageView = [coder decodeObjectOfClass:[UIImageView class]
                                                 forKey:GTCCardCellSelectedImageViewKey];
        _state = [coder decodeIntegerForKey:GTCCardCellStateKey];
        _selectable = [coder decodeBoolForKey:GTCCardCellSelectableKey];
        _images = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                      forKey:GTCCardCellImagesKey];
        _horizontalImageAlignments =
        [coder decodeObjectOfClass:[NSMutableDictionary class]
                            forKey:GTCCardCellHorizontalImageAlignmentsKey];
        _verticalImageAlignments = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                                       forKey:GTCCardCellVerticalImageAlignmentsKey];
        _imageTintColors = [coder decodeObjectOfClass:[NSMutableDictionary class]
                                               forKey:GTCCardCellImageTintColorsKey];
        if ([coder containsValueForKey:GTCCardCellCornerRadiusKey]) {
            self.layer.cornerRadius = (CGFloat)[coder decodeDoubleForKey:GTCCardCellCornerRadiusKey];
        } else {
            self.layer.cornerRadius = GTCCardCellCornerRadiusDefault;
        }
        if ([coder containsValueForKey:GTCCardCellBackgroundColorsKey]) {
            [self.layer setShapedBackgroundColor:
             [coder decodeObjectOfClass:[UIColor class]
                                 forKey:GTCCardCellBackgroundColorsKey]];
        }
        if ([coder containsValueForKey:GTCCardCellIsInteractableKey]) {
            _interactable = [coder decodeBoolForKey:GTCCardCellIsInteractableKey];
        } else {
            _interactable = GTCCardCellIsInteractableDefault;
        }
        [self commonGTCCardCollectionCellInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = GTCCardCellCornerRadiusDefault;
        _interactable = GTCCardCellIsInteractableDefault;
        [self commonGTCCardCollectionCellInit];
    }
    return self;
}

- (void)commonGTCCardCollectionCellInit {
    if (_inkView == nil) {
        _inkView = [[GTCInkView alloc] initWithFrame:self.bounds];
        _inkView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _inkView.usesLegacyInkRipple = NO;
        _inkView.layer.zPosition = FLT_MAX;
        [self addSubview:_inkView];
    }

    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.layer.zPosition = _inkView.layer.zPosition - 1;
        _selectedImageView.autoresizingMask =
        (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin);
        [self.contentView addSubview:_selectedImageView];
        _selectedImageView.hidden = YES;
    }

    if (_shadowElevations == nil) {
        _shadowElevations = [NSMutableDictionary dictionary];
        _shadowElevations[@(GTCCardCellStateNormal)] = @(GTCCardCellShadowElevationNormal);
        _shadowElevations[@(GTCCardCellStateHighlighted)] = @(GTCCardCellShadowElevationHighlighted);
        _shadowElevations[@(GTCCardCellStateSelected)] = @(GTCCardCellShadowElevationSelected);
    }

    if (_shadowColors == nil) {
        _shadowColors = [NSMutableDictionary dictionary];
        _shadowColors[@(GTCCardCellStateNormal)] = UIColor.blackColor;
    }

    if (_borderColors == nil) {
        _borderColors = [NSMutableDictionary dictionary];
    }

    if (_borderWidths == nil) {
        _borderWidths = [NSMutableDictionary dictionary];
    }

    if (_images == nil) {
        _images = [NSMutableDictionary dictionary];
        UIImage *circledCheck = [GTCIcons imageFor_ic_check_circle];
        circledCheck = [circledCheck imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _images[@(GTCCardCellStateSelected)] = circledCheck;
    }

    if (_horizontalImageAlignments == nil) {
        _horizontalImageAlignments = [NSMutableDictionary dictionary];
        _horizontalImageAlignments[@(GTCCardCellStateNormal)] =
        @(GTCCardCellHorizontalImageAlignmentRight);
    }

    if (_verticalImageAlignments == nil) {
        _verticalImageAlignments = [NSMutableDictionary dictionary];
        _verticalImageAlignments[@(GTCCardCellStateNormal)] = @(GTCCardCellVerticalImageAlignmentTop);
    }

    if (_imageTintColors == nil) {
        _imageTintColors = [NSMutableDictionary dictionary];
    }

    if (_backgroundColor == nil) {
        _backgroundColor = UIColor.whiteColor;
    }

    [self updateShadowElevation];
    [self updateBorderColor];
    [self updateBorderWidth];
    [self updateShadowColor];
    [self updateImage];
    [self updateImageTintColor];
    [self updateBackgroundColor];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_shadowElevations forKey:GTCCardCellShadowElevationsKey];
    [coder encodeObject:_shadowColors forKey:GTCCardCellShadowColorsKey];
    [coder encodeObject:_borderWidths forKey:GTCCardCellBorderWidthsKey];
    [coder encodeObject:_borderColors forKey:GTCCardCellBorderColorsKey];
    [coder encodeObject:_inkView forKey:GTCCardCellInkViewKey];
    [coder encodeObject:_selectedImageView forKey:GTCCardCellSelectedImageViewKey];
    [coder encodeInteger:_state forKey:GTCCardCellStateKey];
    [coder encodeBool:_selectable forKey:GTCCardCellSelectableKey];
    [coder encodeDouble:self.layer.cornerRadius forKey:GTCCardCellCornerRadiusKey];
    [coder encodeObject:_images forKey:GTCCardCellImagesKey];
    [coder encodeObject:_horizontalImageAlignments forKey:GTCCardCellHorizontalImageAlignmentsKey];
    [coder encodeObject:_verticalImageAlignments forKey:GTCCardCellVerticalImageAlignmentsKey];
    [coder encodeObject:_imageTintColors forKey:GTCCardCellImageTintColorsKey];
    [coder encodeObject:self.layer.shapedBackgroundColor forKey:GTCCardCellBackgroundColorsKey];
    [coder encodeBool:_interactable forKey:GTCCardCellIsInteractableKey];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.layer.shapeGenerator) {
        self.layer.shadowPath = [self boundingPath].CGPath;
    }
    [self updateImageAlignment];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setState:(GTCCardCellState)state animated:(BOOL)animated {
    switch (state) {
        case GTCCardCellStateSelected: {
            if (_state != GTCCardCellStateHighlighted) {
                if (animated) {
                    [self.inkView startTouchBeganAnimationAtPoint:_lastTouch completion:nil];
                } else {
                    [self.inkView cancelAllAnimationsAnimated:NO];
                    [self.inkView startTouchBeganAtPoint:self.center
                                                animated:NO
                                          withCompletion:nil];
                }
            }
            break;
        }
        case GTCCardCellStateNormal: {
            [self.inkView startTouchEndAtPoint:_lastTouch
                                      animated:animated
                                withCompletion:nil];
            break;
        }
        case GTCCardCellStateHighlighted: {
            // Note: setHighlighted: can get getting more calls with YES than NO when clicking rapidly.
            // To guard against ink never going away and darkening our card we call
            // startTouchEndedAnimationAtPoint:completion:.
            [self.inkView startTouchEndedAnimationAtPoint:_lastTouch completion:nil];
            [self.inkView startTouchBeganAnimationAtPoint:_lastTouch completion:nil];
            break;
        }
    }
    _state = state;
    [self updateShadowElevation];
    [self updateBorderColor];
    [self updateBorderWidth];
    [self updateShadowColor];
    [self updateImage];
    [self updateImageAlignment];
    [self updateImageTintColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.selectable) {
        if (selected) {
            [self setState:GTCCardCellStateSelected animated:NO];
        } else {
            [self setState:GTCCardCellStateNormal animated:NO];
        }
    }
}

- (void)setSelectable:(BOOL)selectable {
    _selectable = selectable;
    self.selectedImageView.hidden = !selectable;
}

- (UIBezierPath *)boundingPath {
    CGFloat cornerRadius = self.cornerRadius;
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
}

- (GTCShadowElevation)shadowElevationForState:(GTCCardCellState)state {
    NSNumber *elevation = _shadowElevations[@(state)];
    if (state != GTCCardCellStateNormal && elevation == nil) {
        elevation = _shadowElevations[@(GTCCardCellStateNormal)];
    }
    if (elevation != nil) {
        return (CGFloat)[elevation doubleValue];
    }
    return 0;
}

- (void)setShadowElevation:(GTCShadowElevation)shadowElevation forState:(GTCCardCellState)state {
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

- (void)setBorderWidth:(CGFloat)borderWidth forState:(GTCCardCellState)state {
    _borderWidths[@(state)] = @(borderWidth);

    [self updateBorderWidth];
}

- (void)updateBorderWidth {
    CGFloat borderWidth = [self borderWidthForState:self.state];
    self.layer.shapedBorderWidth = borderWidth;
}

- (CGFloat)borderWidthForState:(GTCCardCellState)state {
    NSNumber *borderWidth = _borderWidths[@(state)];
    if (state != GTCCardCellStateNormal && borderWidth == nil) {
        borderWidth = _borderWidths[@(GTCCardCellStateNormal)];
    }
    if (borderWidth != nil) {
        return (CGFloat)[borderWidth doubleValue];
    }
    return 0;
}

- (void)setBorderColor:(UIColor *)borderColor forState:(GTCCardCellState)state {
    _borderColors[@(state)] = borderColor;

    [self updateBorderColor];
}

- (void)updateBorderColor {
    UIColor *borderColor = [self borderColorForState:self.state];
    self.layer.shapedBorderColor = borderColor;
}

- (UIColor *)borderColorForState:(GTCCardCellState)state {
    UIColor *borderColor = _borderColors[@(state)];
    if (state != GTCCardCellStateNormal && borderColor == nil) {
        borderColor = _borderColors[@(GTCCardCellStateNormal)];
    }
    return borderColor;
}

- (void)setShadowColor:(UIColor *)shadowColor forState:(GTCCardCellState)state {
    _shadowColors[@(state)] = shadowColor;

    [self updateShadowColor];
}

- (void)updateShadowColor {
    CGColorRef shadowColor = [self shadowColorForState:self.state].CGColor;
    self.layer.shadowColor = shadowColor;
}

- (UIColor *)shadowColorForState:(GTCCardCellState)state {
    UIColor *shadowColor = _shadowColors[@(state)];
    if (state != GTCCardCellStateNormal && shadowColor == nil) {
        shadowColor = _shadowColors[@(GTCCardCellStateNormal)];
    }
    if (shadowColor != nil) {
        return shadowColor;
    }
    return [UIColor blackColor];
}

- (void)setImage:(UIImage *)image forState:(GTCCardCellState)state {
    _images[@(state)] = image;

    [self updateImage];
}

- (void)updateImage {
    UIImage *image = [self imageForState:self.state];
    [self.selectedImageView setImage:image];
    [self.selectedImageView sizeToFit];
}

- (UIImage *)imageForState:(GTCCardCellState)state {
    UIImage *image = _images[@(state)];
    if (state != GTCCardCellStateNormal && image == nil) {
        image = _images[@(GTCCardCellStateNormal)];
    }
    return image;
}

- (void)setHorizontalImageAlignment:(GTCCardCellHorizontalImageAlignment)horizontalImageAlignment
                           forState:(GTCCardCellState)state {
    _horizontalImageAlignments[@(state)] = @(horizontalImageAlignment);

    [self updateImageAlignment];
}

- (GTCCardCellHorizontalImageAlignment)horizontalImageAlignmentForState:(GTCCardCellState)state {
    NSNumber *horizontalImageAlignment = _horizontalImageAlignments[@(state)];
    if (state != GTCCardCellStateNormal && horizontalImageAlignment == nil) {
        horizontalImageAlignment = _horizontalImageAlignments[@(GTCCardCellStateNormal)];
    }
    if (horizontalImageAlignment != nil) {
        return (GTCCardCellHorizontalImageAlignment)[horizontalImageAlignment integerValue];
    }
    return GTCCardCellHorizontalImageAlignmentRight;
}

- (void)setVerticalImageAlignment:(GTCCardCellVerticalImageAlignment)verticalImageAlignment
                         forState:(GTCCardCellState)state {
    _verticalImageAlignments[@(state)] = @(verticalImageAlignment);

    [self updateImageAlignment];
}

- (GTCCardCellVerticalImageAlignment)verticalImageAlignmentForState:(GTCCardCellState)state {
    NSNumber *verticalImageAlignment = _verticalImageAlignments[@(state)];
    if (state != GTCCardCellStateNormal && verticalImageAlignment == nil) {
        verticalImageAlignment = _verticalImageAlignments[@(GTCCardCellStateNormal)];
    }
    if (verticalImageAlignment != nil) {
        return (GTCCardCellVerticalImageAlignment)[verticalImageAlignment integerValue];
    }
    return GTCCardCellVerticalImageAlignmentTop;
}

- (void)updateImageAlignment {
    GTCCardCellVerticalImageAlignment verticalImageAlignment =
    [self verticalImageAlignmentForState:self.state];
    GTCCardCellHorizontalImageAlignment horizontalImageAlignment =
    [self horizontalImageAlignmentForState:self.state];

    CGFloat yAlignment = 0;
    CGFloat xAlignment = 0;

    switch (verticalImageAlignment) {
        case GTCCardCellVerticalImageAlignmentTop:
            yAlignment =
            GTCCardCellSelectedImagePadding + CGRectGetHeight(self.selectedImageView.frame)/2;
            break;
        case GTCCardCellVerticalImageAlignmentCenter:
            yAlignment = CGRectGetHeight(self.bounds)/2;
            break;
        case GTCCardCellVerticalImageAlignmentBottom:
            yAlignment = CGRectGetHeight(self.bounds) - GTCCardCellSelectedImagePadding -
            CGRectGetHeight(self.selectedImageView.frame)/2;
            break;
    }

    switch (horizontalImageAlignment) {
        case GTCCardCellHorizontalImageAlignmentLeft:
            xAlignment =
            GTCCardCellSelectedImagePadding + CGRectGetWidth(self.selectedImageView.frame)/2;
            break;
        case GTCCardCellHorizontalImageAlignmentCenter:
            xAlignment = CGRectGetWidth(self.bounds)/2;
            break;
        case GTCCardCellHorizontalImageAlignmentRight:
            xAlignment = CGRectGetWidth(self.bounds) - GTCCardCellSelectedImagePadding -
            CGRectGetWidth(self.selectedImageView.frame)/2;
            break;
    }

    self.selectedImageView.center = CGPointMake(xAlignment,
                                                yAlignment);
}

- (void)setImageTintColor:(UIColor *)imageTintColor forState:(GTCCardCellState)state {
    _imageTintColors[@(state)] = imageTintColor;

    [self updateImageTintColor];
}

- (void)updateImageTintColor {
    UIColor *imageTintColor = [self imageTintColorForState:self.state];
    [self.selectedImageView setTintColor:imageTintColor];
}

- (UIColor *)imageTintColorForState:(GTCCardCellState)state {
    UIColor *imageTintColor = _imageTintColors[@(state)];
    if (state != GTCCardCellStateNormal && imageTintColor == nil) {
        imageTintColor = _imageTintColors[@(GTCCardCellStateNormal)];
    }
    return imageTintColor;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self setImageTintColor:self.tintColor forState:GTCCardCellStateNormal];
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

- (id)shapeGenerator {
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

#pragma mark - UIResponder

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (!_interactable && (result == self.contentView || result == self)) {
        return nil;
    }
    return result;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    _lastTouch = location;
    if (!self.selected || !self.selectable) {
        [self setState:GTCCardCellStateHighlighted animated:YES];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!self.selected || !self.selectable) {
        [self setState:GTCCardCellStateNormal animated:YES];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (!self.selected || !self.selectable) {
        [self setState:GTCCardCellStateNormal animated:YES];
    }
}

@end

