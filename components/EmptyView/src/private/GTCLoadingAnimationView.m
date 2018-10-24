//
//  GTCLoadingAnimationView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCLoadingAnimationView.h"



#pragma mark -  GTCLoadingAnimationView Class

//#define GTCLoadingDefaultBackGroundColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
//#define GTCLoadingForegroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]

#define GTCLoadingDefaultBackGroundColor UIColor.clearColor
#define GTCLoadingForegroundColor UIColor.redColor

@interface GTCLoadingAnimationView ()

@property (nonatomic,strong) CAReplicatorLayer *replicatorLayer;

@property (nonatomic,strong) CALayer *mylayer;

@property (nonatomic,strong) CABasicAnimation  *basicAnimation;

@property (nonatomic) GTCLoadingAnimationType type ;

@end

@implementation GTCLoadingAnimationView

#pragma mark - ------------------ Life Cycle ------------------

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.defaultBackGroundColor = GTCLoadingDefaultBackGroundColor;
        self.foregroundColor = GTCLoadingForegroundColor;
        self.count = 10;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.replicatorLayer.frame = self.bounds;
    self.replicatorLayer.position = self.center;

    switch (self.type) {
        case GTCLoadingAnimationTypeCircle:
        case GTCLoadingAnimationTypeCircleJoin:
            self.mylayer.position = CGPointMake(50,20);

            break;

        case GTCLoadingAnimationTypeDot:
            self.mylayer.position = CGPointMake(15, 50);

            break;

        default:
            break;
    }
}

#pragma mark - ------------------ 实例化 ------------------
-(void)showAnimationAtView:(UIView *)view animationType:(GTCLoadingAnimationType)animationType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeSubLayer];
    });

    self.type = animationType;


    switch (animationType) {
        case GTCLoadingAnimationTypeCircle:
            self.count = 10;
            [self configCircle];
            break;
        case GTCLoadingAnimationTypeCircleJoin:
            self.count = 100;
            [self configCircle];
            break;
        case GTCLoadingAnimationTypeDot:
            self.count = 3;
            [self configDot];
            break;
        default:
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self addSubLayer];
    });
}


#pragma mark - ------------------ 私有方法 ------------------

-(void)configCircle
{
    CGFloat width = 10;

    self.mylayer.frame = CGRectMake(0, 0, width, width);
    self.mylayer.cornerRadius = width / 2;
    self.mylayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);

    self.replicatorLayer.instanceCount = self.count;

    CGFloat angle = 2 * M_PI / self.count;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    self.replicatorLayer.instanceDelay = 1.0 / self.count;

    self.basicAnimation.keyPath = @"transform.scale";
    self.basicAnimation.duration = 1;
    self.basicAnimation.fromValue = @1;
    self.basicAnimation.toValue = @0.1;

}


-(void)configDot
{
    CGFloat width = 15 ;

    self.mylayer.frame = CGRectMake(0, 0, width, width);
    self.mylayer.transform = CATransform3DMakeScale(0, 0, 0);
    self.mylayer.cornerRadius = width / 2;
    self.replicatorLayer.instanceCount = self.count;

    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(100/3, 0, 0);
    self.replicatorLayer.instanceDelay = 0.8 / self.count;

    self.basicAnimation.keyPath = @"transform.scale";
    self.basicAnimation.duration = 0.8;
    self.basicAnimation.fromValue = @1;
    self.basicAnimation.toValue = @0;

}

-(void)removeSubLayer
{
    [self.replicatorLayer removeFromSuperlayer];
    [self.mylayer removeFromSuperlayer];
    [self.mylayer removeAnimationForKey:@"JHUD"];

}

-(void)addSubLayer
{
    [self.layer addSublayer:self.replicatorLayer];
    [self.replicatorLayer addSublayer:self.mylayer];
    [self.mylayer addAnimation:self.basicAnimation forKey:@"JHUD"];

}

#pragma mark - ------------------ 懒加载 ------------------

-(CAReplicatorLayer *)replicatorLayer
{
    if (_replicatorLayer) {
        return _replicatorLayer;
    }
    self.replicatorLayer = [CAReplicatorLayer layer];
    self.replicatorLayer.cornerRadius = 10.0;

    return self.replicatorLayer;
}

-(CALayer *)mylayer
{
    if (_mylayer) {
        return _mylayer;
    }
    self.mylayer = [CALayer layer];
    self.mylayer.masksToBounds = YES;
    return self.mylayer;
}

-(CABasicAnimation *)basicAnimation
{
    if (_basicAnimation) {
        return _basicAnimation;
    }
    self.basicAnimation = [CABasicAnimation animation];
    self.basicAnimation.repeatCount = MAXFLOAT;
    self.basicAnimation.removedOnCompletion = NO;
    self.basicAnimation.fillMode = kCAFillModeForwards;

    return self.basicAnimation;
}

#pragma mark - ------------------ Setter ------------------

-(void)setDefaultBackGroundColor:(UIColor *)defaultBackGroundColor
{
    _defaultBackGroundColor = defaultBackGroundColor;

    self.replicatorLayer.backgroundColor = defaultBackGroundColor.CGColor;

}

-(void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;

    self.mylayer.backgroundColor = foregroundColor.CGColor;

}

@end
