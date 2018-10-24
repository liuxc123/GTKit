//
//  GTCLoadingAnimationView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GTCLoadingAnimationType) {
    GTCLoadingAnimationTypeNone = 0,
    GTCLoadingAnimationTypeCircle,
    GTCLoadingAnimationTypeCircleJoin,
    GTCLoadingAnimationTypeDot,
};

@interface GTCLoadingAnimationView : UIView

@property (nonatomic,assign) NSInteger  count;

@property (nonatomic) UIColor  *defaultBackGroundColor;

@property (nonatomic) UIColor  *foregroundColor;

- (void)showAnimationAtView:(UIView *)view animationType:(GTCLoadingAnimationType)animationType;

-(void)removeSubLayer;

@end
