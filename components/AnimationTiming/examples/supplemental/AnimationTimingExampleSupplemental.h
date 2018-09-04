//
//  AnimationTimingExampleSupplemental.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import <UIKit/UIKit.h>

@interface AnimationTimingExample : UIViewController

@property(nonatomic, strong) NSTimer *animationLoop;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *linearView;
@property(nonatomic, strong) UIView *materialStandardView;
@property(nonatomic, strong) UIView *materialDecelerationView;
@property(nonatomic, strong) UIView *materialAccelerationView;
@property(nonatomic, strong) UIView *materialSharpView;

@end

@interface AnimationTimingExample (Supplemental)

- (void)setupExampleViews;

+ (UILabel *)curveLabelWithTitle:(NSString *)text;

+ (NSArray<UIColor *> *)defaultColors;

@end
