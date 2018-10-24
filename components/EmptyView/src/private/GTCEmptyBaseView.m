//
//  GTCEmptyBaseView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import "GTCEmptyBaseView.h"


@interface GTCEmptyBaseView ()

@end

@implementation GTCEmptyBaseView

#pragma mark - ------------------ Life Cycle ------------------
- (instancetype)init
{
    self = [super init];
    if (self) {

        self.autoShowEmptyView = YES;//默认自动显隐

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
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr target:(id)target action:(SEL)action{

    GTCEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:target action:action];

    return emptyView;
}
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr btnClickBlock:(GTCActionTapBlock)btnClickBlock{

    GTCEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr btnClickBlock:btnClickBlock];

    return emptyView;
}
+ (instancetype)emptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr{

    GTCEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:nil btnClickBlock:nil];

    return emptyView;
}

+ (instancetype)emptyViewWithCustomView:(UIView *)customView{

    GTCEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithCustomView:customView];

    return emptyView;
}

- (void)creatEmptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr target:(id)target action:(SEL)action{

    _imageStr = imageStr;
    _titleStr = titleStr;
    _detailStr = detailStr;
    _btnTitleStr = btnTitleStr;
    _actionBtnTarget = target;
    _actionBtnAction = action;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
        [_contentView addGestureRecognizer:tap];
    }
}

- (void)creatEmptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr btnClickBlock:(GTCActionTapBlock)btnClickBlock{

    _imageStr = imageStr;
    _titleStr = titleStr;
    _detailStr = detailStr;
    _btnTitleStr = btnTitleStr;
    _btnClickBlock = btnClickBlock;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
        [_contentView addGestureRecognizer:tap];
    }
}
- (void)creatEmptyViewWithCustomView:(UIView *)customView{

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

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self layoutSubviews];
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self layoutSubviews];
}
- (void)setDetailStr:(NSString *)detailStr{
    _detailStr = detailStr;
    [self layoutSubviews];
}
- (void)setBtnTitleStr:(NSString *)btnTitleStr{
    _btnTitleStr = btnTitleStr;
    [self layoutSubviews];
}
- (void)tapContentView:(UITapGestureRecognizer *)tap{
    if (_tapContentViewBlock) {
        _tapContentViewBlock();
    }
}


@end
