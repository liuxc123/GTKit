//
//  GTCShapedView.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCShapedView.h"

#import "GTCShapedShadowLayer.h"

@interface GTCShapedView ()
@property(nonatomic, readonly, strong) GTCShapedShadowLayer *layer;
@property(nonatomic, readonly) CGSize pathSize;
@end

@implementation GTCShapedView

@dynamic layer;

+ (Class)layerClass {
    return [GTCShapedShadowLayer class];
}

- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame shapeGenerator:nil];
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
                       shapeGenerator:(nullable id<GTCShapeGenerating>)shapeGenerator {
    if (self = [super initWithFrame:frame]) {
        self.layer.shapeGenerator = shapeGenerator;
    }
    return self;
}

- (void)setElevation:(CGFloat)elevation {
    self.layer.elevation = elevation;
}

- (CGFloat)elevation {
    return self.layer.elevation;
}

- (void)setShapeGenerator:(id<GTCShapeGenerating>)shapeGenerator {
    self.layer.shapeGenerator = shapeGenerator;
}

- (id<GTCShapeGenerating>)shapeGenerator {
    return self.layer.shapeGenerator;
}

// GTCShapedView captures backgroundColor assigments so that they can be set to the
// GTCShapedShadowLayer fillColor. If we don't do this the background of the layer will obscure any
// shapes drawn by the shape layer.
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    // We intentionally capture this and don't send it to super so that the UIView backgroundColor is
    // fixed to [UIColor clearColor].
    self.layer.shapedBackgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return self.layer.shapedBackgroundColor;
}

@end

