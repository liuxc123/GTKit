//
//  GTCLoadingBaseView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCLoadingBaseView.h"


@interface GTCLoadingBaseView ()

@end

@implementation GTCLoadingBaseView

#pragma mark - ------------------ Life Cycle ------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare{

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *view = self.superview;
    //不是UIScrollView，不做操作
    if (view && [view isKindOfClass:[UIView class]]){
        self.width = view.width;
        self.height = view.height;
    }

    [self setupSubviews];
}

- (void)setupSubviews{

}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    //不是UIScrollView，不做操作
    if (newSuperview && ![newSuperview isKindOfClass:[UIView class]]) return;

    if (newSuperview) {
        self.width = newSuperview.width;
        self.height = newSuperview.height;
    }
}

#pragma mark - ------------------ 实例化 ------------------

+ (instancetype)loadingViewWithLoadingAnimationType:(GTCLoadingAnimationType)loadingType titleStr:(NSString *)titleStr
{
    GTCLoadingBaseView *loadingView = [[self alloc] init];

    [loadingView createLoadingViewWithLoadingAnimationType:loadingType titleStr:titleStr];

    return loadingView;
}

+ (instancetype)loadingViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr
{
    GTCLoadingBaseView *loadingView = [[self alloc] init];

    [loadingView createLoadingViewWithImageStr:imageStr titleStr:titleStr];

    return loadingView;
}

+ (instancetype)loadingViewWithImageStrArray:(NSArray<NSString *> *)imageStrArray titleStr:(NSString *)titleStr
{
    GTCLoadingBaseView *loadingView = [[self alloc] init];

    [loadingView createLoadingViewWithImageArray:imageStrArray titleStr:titleStr];

    return loadingView;
}


+ (instancetype)loadingViewWithCustomView:(UIView *)customView
{
    GTCLoadingBaseView *loadingView = [[self alloc] init];

    [loadingView creatLoadingViewWithCustomView:customView];

    return loadingView;
}

- (void)createLoadingViewWithLoadingAnimationType:(GTCLoadingAnimationType)loadingType titleStr:(NSString *)titleStr
{
    _loadingAnimationType = loadingType;
    _titleStr = titleStr;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }
}


- (void)createLoadingViewWithImageArray:(NSArray<NSString *> *)imageStrArray titleStr:(NSString *)titleStr
{
    _imageStrArray = imageStrArray;
    _titleStr = titleStr;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }
}

- (void)createLoadingViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr
{
    _imageStr = imageStr;
    _titleStr = titleStr;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }
}

- (void)creatLoadingViewWithCustomView:(UIView *)customView
{
    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }

    if (!_customView) {
        [_contentView addSubview:customView];
    }
    _customView = customView;
}

#pragma mark - ------------------ Setter ------------------
- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    [self layoutSubviews];
}

- (void)setImageStrArray:(NSArray<NSString *> *)imageStrArray {
    _imageStrArray = imageStrArray;
    [self layoutSubviews];
}

- (void)setGifImageData:(NSData *)gifImageData {
    _gifImageData = gifImageData;
    [self layoutSubviews];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self layoutSubviews];
}

- (void)setLoadingAnimationType:(GTCLoadingAnimationType)loadingAnimationType {
    _loadingAnimationType = loadingAnimationType;
    [self layoutSubviews];
}

@end
