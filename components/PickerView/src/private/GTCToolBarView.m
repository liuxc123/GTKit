//
//  GTCToolBarView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCToolBarView.h"

@interface GTCToolBarView()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation GTCToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCToolBarViewInit];
        [self configGTCToolBarViewLayout];
    }
    return self;
}


- (void)commonGTCToolBarViewInit {
    if (_cancelBar == nil) {
        _cancelBar = [[UILabel alloc] init];
        _cancelBar.font = [UIFont systemFontOfSize:16];
        _cancelBar.text = @"取消";
        _cancelBar.textAlignment = NSTextAlignmentLeft;
        _cancelBar.userInteractionEnabled = true;
        [_cancelBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)]];
        [self addSubview:_cancelBar];
        [_cancelBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_cancelBar setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_cancelBar setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }

    if (_titleBar == nil) {
        _titleBar = [[UILabel alloc] init];
        _titleBar.font = [UIFont systemFontOfSize:18];
        _titleBar.text = @"标题";
        _titleBar.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleBar];
        [_titleBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_titleBar setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }

    if (_subTitleBar == nil) {
        _subTitleBar = [[UILabel alloc] init];
        _subTitleBar.font = [UIFont systemFontOfSize:18];
        _subTitleBar.text = @"子标题";
        _subTitleBar.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleBar];
        [_subTitleBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_subTitleBar setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }

    if (_commitBar == nil) {
        _commitBar = [[UILabel alloc] init];
        _commitBar.font = [UIFont systemFontOfSize:16];
        _commitBar.text = @"完成";
        _commitBar.textAlignment = NSTextAlignmentRight;
        _commitBar.userInteractionEnabled = true;
        [_commitBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitAction)]];
        [self addSubview:_commitBar];
        [_commitBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_commitBar setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_commitBar setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }

    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_topLineView];
        [_topLineView setTranslatesAutoresizingMaskIntoConstraints:false];
    }

    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_bottomLineView];
        [_bottomLineView setTranslatesAutoresizingMaskIntoConstraints:false];
    }

}

- (void)configGTCToolBarViewLayout {
    NSLayoutConstraint *constrant_a = [NSLayoutConstraint constraintWithItem:_cancelBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
    NSLayoutConstraint *constrant_b = [NSLayoutConstraint constraintWithItem:_cancelBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_c = [NSLayoutConstraint constraintWithItem:_cancelBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraints:@[constrant_a, constrant_b, constrant_c]];

    NSLayoutConstraint *constrant_d = [NSLayoutConstraint constraintWithItem:_titleBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_cancelBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    NSLayoutConstraint *constrant_e = [NSLayoutConstraint constraintWithItem:_titleBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_f = [NSLayoutConstraint constraintWithItem:_titleBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraints:@[constrant_d, constrant_e, constrant_f]];

    NSLayoutConstraint *constrant_g = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    NSLayoutConstraint *constrant_h = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_i = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_j = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15];
    [self addConstraints:@[constrant_g, constrant_h, constrant_i, constrant_j]];

    NSLayoutConstraint *constrant_k = [NSLayoutConstraint constraintWithItem:_topLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_l = [NSLayoutConstraint constraintWithItem:_topLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_m = [NSLayoutConstraint constraintWithItem:_topLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_n = [NSLayoutConstraint constraintWithItem:_topLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
    [self addConstraints:@[constrant_k, constrant_l, constrant_m, constrant_n]];

    NSLayoutConstraint *constrant_o = [NSLayoutConstraint constraintWithItem:_bottomLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_p = [NSLayoutConstraint constraintWithItem:_bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_q = [NSLayoutConstraint constraintWithItem:_bottomLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *constrant_r = [NSLayoutConstraint constraintWithItem:_bottomLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
    [self addConstraints:@[constrant_o, constrant_p, constrant_q, constrant_r]];
}


- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)commitAction {
    if (self.commitBlock) {
        self.commitBlock();
    }
}

- (void)setCancelBarTitle:(NSString *)cancelBarTitle {
    _cancelBarTitle = cancelBarTitle;
    if (self.cancelBar) {
        self.cancelBar.text = cancelBarTitle;
    }
}

- (void)setCancelBarTintColor:(UIColor *)cancelBarTintColor {
    _cancelBarTintColor = cancelBarTintColor;
    if (self.cancelBar) {
        self.cancelBar.tintColor = cancelBarTintColor;
    }
}

- (void)setCommitBarTitle:(NSString *)commitBarTitle {
    _commitBarTitle = commitBarTitle;
    if (self.commitBar) {
        self.commitBar.text = commitBarTitle;
    }
}

- (void)setCommitBarTintColor:(UIColor *)commitBarTintColor {
    _commitBarTintColor = commitBarTintColor;
    if (self.commitBar) {
        self.commitBar.tintColor = commitBarTintColor;
    }
}

- (void)setTitleBarTitle:(NSString *)titleBarTitle {
    _titleBarTitle = titleBarTitle;
    if (self.titleBar) {
        self.titleBar.text = titleBarTitle;
    }
}

- (void)setTitleBarTextColor:(UIColor *)titleBarTextColor {
    _titleBarTextColor = titleBarTextColor;
    if (self.titleBar) {
        self.titleBar.textColor = titleBarTextColor;;
    }
}

@end
