//
//  GTCBaseCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCBaseCell.h"

#import "GTInk.h"
#import "GTShadowLayer.h"

static NSString *const GTCListBaseCellInkViewKey = @"GTCListBaseCellInkViewKey";
static NSString *const GTCListBaseCellCurrentInkColorKey = @"GTCListBaseCellCurrentInkColorKey";
static NSString *const GTCListBaseCellCurrentElevationKey = @"GTCListBaseCellCurrentElevationKey";

@interface GTCBaseCell ()

@property (nonatomic, assign) CGPoint lastTouch;
@property (strong, nonatomic, nonnull) GTCInkView *inkView;

@end

@implementation GTCBaseCell

#pragma mark Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCBaseCellInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        GTCInkView *decodedInkView = [aDecoder decodeObjectOfClass:[GTCInkView class]
                                                            forKey:GTCListBaseCellInkViewKey];
        if (decodedInkView) {
            self.inkView = decodedInkView;
        }
        UIColor *decodedColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                       forKey:GTCListBaseCellCurrentInkColorKey];
        if (decodedColor) {
            self.inkView.inkColor = decodedColor;
        }
        NSNumber *decodedElevation = [aDecoder decodeObjectOfClass:[NSNumber class]
                                                            forKey:GTCListBaseCellCurrentElevationKey];
        if (decodedElevation) {
            self.elevation = (CGFloat)[decodedElevation doubleValue];
        }
        [self commonGTCBaseCellInit];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_inkView forKey:GTCListBaseCellInkViewKey];
    [coder encodeObject:_inkView.inkColor forKey:GTCListBaseCellCurrentInkColorKey];
    [coder encodeObject:[NSNumber numberWithDouble:(double)_elevation]
                 forKey:GTCListBaseCellCurrentInkColorKey];
}

#pragma mark Setup

- (void)commonGTCBaseCellInit {
    if (!self.inkView) {
        self.inkView = [[GTCInkView alloc] initWithFrame:self.bounds];
    }
    _inkView.usesLegacyInkRipple = NO;
    [self addSubview:_inkView];
}

#pragma mark Ink

- (void)startInk {
    [self.inkView startTouchBeganAtPoint:_lastTouch
                                animated:YES
                          withCompletion:nil];
}

- (void)endInk {
    [self.inkView startTouchEndAtPoint:_lastTouch
                              animated:YES
                        withCompletion:nil];
}

#pragma mark Shadow

- (UIBezierPath *)boundingPath {
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius];
}

- (void)updateShadowElevation {
    self.layer.shadowPath = [self boundingPath].CGPath;
    [self.shadowLayer setElevation:self.elevation];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    self.lastTouch = location;
    [self startInk];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self endInk];
}

#pragma mark UIView Overrides

+ (Class)layerClass {
    return [GTCShadowLayer class];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShadowElevation];
    self.inkView.frame = self.bounds;
}

#pragma mark UICollectionViewCell Overrides

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!highlighted) {
        [self endInk];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.elevation = 0;
    [self.inkView cancelAllAnimationsAnimated:NO];
}

#pragma mark Accessors

- (void)setElevation:(GTCShadowElevation)elevation {
    if (elevation == _elevation) {
        return;
    }
    _elevation = elevation;
    [self updateShadowElevation];
}

- (void)setInkColor:(UIColor *)inkColor {
    if ([self.inkColor isEqual:inkColor]) {
        return;
    }
    self.inkView.inkColor = inkColor;
}

- (UIColor *)inkColor {
    return self.inkView.inkColor;
}

- (GTCShadowLayer *)shadowLayer {
    if ([self.layer isMemberOfClass:[GTCShadowLayer class]]) {
        return (GTCShadowLayer *)self.layer;
    }
    return nil;
}

@end

