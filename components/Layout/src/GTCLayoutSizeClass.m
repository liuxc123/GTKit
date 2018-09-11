//
//  GTCLayoutSizeClass.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutSizeClass.h"
#import "GTCLayoutPositionInner.h"
#import "GTCLayoutSizeInner.h"
#import "GTCLayoutInner.h"
#import "GTCGridNode.h"
#import "GTCBaseLayout.h"

@interface GTCViewSizeClass()

@property(nonatomic, assign) BOOL wrapWidth;
@property(nonatomic, assign) BOOL wrapHeight;

@end

@implementation GTCViewSizeClass

BOOL _gtcisRTL = NO;

+ (BOOL)isRTL
{
    return _gtcisRTL;
}

+ (void)setIsRTL:(BOOL)isRTL
{
    _gtcisRTL = isRTL;
}

-(id)init
{
    return [super init];
}

-(GTCLayoutPosition*)topPosInner
{
    return _topPos;
}

-(GTCLayoutPosition*)leadingPosInner
{
    return _leadingPos;
}


-(GTCLayoutPosition*)bottomPosInner
{
    return _bottomPos;
}

-(GTCLayoutPosition*)trailingPosInner
{
    return _trailingPos;
}

-(GTCLayoutPosition*)centerXPosInner
{
    return _centerXPos;
}

-(GTCLayoutPosition*)centerYPosInner
{
    return _centerYPos;
}

-(GTCLayoutPosition*)leftPosInner
{
    return [GTCViewSizeClass isRTL] ? self.trailingPosInner : self.leadingPosInner;
}

-(GTCLayoutPosition*)rightPosInner
{
    return [GTCViewSizeClass isRTL] ? self.leadingPosInner : self.trailingPosInner;
}

-(GTCLayoutPosition*)baselinePosInner
{
    return _baselinePos;
}

-(GTCLayoutSize*)widthSizeInner
{
    return _widthSize;
}


-(GTCLayoutSize*)heightSizeInner
{
    return _heightSize;
}



//..

-(GTCLayoutPosition*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [GTCLayoutPosition new];
        _topPos.view = self.view;
        _topPos.pos = GTCGravityVertTop;

    }

    return _topPos;
}

-(GTCLayoutPosition*)leadingPos
{
    if (_leadingPos == nil)
    {
        _leadingPos = [GTCLayoutPosition new];
        _leadingPos.view = self.view;
        _leadingPos.pos = GTCGravityHorzLeading;
    }

    return _leadingPos;
}


-(GTCLayoutPosition*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [GTCLayoutPosition new];
        _bottomPos.view = self.view;
        _bottomPos.pos = GTCGravityVertBottom;

    }

    return _bottomPos;
}


-(GTCLayoutPosition*)trailingPos
{
    if (_trailingPos == nil)
    {
        _trailingPos = [GTCLayoutPosition new];
        _trailingPos.view = self.view;
        _trailingPos.pos = GTCGravityHorzTrailing;
    }

    return _trailingPos;

}


-(GTCLayoutPosition*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [GTCLayoutPosition new];
        _centerXPos.view = self.view;
        _centerXPos.pos = GTCGravityHorzCenter;

    }

    return _centerXPos;
}

-(GTCLayoutPosition*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [GTCLayoutPosition new];
        _centerYPos.view = self.view;
        _centerYPos.pos = GTCGravityVertCenter;

    }

    return _centerYPos;
}



-(GTCLayoutPosition*)leftPos
{
    return [GTCViewSizeClass isRTL] ? self.trailingPos : self.leadingPos;
}

-(GTCLayoutPosition*)rightPos
{
    return [GTCViewSizeClass isRTL] ? self.leadingPos : self.trailingPos;
}

-(GTCLayoutPosition*)baselinePos
{
    if (_baselinePos == nil)
    {
        _baselinePos = [GTCLayoutPosition new];
        _baselinePos.view = self.view;
        _baselinePos.pos = GTCGravityVertBaseline;
    }

    return _baselinePos;
}



- (CGFloat)gtc_top
{
    return self.topPosInner.absVal;
}

- (void)setGtc_top:(CGFloat)gtc_top
{
    [self.topPos __equalTo:@(gtc_top)];
}

- (CGFloat)gtc_leading
{
    return self.leadingPosInner.absVal;
}

- (void)setGtc_leading:(CGFloat)gtc_leading
{
    [self.leadingPos __equalTo:@(gtc_leading)];
}

- (CGFloat)gtc_bottom
{
    return self.bottomPosInner.absVal;
}

- (void)setGtc_bottom:(CGFloat)gtc_bottom
{
    [self.bottomPos __equalTo:@(gtc_bottom)];
}

- (CGFloat)gtc_trailing
{
    return self.trailingPosInner.absVal;
}

- (void)setGtc_trailing:(CGFloat)gtc_trailing
{
    [self.trailingPos __equalTo:@(gtc_trailing)];
}

- (CGFloat)gtc_centerX
{
    return self.centerXPosInner.absVal;
}

- (void)setGtc_centerX:(CGFloat)gtc_centerX
{
    [self.centerXPos __equalTo:@(gtc_centerX)];
}

- (CGFloat)gtc_centerY
{
    return self.centerYPosInner.absVal;
}

- (void)setGtc_centerY:(CGFloat)gtc_centerY
{
    [self.centerYPos __equalTo:@(gtc_centerY)];
}

- (CGPoint)gtc_center
{
    return CGPointMake(self.gtc_centerX, self.gtc_centerY);
}

- (void)setGtc_center:(CGPoint)gtc_center
{
    self.gtc_centerX = gtc_center.x;
    self.gtc_centerY = gtc_center.y;
}

- (CGFloat)gtc_left
{
    return self.leftPosInner.absVal;
}

- (void)setGtc_left:(CGFloat)gtc_left
{
    [self.leftPos __equalTo:@(gtc_left)];
}

- (CGFloat)gtc_right
{
    return self.rightPosInner.absVal;
}

- (void)setGtc_right:(CGFloat)gtc_right
{
    [self.rightPos __equalTo:@(gtc_right)];
}

- (CGFloat)gtc_margin
{
    return self.leftPosInner.absVal;
}

- (void)setGtc_margin:(CGFloat)gtc_margin
{
    [self.topPos __equalTo:@(gtc_margin)];
    [self.leftPos __equalTo:@(gtc_margin)];
    [self.rightPos __equalTo:@(gtc_margin)];
    [self.bottomPos __equalTo:@(gtc_margin)];
}

- (CGFloat)gtc_horzMargin
{
    return self.leftPosInner.absVal;
}

- (void)setGtc_horzMargin:(CGFloat)gtc_horzMargin
{
    [self.leftPos __equalTo:@(gtc_horzMargin)];
    [self.rightPos __equalTo:@(gtc_horzMargin)];
}

- (CGFloat)gtc_vertMargin
{
    return self.topPosInner.absVal;
}

- (void)setGtc_vertMargin:(CGFloat)gtc_vertMargin
{
    [self.topPos __equalTo:@(gtc_vertMargin)];
    [self.bottomPos __equalTo:@(gtc_vertMargin)];
}




-(GTCLayoutSize*)widthSize
{
    if (_widthSize == nil)
    {
        _widthSize = [GTCLayoutSize new];
        _widthSize.view = self.view;
        _widthSize.dime = GTCGravityHorzFill;

    }

    return _widthSize;
}


-(GTCLayoutSize*)heightSize
{
    if (_heightSize == nil)
    {
        _heightSize = [GTCLayoutSize new];
        _heightSize.view = self.view;
        _heightSize.dime = GTCGravityVertFill;

    }

    return _heightSize;
}


- (CGFloat)gtc_width
{
    return self.widthSizeInner.measure;
}

- (void)setGtc_width:(CGFloat)gtc_width
{
    [self.widthSize __equalTo:@(gtc_width)];
}

- (CGFloat)gtc_height
{
    return self.heightSizeInner.measure;
}

- (void)setGtc_height:(CGFloat)gtc_height
{
    [self.heightSize __equalTo:@(gtc_height)];
}

- (CGSize)gtc_size
{
    return CGSizeMake(self.gtc_width, self.gtc_height);
}

- (void)setGtc_size:(CGSize)gtc_size
{
    self.gtc_width = gtc_size.width;
    self.gtc_height = gtc_size.height;
}


-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        weight = 0;

    if (_weight != weight)
        _weight = weight;
}

-(BOOL)wrapContentWidth
{
    return self.wrapWidth;
}

-(BOOL)wrapContentHeight
{
    return self.wrapHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.wrapWidth != wrapContentWidth)
    {
        self.wrapWidth = wrapContentWidth;

        if (wrapContentWidth)
        {

#ifdef GT_USEPREFIXMETHOD
            self.widthSize.gtc_equalTo(self.widthSize);
#else
            self.widthSize.equalTo(self.widthSize);
#endif
        }
        else
        {
            if (self.widthSizeInner.dimeSelfVal != nil)
            {

#ifdef GT_USEPREFIXMETHOD
                self.widthSizeInner.gtc_equalTo(nil);
#else
                self.widthSizeInner.equalTo(nil);
#endif
            }
        }
    }
}


-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.wrapHeight != wrapContentHeight)
    {
        self.wrapHeight = wrapContentHeight;

        if (wrapContentHeight)
        {
            if([_view isKindOfClass:[UILabel class]])
            {
                if (((UILabel*)_view).numberOfLines == 1)
                    ((UILabel*)_view).numberOfLines = 0;
            }
        }
    }
}

-(BOOL)wrapContentSize
{
    return self.wrapContentWidth && self.wrapContentHeight;
}


-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    self.wrapContentWidth = self.wrapContentHeight = wrapContentSize;
}




-(NSString*)debugDescription
{

    NSString*dbgDesc = [NSString stringWithFormat:@"\nView:\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\nweight=%f\nuseFrame=%@\nnoLayout=%@\nmyVisibility=%lu\nmyAlignment=%lu\nwrapContentWidth=%@\nwrapContentHeight=%@\nreverseFloat=%@\nclearFloat=%@",
                        self.topPosInner,
                        self.leadingPosInner,
                        self.bottomPosInner,
                        self.trailingPosInner,
                        self.centerXPosInner,
                        self.centerYPosInner,
                        self.widthSizeInner,
                        self.heightSizeInner,
                        self.weight,
                        self.useFrame ? @"YES":@"NO",
                        self.noLayout? @"YES":@"NO",
                        (unsigned long)self.gtc_visibility,
                        (unsigned long)self.gtc_alignment,
                        self.wrapContentWidth ? @"YES":@"NO",
                        self.wrapContentHeight ? @"YES":@"NO",
                        self.reverseFloat ? @"YES":@"NO",
                        self.clearFloat ? @"YES":@"NO"];


    return dbgDesc;
}


#pragma mark -- NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GTCViewSizeClass *lsc = [[[self class] allocWithZone:zone] init];


    //这里不会复制hidden属性
    lsc->_view = _view;
    lsc->_topPos = [self.topPosInner copy];
    lsc->_leadingPos = [self.leadingPosInner copy];
    lsc->_bottomPos = [self.bottomPosInner copy];
    lsc->_trailingPos = [self.trailingPosInner copy];
    lsc->_centerXPos = [self.centerXPosInner copy];
    lsc->_centerYPos = [self.centerYPosInner copy];
    lsc->_baselinePos = [self.baselinePos copy];
    lsc->_widthSize = [self.widthSizeInner copy];
    lsc->_heightSize = [self.heightSizeInner copy];
    lsc->_wrapWidth = self.wrapWidth;
    lsc->_wrapHeight = self.wrapHeight;
    lsc.useFrame = self.useFrame;
    lsc.noLayout = self.noLayout;
    lsc.gtc_visibility = self.gtc_visibility;
    lsc.gtc_alignment = self.gtc_alignment;
    lsc.weight = self.weight;
    lsc.reverseFloat = self.isReverseFloat;
    lsc.clearFloat = self.clearFloat;


    return lsc;
}

@end


@implementation GTCLayoutViewSizeClass


-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _zeroPadding = YES;
        _insetsPaddingFromSafeArea = UIRectEdgeLeft | UIRectEdgeRight;
        _insetLandscapeFringePadding = NO;
        _layoutTransform = CGAffineTransformIdentity;
    }

    return self;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.wrapWidth != wrapContentWidth)
    {
        self.wrapWidth = wrapContentWidth;
    }

}

-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.wrapHeight != wrapContentHeight)
    {
        self.wrapHeight = wrapContentHeight;
    }

}



-(UIEdgeInsets)padding
{
    return UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding, self.rightPadding);
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.topPadding = padding.top;
    self.leftPadding = padding.left;
    self.bottomPadding = padding.bottom;
    self.rightPadding = padding.right;
}

-(CGFloat)leftPadding
{
    return [GTCViewSizeClass isRTL] ? self.trailingPadding : self.leadingPadding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    if ([GTCViewSizeClass isRTL])
    {
        self.trailingPadding = leftPadding;
    }
    else
    {
        self.leadingPadding = leftPadding;
    }
}

-(CGFloat)rightPadding
{
    return [GTCViewSizeClass isRTL] ? self.leadingPadding : self.trailingPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    if ([GTCViewSizeClass isRTL])
    {
        self.leadingPadding = rightPadding;
    }
    else
    {
        self.trailingPadding = rightPadding;
    }
}

-(CGFloat)gtcLayoutTopPadding
{
    //如果padding值是特殊的值。
    if (self.topPadding >= GTCLayoutPosition.gtc_safeAreaMargin - 2000 && self.topPadding <= GTCLayoutPosition.gtc_safeAreaMargin + 2000)
    {
        return  self.topPadding - GTCLayoutPosition.gtc_safeAreaMargin + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    }

    if ((self.insetsPaddingFromSafeArea & UIRectEdgeTop) == UIRectEdgeTop)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {
            return self.topPadding + self.view.safeAreaInsets.top;
        }
#endif
    }

    return self.topPadding;
}

-(CGFloat)gtcLayoutBottomPadding
{
    //如果padding值是特殊的值。
    if (self.bottomPadding >= GTCLayoutPosition.gtc_safeAreaMargin - 2000 && self.bottomPadding <= GTCLayoutPosition.gtc_safeAreaMargin + 2000)
    {
        CGFloat bottomPaddingAdd = 0;
#if TARGET_OS_IOS
        //如果设备是iPhoneX就特殊处理。竖屏是34，横屏是21
        if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
        {
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                bottomPaddingAdd = 21;
            else
                bottomPaddingAdd = 34;
        }
#endif
        return self.bottomPadding - GTCLayoutPosition.gtc_safeAreaMargin + bottomPaddingAdd;
    }

    if ((self.insetsPaddingFromSafeArea & UIRectEdgeBottom) == UIRectEdgeBottom )
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

            return self.bottomPadding + self.view.safeAreaInsets.bottom;
        }
#endif
    }

    return self.bottomPadding;
}

-(CGFloat)gtcLayoutLeadingPadding
{
    if (self.leadingPadding >= GTCLayoutPosition.gtc_safeAreaMargin - 2000 && self.leadingPadding <= GTCLayoutPosition.gtc_safeAreaMargin + 2000)
    {
        CGFloat leadingPaddingAdd = 0;
#if TARGET_OS_IOS
        //如果设备是iPhoneX就特殊处理。竖屏是34，横屏是21
        if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
        {
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                leadingPaddingAdd = 44;
            else
                leadingPaddingAdd = 0;
        }
#endif
        return self.leadingPadding - GTCLayoutPosition.gtc_safeAreaMargin + leadingPaddingAdd;
    }


    CGFloat inset = 0;

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

    if (@available(iOS 11.0, *)) {

        UIRectEdge edge = [GTCViewSizeClass isRTL]? UIRectEdgeRight:UIRectEdgeLeft;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [GTCViewSizeClass isRTL]? UIDeviceOrientationLandscapeLeft: UIDeviceOrientationLandscapeRight;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge)
        {
#if TARGET_OS_IOS

            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是尾部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori)
            {
                inset = 0;
            }
            else
#endif
                inset = [GTCViewSizeClass isRTL]? self.view.safeAreaInsets.right : self.view.safeAreaInsets.left;
        }
    }
#endif

    return self.leadingPadding + inset;
}

-(CGFloat)gtcLayoutTrailingPadding
{
    if (self.trailingPadding >= GTCLayoutPosition.gtc_safeAreaMargin - 2000 && self.trailingPadding <= GTCLayoutPosition.gtc_safeAreaMargin + 2000)
    {
        CGFloat trailingPaddingAdd = 0;
#if TARGET_OS_IOS
        //如果设备是iPhoneX就特殊处理。竖屏是34，横屏是21
        if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
        {
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                trailingPaddingAdd = 44;
            else
                trailingPaddingAdd = 0;
        }
#endif
        return self.trailingPadding - GTCLayoutPosition.gtc_safeAreaMargin + trailingPaddingAdd;
    }


    CGFloat inset = 0;

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

    if (@available(iOS 11.0, *)) {
        UIRectEdge edge = [GTCViewSizeClass isRTL]? UIRectEdgeLeft:UIRectEdgeRight;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [GTCViewSizeClass isRTL]? UIDeviceOrientationLandscapeRight: UIDeviceOrientationLandscapeLeft;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge)
        {
#if TARGET_OS_IOS
            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是头部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori)
            {
                inset = 0;
            }
            else
#endif
                inset = [GTCViewSizeClass isRTL]? self.view.safeAreaInsets.left : self.view.safeAreaInsets.right;
        }
    }
#endif

    return self.trailingPadding + inset;
}

-(CGFloat)gtcLayoutLeftPadding
{
    return [GTCViewSizeClass isRTL] ? [self gtcLayoutTrailingPadding] : [self gtcLayoutLeadingPadding];
}
-(CGFloat)gtcLayoutRightPadding
{
    return [GTCViewSizeClass isRTL] ? [self gtcLayoutLeadingPadding] : [self gtcLayoutTrailingPadding];
}


-(CGFloat)subviewSpace
{
    return self.subviewVSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.subviewVSpace = subviewSpace;
    self.subviewHSpace = subviewSpace;
}


- (id)copyWithZone:(NSZone *)zone
{
    GTCLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.topPadding = self.topPadding;
    lsc.leadingPadding = self.leadingPadding;
    lsc.bottomPadding = self.bottomPadding;
    lsc.trailingPadding = self.trailingPadding;
    lsc.zeroPadding = self.zeroPadding;
    lsc.insetsPaddingFromSafeArea = self.insetsPaddingFromSafeArea;
    lsc.insetLandscapeFringePadding = self.insetLandscapeFringePadding;
    lsc.gravity = self.gravity;
    lsc.reverseLayout = self.reverseLayout;
    lsc.layoutTransform = self.layoutTransform;
    lsc.subviewVSpace = self.subviewVSpace;
    lsc.subviewHSpace = self.subviewHSpace;

    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];

    dbgDesc = [NSString stringWithFormat:@"%@\nLayout:\npadding=%@\nzeroPadding=%@\ngravity=%ld\nreverseLayout=%@\nsubviewVertSpace=%f\nsubviewHorzSpace=%f",
               dbgDesc,
               NSStringFromUIEdgeInsets(self.padding),
               self.zeroPadding?@"YES":@"NO",
               (long)self.gravity,
               self.reverseLayout?@"YES":@"NO",
               self.subviewVSpace,
               self.subviewHSpace
               ];


    return dbgDesc;
}


@end


@implementation GTCSequentLayoutViewSizeClass



- (id)copyWithZone:(NSZone *)zone
{
    GTCSequentLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.orientation = self.orientation;


    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];

    dbgDesc = [NSString stringWithFormat:@"%@\nSequentLayout: \norientation=%lu",
               dbgDesc,
               (unsigned long)self.orientation
               ];


    return dbgDesc;
}



@end


@implementation GTCLinearLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    GTCLinearLayoutViewSizeClass *lsc = [super copyWithZone:zone];

    lsc.shrinkType = self.shrinkType;

    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];

    dbgDesc = [NSString stringWithFormat:@"%@\nLinearLayout: \nshrinkType=%lu",
               dbgDesc,
               (unsigned long)self.shrinkType
               ];

    return dbgDesc;
}



@end

@implementation GTCTableLayoutViewSizeClass

@end

@implementation GTCFloatLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    GTCFloatLayoutViewSizeClass *lsc = [super copyWithZone:zone];

    lsc.subviewSize = self.subviewSize;
    lsc.minSpace = self.minSpace;
    lsc.maxSpace = self.maxSpace;
    lsc.noBoundaryLimit = self.noBoundaryLimit;

    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];

    dbgDesc = [NSString stringWithFormat:@"%@\nFloatLayout: \nnoBoundaryLimit=%@",
               dbgDesc,
               self.noBoundaryLimit ? @"YES":@"NO"];

    return dbgDesc;
}



@end

@implementation GTCFlowLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    GTCFlowLayoutViewSizeClass *lsc = [super copyWithZone:zone];

    lsc.arrangedCount = self.arrangedCount;
    lsc.autoArrange = self.autoArrange;
    lsc.arrangedGravity = self.arrangedGravity;
    lsc.subviewSize = self.subviewSize;
    lsc.minSpace = self.minSpace;
    lsc.maxSpace = self.maxSpace;
    lsc.pagedCount = self.pagedCount;

    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];

    dbgDesc = [NSString stringWithFormat:@"%@\nFlowLayout: \narrangedCount=%ld\nautoArrange=%@\narrangedGravity=%ld\npagedCount=%ld",
               dbgDesc,
               (long)self.arrangedCount,
               self.autoArrange ? @"YES":@"NO",
               (long)self.arrangedGravity,
               (long)self.pagedCount
               ];

    return dbgDesc;
}


@end

@implementation GTCRelativeLayoutViewSizeClass

@end

@implementation GTCFrameLayoutViewSizeClass



@end

@implementation GTCPathLayoutViewSizeClass

@end















@interface GTCGridLayoutViewSizeClass()<GTCGridNode>

@property(nonatomic, strong) GTCGridNode *rootGrid;

@end


@implementation GTCGridLayoutViewSizeClass


-(GTCGridNode*)rootGrid
{
    if (_rootGrid == nil)
    {
        _rootGrid = [[GTCGridNode alloc] initWithMeasure:0 superGrid:nil];
    }
    return _rootGrid;
}

//添加行栅格，返回新的栅格。
-(id<GTCGrid>)addRow:(CGFloat)measure
{
    id<GTCGridNode> node = (id<GTCGridNode>)[self.rootGrid addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列栅格，返回新的栅格。
-(id<GTCGrid>)addCol:(CGFloat)measure
{
    id<GTCGridNode> node = (id<GTCGridNode>)[self.rootGrid addCol:measure];
    node.superGrid = self;
    return node;
}

//添加栅格，返回被添加的栅格。这个方法和下面的cloneGrid配合使用可以用来构建那些需要重复添加栅格的场景。
-(id<GTCGrid>)addRowGrid:(id<GTCGrid>)grid
{
    id<GTCGridNode> node = (id<GTCGridNode>)[self.rootGrid addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTCGrid>)addColGrid:(id<GTCGrid>)grid
{
    id<GTCGridNode> node = (id<GTCGridNode>)[self.rootGrid addColGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTCGrid>)addRowGrid:(id<GTCGrid>)grid measure:(CGFloat)measure
{
    id<GTCGridNode> node = (id<GTCGridNode>)[self.rootGrid addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;

}

-(id<GTCGrid>)addColGrid:(id<GTCGrid>)grid measure:(CGFloat)measure
{
    id<GTCGridNode> node = (id<GTCGridNode>)[self.rootGrid addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;

}


//克隆出一个新栅格以及其下的所有子栅格。
-(id<GTCGrid>)cloneGrid
{
    return nil;
}

//从父栅格中删除。
-(void)removeFromSuperGrid
{
}

//得到父栅格。
-(id<GTCGrid>)superGrid
{
    return nil;
}

-(void)setSuperGrid:(id<GTCGridNode>)superGrid
{

}

-(BOOL)placeholder
{
    return NO;
}

-(void)setPlaceholder:(BOOL)placeholder
{
}

-(BOOL)anchor
{
    return NO;
}

-(void)setAnchor:(BOOL)anchor
{
    //do nothing
}

-(GTCGravity)overlap
{
    return self.gravity;
}

-(void)setOverlap:(GTCGravity)overlap
{
    self.gravity = overlap;
}


-(NSInteger)tag
{
    return self.view.tag;
}

-(void)setTag:(NSInteger)tag
{
    self.view.tag = tag;
}

-(id)actionData
{
    return self.rootGrid.actionData;
}

-(void)setActionData:(id)actionData
{
    self.rootGrid.actionData = actionData;
}

-(void)setTarget:(id)target action:(SEL)action
{
    //do nothing.
}

//得到所有子栅格
-(NSArray<id<GTCGrid>> *)subGrids
{
    return self.rootGrid.subGrids;
}


-(void)setSubGrids:(NSMutableArray *)subGrids
{
    self.rootGrid.subGrids = subGrids;
}

-(GTCSubGridsType)subGridsType
{
    return self.rootGrid.subGridsType;
}

-(void)setSubGridsType:(GTCSubGridsType)subGridsType
{
    self.rootGrid.subGridsType = subGridsType;
}


-(GTCBorderline*)topBorderline
{
    return nil;
}

-(void)setTopBorderline:(GTCBorderline *)topBorderline
{
}


-(GTCBorderline*)bottomBorderline
{
    return nil;
}

-(void)setBottomBorderline:(GTCBorderline *)bottomBorderline
{
}


-(GTCBorderline*)leftBorderline
{
    return nil;
}

-(void)setLeftBorderline:(GTCBorderline *)leftBorderline
{
}


-(GTCBorderline*)rightBorderline
{
    return nil;
}

-(void)setRightBorderline:(GTCBorderline *)rightBorderline
{
}

-(GTCBorderline*)leadingBorderline
{
    return nil;
}

-(void)setLeadingBorderline:(GTCBorderline *)leadingBorderline
{

}

-(GTCBorderline*)trailingBorderline
{
    return nil;
}

-(void)setTrailingBorderline:(GTCBorderline *)trailingBorderline
{

}


-(NSDictionary*)gridDictionary
{
    return [GTCGridNode translateGridNode:self toGridDictionary:[NSMutableDictionary new]];
}

-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    GTCGridNode *rootNode = self.rootGrid;
    [rootNode.subGrids removeAllObjects];
    rootNode.subGridsType = GTCSubGridsTypeUnknown;

    [self.view setNeedsLayout];

    if (gridDictionary == nil)
        return;

    [GTCGridNode translateGridDicionary:gridDictionary toGridNode:self];
}

-(CGFloat)measure
{
    return GTCLayoutSize.fill;
    //return self.rootGrid.measure;
}

-(void)setMeasure:(CGFloat)measure
{
    //self.rootGrid.measure = measure;
}

-(CGRect)gridRect
{
    return self.rootGrid.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    self.rootGrid.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<GTCGridNode>)superGrid withMeasure:(CGFloat)measure
{
    return [self.rootGrid updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<GTCGridNode>)superGrid withOffset:(CGFloat)offset
{
    return [self.rootGrid updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}


-(UIView*)gridLayoutView
{
    return self.view;
}

-(SEL)gridAction
{
    return nil;
}

-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    [self.rootGrid setBorderlineNeedLayoutIn:rect withLayer:layer];
}

-(void)showBorderline:(BOOL)show
{
    [self.rootGrid showBorderline:show];
}

-(id<GTCGridNode>)gridHitTest:(CGPoint)point
{
    return [self.rootGrid gridHitTest:point];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}




- (id)copyWithZone:(NSZone *)zone
{
    GTCGridLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc->_rootGrid = (GTCGridNode*)[self.rootGrid cloneGrid];


    return lsc;
}


@end

