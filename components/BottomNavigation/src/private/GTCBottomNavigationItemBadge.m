//
//  GTCBottomNavigationItemBadge.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCBottomNavigationItemBadge.h"

static const CGFloat kGTCBottomNavigationItemBadgeFontSize = 10.f;
static const CGFloat kGTCBottomNavigationItemBadgeXPadding = 8.f;
static const CGFloat kGTCBottomNavigationItemBadgeYPadding = 2.f;

@implementation GTCBottomNavigationItemBadge


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCBottomNavigationItemBadgeInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCBottomNavigationItemBadgeInit];
    }
    return self;
}

- (void)commonGTCBottomNavigationItemBadgeInit {
    if (!_badgeColor) {
        _badgeColor = [UIColor redColor];
    }
    self.layer.backgroundColor = _badgeColor.CGColor;

    if (self.subviews.count == 0) {
        _badgeValueLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _badgeValueLabel.textColor = [UIColor whiteColor];
        _badgeValueLabel.font = [UIFont systemFontOfSize:kGTCBottomNavigationItemBadgeFontSize];
        _badgeValueLabel.textAlignment = NSTextAlignmentCenter;
        _badgeValueLabel.isAccessibilityElement = NO;
        _badgeValueLabel.text = _badgeValue;
        [self addSubview:_badgeValueLabel];
    } else {
        // Badge label was restored during -initWithCoder:
        _badgeValueLabel = self.subviews.firstObject;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self sizeBadge];
}

- (void)sizeBadge {
    [_badgeValueLabel sizeToFit];
    _xPadding = kGTCBottomNavigationItemBadgeXPadding;
    _yPadding = kGTCBottomNavigationItemBadgeYPadding;

    _badgeCircleWidth = CGRectGetWidth(_badgeValueLabel.bounds) + _xPadding;
    _badgeCircleHeight = CGRectGetHeight(_badgeValueLabel.bounds) + _yPadding;

    if (_badgeCircleWidth < _badgeCircleHeight) {
        _badgeCircleWidth = _badgeCircleHeight;
    }
    self.frame = CGRectMake(CGRectGetMinX(self.frame),
                            CGRectGetMinY(self.frame),
                            _badgeCircleWidth,
                            _badgeCircleHeight);
    self.badgeValueLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    CGFloat badgeRadius = CGRectGetMidY(self.bounds);
    self.layer.cornerRadius = badgeRadius;
    self.layer.backgroundColor = self.badgeColor.CGColor;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    _badgeValueLabel.text = badgeValue;
    [self setNeedsLayout];
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    _badgeColor = badgeColor;
    self.layer.backgroundColor = _badgeColor.CGColor;
}


@end
