//
//  GTCBaseLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCBaseLayout.h"
#import "GTCLayoutInner.h"
#import "GTCLayoutDelegate.h"
#import <objc/runtime.h>

const char * const ASSOCIATEDOBJECT_KEY_GTLAYOUT_FRAME = "ASSOCIATEDOBJECT_KEY_GTLAYOUT_FRAME";

void* _gtcObserverContextA = (void*)20180901;
void* _gtcObserverContextB = (void*)20180902;
void* _gtcObserverContextC = (void*)20180903;


@implementation UIView(GTCLayoutExt)


-(GTCLayoutPosition*)topPos
{
    return self.gtcCurrentSizeClass.topPos;
}

-(GTCLayoutPosition*)leadingPos
{
    return self.gtcCurrentSizeClass.leadingPos;
}



-(GTCLayoutPosition*)bottomPos
{
    return self.gtcCurrentSizeClass.bottomPos;
}


-(GTCLayoutPosition*)trailingPos
{
    return self.gtcCurrentSizeClass.trailingPos;
}



-(GTCLayoutPosition*)centerXPos
{
    return self.gtcCurrentSizeClass.centerXPos;
}


-(GTCLayoutPosition*)centerYPos
{
    return  self.gtcCurrentSizeClass.centerYPos;
}


-(GTCLayoutPosition*)leftPos
{
    return self.gtcCurrentSizeClass.leftPos;
}

-(GTCLayoutPosition*)rightPos
{
    return self.gtcCurrentSizeClass.rightPos;
}

-(GTCLayoutPosition*)baselinePos
{
    return self.gtcCurrentSizeClass.baselinePos;
}

- (CGFloat)gtc_top
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_top;
}

- (void)setGtc_top:(CGFloat)gtc_top
{
    self.gtcCurrentSizeClass.gtc_top = gtc_top;
}

- (CGFloat)gtc_leading
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_leading;
}

- (void)setGtc_leading:(CGFloat)gtc_leading
{
    self.gtcCurrentSizeClass.gtc_leading = gtc_leading;
}

- (CGFloat)gtc_bottom
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_bottom;
}

- (void)setGtc_bottom:(CGFloat)gtc_bottom
{
    self.gtcCurrentSizeClass.gtc_bottom = gtc_bottom;
}

- (CGFloat)gtc_trailing
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_trailing;
}

- (void)setGtc_trailing:(CGFloat)gtc_trailing
{
    self.gtcCurrentSizeClass.gtc_trailing = gtc_trailing;
}

- (CGFloat)gtc_centerX
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_centerX;
}

- (void)setGtc_centerX:(CGFloat)gtc_centerX
{
    self.gtcCurrentSizeClass.gtc_centerX = gtc_centerX;
}

- (CGFloat)gtc_centerY
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_centerY;
}

- (void)setGtc_centerY:(CGFloat)gtc_centerY
{
    self.gtcCurrentSizeClass.gtc_centerY = gtc_centerY;
}

- (CGPoint)gtc_center
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_center;
}

- (void)setGtc_center:(CGPoint)gtc_center
{
    self.gtcCurrentSizeClass.gtc_center = gtc_center;
}


- (CGFloat)gtc_left
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_left;
}

- (void)setGtc_left:(CGFloat)gtc_left
{
    self.gtcCurrentSizeClass.gtc_left = gtc_left;
}

- (CGFloat)gtc_right
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_right;
}

- (void)setGtc_right:(CGFloat)gtc_right
{
    self.gtcCurrentSizeClass.gtc_right = gtc_right;
}



- (CGFloat)gtc_margin
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_margin;
}

- (void)setGtc_margin:(CGFloat)gtc_margin
{
    self.gtcCurrentSizeClass.gtc_margin = gtc_margin;
}

- (CGFloat)gtc_horzMargin
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_horzMargin;
}

- (void)setGtc_horzMargin:(CGFloat)gtc_horzMargin
{
    self.gtcCurrentSizeClass.gtc_horzMargin = gtc_horzMargin;
}

- (CGFloat)gtc_vertMargin
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_vertMargin;
}

- (void)setGtc_vertMargin:(CGFloat)gtc_vertMargin
{
    self.gtcCurrentSizeClass.gtc_vertMargin = gtc_vertMargin;

}

-(GTCLayoutSize*)widthSize
{
    return self.gtcCurrentSizeClass.widthSize;
}

-(GTCLayoutSize*)heightSize
{
    return self.gtcCurrentSizeClass.heightSize;
}


- (CGFloat)gtc_width
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_width;
}

- (void)setGtc_width:(CGFloat)gtc_width
{
    self.gtcCurrentSizeClass.gtc_width = gtc_width;
}

- (CGFloat)gtc_height
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtcCurrentSizeClass.gtc_height;
}

- (void)setGtc_height:(CGFloat)gtc_height
{
    self.gtcCurrentSizeClass.gtc_height = gtc_height;
}

- (CGSize)gtc_size
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif

    return self.gtcCurrentSizeClass.gtc_size;
}

- (void)setGtc_size:(CGSize)gtc_size
{
    self.gtcCurrentSizeClass.gtc_size = gtc_size;
}

-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.wrapContentHeight != wrapContentHeight)
    {
        sc.wrapContentHeight = wrapContentHeight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)wrapContentHeight
{
    //特殊处理，减少不必要的对象创建
    return self.gtcCurrentSizeClassInner.wrapContentHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.wrapContentWidth != wrapContentWidth)
    {
        sc.wrapContentWidth = wrapContentWidth;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }

}

-(BOOL)wrapContentWidth
{
    //特殊处理，减少不必要的对象创建
    return self.gtcCurrentSizeClassInner.wrapContentWidth;
}


-(BOOL)wrapContentSize
{
    return self.gtcCurrentSizeClassInner.wrapContentSize;
}

-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.wrapContentSize != wrapContentSize)
    {
        sc.wrapContentSize = wrapContentSize;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}


-(CGFloat)weight
{
    return self.gtcCurrentSizeClass.weight;
}

-(void)setWeight:(CGFloat)weight
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.weight != weight)
    {
        sc.weight = weight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)useFrame
{
    return self.gtcCurrentSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.useFrame != useFrame)
    {
        sc.useFrame = useFrame;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }

}

-(BOOL)noLayout
{
    return self.gtcCurrentSizeClass.noLayout;
}

-(void)setNoLayout:(BOOL)noLayout
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.noLayout != noLayout)
    {
        sc.noLayout = noLayout;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }

}

- (GTCVisibility)gtc_visibility
{
    return self.gtcCurrentSizeClass.gtc_visibility;

}

- (void)setGtc_visibility:(GTCVisibility)gtc_visibility
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.gtc_visibility != gtc_visibility)
    {
        sc.gtc_visibility = gtc_visibility;
        if (gtc_visibility == GTCVisibilityVisible)
            self.hidden = NO;
        else
            self.hidden = YES;

        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
}

- (GTCGravity)gtc_alignment
{
    return self.gtcCurrentSizeClass.gtc_alignment;
}

- (void)setGtc_alignment:(GTCGravity)gtc_alignment
{
    UIView *sc = self.gtcCurrentSizeClass;
    if (sc.gtc_alignment != gtc_alignment)
    {
        sc.gtc_alignment = gtc_alignment;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
}

- (void (^)(GTCBaseLayout *, UIView *))viewLayoutCompleteBlock
{
    return self.gtcCurrentSizeClass.viewLayoutCompleteBlock;
}

- (void)setViewLayoutCompleteBlock:(void (^)(GTCBaseLayout *, UIView *))viewLayoutCompleteBlock
{
    self.gtcCurrentSizeClass.viewLayoutCompleteBlock = viewLayoutCompleteBlock;
}

-(CGRect)estimatedRect
{
    CGRect rect = self.gtcFrame.frame;
    if (rect.size.width == CGFLOAT_MAX || rect.size.height == CGFLOAT_MAX)
        return self.frame;
    return rect;
}

- (void)resetGTLayoutSetting
{
    [self resetGTLayoutSettingInSizeClass:GTCSizeClasswAny | GTCSizeClasshAny];
}

- (void)resetGTLayoutSettingInSizeClass:(GTCSizeClass)sizeClass
{
    [self.gtcFrame.sizeClasses removeObjectForKey:@(sizeClass)];
}

-(instancetype)fetchLayoutSizeClass:(GTCSizeClass)sizeClass
{
    return [self fetchLayoutSizeClass:sizeClass copyFrom:0xFF];
}

-(instancetype)fetchLayoutSizeClass:(GTCSizeClass)sizeClass copyFrom:(GTCSizeClass)srcSizeClass
{
    GTCFrame *gtcFrame = self.gtcFrame;
    if (gtcFrame.sizeClasses == nil)
        gtcFrame.sizeClasses = [NSMutableDictionary new];

    GTCViewSizeClass *gtcLayoutSizeClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(sizeClass)];
    if (gtcLayoutSizeClass == nil)
    {
        GTCViewSizeClass *srcLayoutSizeClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(srcSizeClass)];
        if (srcLayoutSizeClass == nil)
            gtcLayoutSizeClass = [self createSizeClassInstance];
        else
            gtcLayoutSizeClass = [srcLayoutSizeClass copy];
        gtcLayoutSizeClass.view = self;
        [gtcFrame.sizeClasses setObject:gtcLayoutSizeClass forKey:@(sizeClass)];
    }

    return (UIView*)gtcLayoutSizeClass;
}

@end


@implementation UIView(GTCLayoutExtInner)

- (instancetype)gtcDefaultSizeClass
{
    return [self fetchLayoutSizeClass:GTCSizeClasswAny | GTCSizeClasshAny];
}

- (instancetype)gtcCurrentSizeClass
{
    GTCFrame *gtcFrame = self.gtcFrame;  //减少多次访问，增加性能。
    if (gtcFrame.sizeClass == nil) {
        gtcFrame.sizeClass = [self gtcDefaultSizeClass];
    }
    return gtcFrame.sizeClass;
}

- (instancetype)gtcCurrentSizeClassInner
{
    //如果没有则不会建立，为了优化减少不必要的建立。
    GTCFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_GTLAYOUT_FRAME);
    return obj.sizeClass;
}

- (instancetype)gtcCurrentSizeClassFrom:(GTCFrame *)gtcFrame
{
    if (gtcFrame.sizeClass == nil)
        gtcFrame.sizeClass = [self gtcDefaultSizeClass];

    return gtcFrame.sizeClass;
}

- (instancetype)gtcBestSizeClass:(GTCSizeClass)sizeClass
{
    GTCSizeClass wsc = sizeClass & 0x03;
    GTCSizeClass hsc = sizeClass & 0x0C;
    GTCSizeClass ori = sizeClass & 0xC0;

    GTCFrame *gtcFrame = self.gtcFrame;

    if (gtcFrame.sizeClasses == nil)
        gtcFrame.sizeClasses = [NSMutableDictionary new];


    GTCSizeClass searchSizeClass;
    GTCViewSizeClass *gtcClass = nil;
    if (gtcFrame.multiple)
    {
        //first search the most exact SizeClass
        searchSizeClass = wsc | hsc | ori;
        gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
        if (gtcClass != nil)
            return (UIView*)gtcClass;


        searchSizeClass = wsc | hsc;
        if (searchSizeClass != sizeClass)
        {
            GTCViewSizeClass *gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtcClass != nil)
                return (UIView*)gtcClass;
        }


        searchSizeClass = GTCSizeClasswAny | hsc | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtcClass != nil)
                return (UIView*)gtcClass;

        }

        searchSizeClass = GTCSizeClasswAny | hsc;
        if (searchSizeClass != sizeClass)
        {
            gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtcClass != nil)
                return (UIView*)gtcClass;
        }

        searchSizeClass = wsc | GTCSizeClasshAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtcClass != nil)
                return (UIView*)gtcClass;
        }

        searchSizeClass = wsc | GTCSizeClasshAny;
        if (searchSizeClass != sizeClass)
        {
            gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtcClass != nil)
                return (UIView*)gtcClass;
        }

        searchSizeClass = GTCSizeClasswAny | GTCSizeClasshAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtcClass != nil)
                return (UIView*)gtcClass;
        }

    }

    searchSizeClass = GTCSizeClasswAny | GTCSizeClasshAny;
    gtcClass = (GTCViewSizeClass*)[gtcFrame.sizeClasses objectForKey:@(searchSizeClass)];
    if (gtcClass == nil)
    {
        gtcClass = [self createSizeClassInstance];
        gtcClass.view = self;
        [gtcFrame.sizeClasses setObject:gtcClass forKey:@(searchSizeClass)];
    }

    return (UIView*)gtcClass;

}


-(GTCFrame*)gtcFrame
{

    GTCFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_GTLAYOUT_FRAME);
    if (obj == nil)
    {
        obj = [GTCFrame new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_GTLAYOUT_FRAME, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (id)createSizeClassInstance
{
    return [GTCViewSizeClass new];
}

- (GTCLayoutPosition *)topPosInner
{
    return self.gtcCurrentSizeClass.topPosInner;
}

-(GTCLayoutPosition*)leadingPosInner
{
    return self.gtcCurrentSizeClass.leadingPosInner;
}

-(GTCLayoutPosition*)bottomPosInner
{
    return self.gtcCurrentSizeClass.bottomPosInner;
}

-(GTCLayoutPosition*)trailingPosInner
{
    return self.gtcCurrentSizeClass.trailingPosInner;
}

-(GTCLayoutPosition*)centerXPosInner
{
    return self.gtcCurrentSizeClass.centerXPosInner;
}

-(GTCLayoutPosition*)centerYPosInner
{
    return self.gtcCurrentSizeClass.centerYPosInner;
}

-(GTCLayoutPosition*)leftPosInner
{
    return self.gtcCurrentSizeClass.leftPosInner;
}

-(GTCLayoutPosition*)rightPosInner
{
    return self.gtcCurrentSizeClass.rightPosInner;
}

-(GTCLayoutPosition*)baselinePosInner
{
    return self.gtcCurrentSizeClass.baselinePosInner;
}

-(GTCLayoutSize*)widthSizeInner
{
    return self.gtcCurrentSizeClass.widthSizeInner;
}

-(GTCLayoutSize*)heightSizeInner
{
    return self.gtcCurrentSizeClass.heightSizeInner;
}


@end





@implementation GTCBaseLayout
{
    GTCLayoutTouchEventDelegate *_touchEventDelegate;

    GTCBorderlineLayerDelegate *_borderlineLayerDelegate;

    BOOL _isAddSuperviewKVO;

    int _lastScreenOrientation; //为0为初始状态，为1为竖屏，为2为横屏。内部使用。

    BOOL _useCacheRects;
}


-(void)dealloc
{
    //如果您在使用时出现了KVO的异常崩溃，原因是您将这个视图被多次加入为子视图，请检查您的代码，是否这个视图被多次加入！！
    _endLayoutBlock = nil;
    _beginLayoutBlock = nil;
    _rotationToDeviceOrientationBlock = nil;
}

#pragma  mark -- Public Methods


+(BOOL)isRTL
{
    return [GTCViewSizeClass isRTL];
}

+(void)setIsRTL:(BOOL)isRTL
{
    [GTCViewSizeClass setIsRTL:isRTL];
}



-(CGFloat)topPadding
{
    return self.gtcCurrentSizeClass.topPadding;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.topPadding != topPadding)
    {
        lsc.topPadding = topPadding;
        [self setNeedsLayout];
    }
}

-(CGFloat)leadingPadding
{
    return self.gtcCurrentSizeClass.leadingPadding;
}

-(void)setLeadingPadding:(CGFloat)leadingPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.leadingPadding != leadingPadding)
    {
        lsc.leadingPadding = leadingPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)bottomPadding
{
    return self.gtcCurrentSizeClass.bottomPadding;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.bottomPadding != bottomPadding)
    {
        lsc.bottomPadding = bottomPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)trailingPadding
{
    return self.gtcCurrentSizeClass.trailingPadding;
}

-(void)setTrailingPadding:(CGFloat)trailingPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.trailingPadding != trailingPadding)
    {
        lsc.trailingPadding = trailingPadding;
        [self setNeedsLayout];
    }
}


-(UIEdgeInsets)padding
{
    return self.gtcCurrentSizeClass.padding;
}

-(void)setPadding:(UIEdgeInsets)padding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (!UIEdgeInsetsEqualToEdgeInsets(lsc.padding, padding))
    {
        lsc.padding = padding;
        [self setNeedsLayout];
    }
}


-(CGFloat)leftPadding
{
    return self.gtcCurrentSizeClass.leftPadding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.leftPadding != leftPadding)
    {
        lsc.leftPadding = leftPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)rightPadding
{
    return self.gtcCurrentSizeClass.rightPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.rightPadding != rightPadding)
    {
        lsc.rightPadding = rightPadding;
        [self setNeedsLayout];
    }
}

-(BOOL)zeroPadding
{
    return self.gtcCurrentSizeClass.zeroPadding;
}

-(void)setZeroPadding:(BOOL)zeroPadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.zeroPadding != zeroPadding)
    {
        lsc.zeroPadding = zeroPadding;
        [self setNeedsLayout];
    }
}

-(UIRectEdge)insetsPaddingFromSafeArea
{
    return self.gtcCurrentSizeClass.insetsPaddingFromSafeArea;
}

-(void)setInsetsPaddingFromSafeArea:(UIRectEdge)insetsPaddingFromSafeArea
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.insetsPaddingFromSafeArea != insetsPaddingFromSafeArea)
    {
        lsc.insetsPaddingFromSafeArea = insetsPaddingFromSafeArea;
        [self setNeedsLayout];
    }
}

-(BOOL)insetLandscapeFringePadding
{
    return self.gtcCurrentSizeClass.insetLandscapeFringePadding;
}

-(void)setInsetLandscapeFringePadding:(BOOL)insetLandscapeFringePadding
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.insetLandscapeFringePadding != insetLandscapeFringePadding)
    {
        lsc.insetLandscapeFringePadding = insetLandscapeFringePadding;
        [self setNeedsLayout];
    }
}

-(void)setSubviewHSpace:(CGFloat)subviewHSpace
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;

    if (lsc.subviewHSpace != subviewHSpace)
    {
        lsc.subviewHSpace = subviewHSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewHSpace
{
    return self.gtcCurrentSizeClass.subviewHSpace;
}

-(void)setSubviewVSpace:(CGFloat)subviewVSpace
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.subviewVSpace != subviewVSpace)
    {
        lsc.subviewVSpace = subviewVSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewVSpace
{
    return self.gtcCurrentSizeClass.subviewVSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;

    if (lsc.subviewSpace != subviewSpace)
    {
        lsc.subviewSpace = subviewSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewSpace
{
    return self.gtcCurrentSizeClass.subviewSpace;
}

-(void)setGravity:(GTCGravity)gravity
{

    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.gravity != gravity)
    {
        lsc.gravity = gravity;
        [self setNeedsLayout];
    }
}

-(GTCGravity)gravity
{
    return self.gtcCurrentSizeClass.gravity;
}



-(void)setReverseLayout:(BOOL)reverseLayout
{

    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.reverseLayout != reverseLayout)
    {
        lsc.reverseLayout = reverseLayout;
        [self setNeedsLayout];
    }
}

-(BOOL)reverseLayout
{
    return self.gtcCurrentSizeClass.reverseLayout;
}



-(CGAffineTransform)layoutTransform
{
    return self.gtcCurrentSizeClass.layoutTransform;
}

-(void)setLayoutTransform:(CGAffineTransform)layoutTransform
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (!CGAffineTransformEqualToTransform(lsc.layoutTransform, layoutTransform))
    {
        lsc.layoutTransform = layoutTransform;
        [self setNeedsLayout];
    }
}

-(void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


-(void)layoutAnimationWithDuration:(NSTimeInterval)duration
{
    self.beginLayoutBlock = ^{

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
    };

    self.endLayoutBlock = ^{

        [UIView commitAnimations];
    };
}

-(GTCBorderline*)topBorderline
{
    return _borderlineLayerDelegate.topBorderline;
}

-(void)setTopBorderline:(GTCBorderline *)topBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }

    _borderlineLayerDelegate.topBorderline = topBorderline;
}

-(GTCBorderline*)leadingBorderline
{
    return _borderlineLayerDelegate.leadingBorderline;
}

-(void)setLeadingBorderline:(GTCBorderline *)leadingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }

    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}

-(GTCBorderline*)bottomBorderline
{
    return _borderlineLayerDelegate.bottomBorderline;
}

-(void)setBottomBorderline:(GTCBorderline *)bottomBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }

    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}


-(GTCBorderline*)trailingBorderline
{
    return _borderlineLayerDelegate.trailingBorderline;
}

-(void)setTrailingBorderline:(GTCBorderline *)trailingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }

    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}



-(GTCBorderline*)leftBorderline
{
    return _borderlineLayerDelegate.leftBorderline;
}

-(void)setLeftBorderline:(GTCBorderline *)leftBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }

    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}


-(GTCBorderline*)rightBorderline
{
    return _borderlineLayerDelegate.rightBorderline;
}

-(void)setRightBorderline:(GTCBorderline *)rightBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }

    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}


-(void)setBoundBorderline:(GTCBorderline *)boundBorderline
{
    self.leadingBorderline = boundBorderline;
    self.trailingBorderline = boundBorderline;
    self.topBorderline = boundBorderline;
    self.bottomBorderline = boundBorderline;
}

-(GTCBorderline*)boundBorderline
{
    return self.bottomBorderline;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        _backgroundImage = backgroundImage;
        self.layer.contents = (id)_backgroundImage.CGImage;
    }
}



-(CGSize)gtcEstimateLayoutRect:(CGSize)size inSizeClass:(GTCSizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    GTCFrame *selfGtcFrame = self.gtcFrame;

    if (selfGtcFrame.multiple)
        selfGtcFrame.sizeClass = [self gtcBestSizeClass:sizeClass];

    for (UIView *sbv in self.subviews)
    {
        GTCFrame *sbvFrame = sbv.gtcFrame;
        if (sbvFrame.multiple)
            sbvFrame.sizeClass = [sbv gtcBestSizeClass:sizeClass];
    }

    BOOL hasSubLayout = NO;
    CGSize selfSize= [self calcLayoutRect:size isEstimate:NO pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];

    if (hasSubLayout)
    {
        selfGtcFrame.width = selfSize.width;
        selfGtcFrame.height = selfSize.height;

        selfSize = [self calcLayoutRect:CGSizeZero isEstimate:YES pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    }

    selfGtcFrame.width = selfSize.width;
    selfGtcFrame.height = selfSize.height;



    //计算后还原为默认sizeClass
    for (UIView *sbv in self.subviews)
    {
        GTCFrame *sbvFrame = sbv.gtcFrame;
        if (sbvFrame.multiple)
            sbvFrame.sizeClass = self.gtcDefaultSizeClass;
    }

    if (selfGtcFrame.multiple)
        selfGtcFrame.sizeClass = self.gtcDefaultSizeClass;

    if (self.cacheEstimatedRect)
        _useCacheRects = YES;

    return CGSizeMake(_gtcCGFloatRound(selfSize.width), _gtcCGFloatRound(selfSize.height));
}

-(void)setCacheEstimatedRect:(BOOL)cacheEstimatedRect
{
    _cacheEstimatedRect = cacheEstimatedRect;
    _useCacheRects = NO;
}


-(CGRect)subview:(UIView*)subview estimatedRectInLayoutSize:(CGSize)size
{
    if (subview.superview == self)
        return subview.frame;

    NSMutableArray *sbs = [self gtcGetLayoutSubviews];
    [sbs addObject:subview];

    [self gtcEstimateLayoutRect:size inSizeClass:GTCSizeClasswAny | GTCSizeClasshAny sbs:sbs];

    return [subview estimatedRect];
}



-(void)setHighlightedOpacity:(CGFloat)highlightedOpacity
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTCLayoutTouchEventDelegate alloc] initWithLayout:self];
    }

    _touchEventDelegate.highlightedOpacity = highlightedOpacity;
}

-(CGFloat)highlightedOpacity
{
    return _touchEventDelegate.highlightedOpacity;
}

-(void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTCLayoutTouchEventDelegate alloc] initWithLayout:self];
    }

    _touchEventDelegate.highlightedBackgroundColor = highlightedBackgroundColor;
}

-(UIColor*)highlightedBackgroundColor
{
    return _touchEventDelegate.highlightedBackgroundColor;
}

-(void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTCLayoutTouchEventDelegate alloc] initWithLayout:self];
    }

    _touchEventDelegate.highlightedBackgroundImage = highlightedBackgroundImage;
}

-(UIImage*)highlightedBackgroundImage
{
    return _touchEventDelegate.highlightedBackgroundImage;
}


-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTCLayoutTouchEventDelegate alloc] initWithLayout:self];
    }

    [_touchEventDelegate setTarget:target action:action];
}


-(void)setTouchDownTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTCLayoutTouchEventDelegate alloc] initWithLayout:self];
    }

    [_touchEventDelegate setTouchDownTarget:target action:action];
}

-(void)setTouchCancelTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTCLayoutTouchEventDelegate alloc] initWithLayout:self];
    }

    [_touchEventDelegate setTouchCancelTarget:target action:action];

}















#pragma mark -- Touches Event


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [_touchEventDelegate touchesBegan:touches withEvent:event];

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark -- KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{

    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (context == _gtcObserverContextC)
    {
        //只监控父视图的尺寸变换
        CGRect rcOld = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect rcNew = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (!_gtcCGSizeEqual(rcOld.size, rcNew.size))
        {
            [self gtcUpdateLayoutRectInNoLayoutSuperview:object];
        }
        return;
    }


    //监控子视图的frame的变化以便重新进行布局
    if (!_isGTLayouting)
    {

        if (context == _gtcObserverContextA)
        {
            [self setNeedsLayout];
            //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
            if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue])
            {
                [(UIView*)object setNeedsDisplay];
            }

        }
        else if (context == _gtcObserverContextB)
        {//针对UILabel特殊处理。。

            UIView *sbvsc = object.gtcCurrentSizeClass;

            if (sbvsc.widthSizeInner.dimeSelfVal != nil && sbvsc.heightSizeInner.dimeSelfVal != nil)
            {
                [self setNeedsLayout];
            }
            else if (sbvsc.wrapContentWidth ||
                     sbvsc.wrapContentHeight ||
                     sbvsc.widthSizeInner.dimeSelfVal != nil ||
                     sbvsc.heightSizeInner.dimeSelfVal != nil)
            {
                [object sizeToFit];
            }
        }
    }
}


#pragma mark -- Override Methods



-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.wrapContentHeight != wrapContentHeight)
    {
        lsc.wrapContentHeight = wrapContentHeight;
        [self setNeedsLayout];
    }
}


-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.wrapContentWidth != wrapContentWidth)
    {
        lsc.wrapContentWidth = wrapContentWidth;
        [self setNeedsLayout];
    }

}

-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.wrapContentSize != wrapContentSize)
    {
        lsc.wrapContentSize = wrapContentSize;
        [self setNeedsLayout];
    }
}



-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTCSizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize;
    if (isEstimate)
        selfSize = self.gtcFrame.frame.size;
    else
    {
        selfSize = self.bounds.size;
        if (size.width != 0)
            selfSize.width = size.width;
        if (size.height != 0)
            selfSize.height = size.height;
    }

    if (pHasSubLayout != nil)
        *pHasSubLayout = NO;

    return selfSize;

}


-(id)createSizeClassInstance
{
    return [GTCLayoutViewSizeClass new];
}


-(CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeThatFits:size inSizeClass:GTCSizeClasswAny | GTCSizeClasshAny];
}

-(CGSize)sizeThatFits:(CGSize)size inSizeClass:(GTCSizeClass)sizeClass
{
    return [self gtcEstimateLayoutRect:size inSizeClass:sizeClass sbs:nil];
}


-(void)setHidden:(BOOL)hidden
{
    if (self.isHidden == hidden)
        return;

    [super setHidden:hidden];
    if (hidden == NO)
    {

        [_borderlineLayerDelegate setNeedsLayoutIn:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) withLayer:self.layer];

        if ([self.superview isKindOfClass:[GTCBaseLayout class]])
        {
            [self setNeedsLayout];
        }

    }

}



- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];   //只要加入进来后就修改其默认的实现，而改用我们的实现，这里包括隐藏,调整大小，

    if ([subview isKindOfClass:[GTCBaseLayout class]])
    {
        ((GTCBaseLayout*)subview).cacheEstimatedRect = self.cacheEstimatedRect;
    }

}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];  //删除后恢复其原来的实现。

    [self gtcRemoveSubviewObserver:subview];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (newWindow == nil)
    {
        //这里处理可能因为触摸事件被强行终止而导致的背景色无法恢复的问题。
        [_touchEventDelegate gtcResetTouchHighlighted2];
    }
}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    GTCBaseLayout *lsc = self.gtcCurrentSizeClass;

    //特殊处理如果视图是控制器根视图则取消wrapContentWidth, wrapContentHeight,以及adjustScrollViewContentSizeMode的设置。
    @try {

        if (newSuperview != nil)
        {
            UIRectEdge defRectEdge = UIRectEdgeLeft | UIRectEdgeRight;
            id vc = [self valueForKey:@"viewDelegate"];
            if (vc != nil)
            {
                lsc.wrapContentWidth = NO;
                lsc.wrapContentHeight = NO;
                if (lsc.insetsPaddingFromSafeArea == defRectEdge)
                    lsc.insetsPaddingFromSafeArea = ~UIRectEdgeTop;
                self.adjustScrollViewContentSizeMode = GTCAdjustScrollViewContentSizeModeNo;
            }

            //如果布局视图的父视图是滚动视图并且是非UITableView和UICollectionView的话。将默认叠加除顶部外的安全区域。
            if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
            {
                if (lsc.insetsPaddingFromSafeArea == defRectEdge)
                    lsc.insetsPaddingFromSafeArea = ~UIRectEdgeTop;
            }
        }

    } @catch (NSException *exception) {

    }


#ifdef DEBUG

    if (lsc.wrapContentHeight && lsc.heightSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentHeight和设置的heightSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentHeight and heightSize setting may be constraint.",self);
    }

    if (lsc.wrapContentWidth && lsc.widthSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentWidth和设置的widthSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentWidth and widthSize setting may be constraint.",self);
    }

#endif




    //将要添加到父视图时，如果不是GTLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[GTCBaseLayout class]])
    {

#ifdef DEBUG

        if (lsc.leadingPosInner.posRelaVal != nil)
        {
            //约束冲突：左边距依赖的视图不是父视图
            NSCAssert(lsc.leadingPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@leading pos dependent on:%@is not superview",self, lsc.leadingPosInner.posRelaVal.view);
        }

        if (lsc.trailingPosInner.posRelaVal != nil)
        {
            //约束冲突：右边距依赖的视图不是父视图
            NSCAssert(lsc.trailingPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@trailing pos dependent on:%@is not superview",self,lsc.trailingPosInner.posRelaVal.view);
        }

        if (lsc.centerXPosInner.posRelaVal != nil)
        {
            //约束冲突：水平中心点依赖的视图不是父视图
            NSCAssert(lsc.centerXPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@horizontal center pos dependent on:%@is not superview",self, lsc.centerXPosInner.posRelaVal.view);
        }

        if (lsc.topPosInner.posRelaVal != nil)
        {
            //约束冲突：上边距依赖的视图不是父视图
            NSCAssert(lsc.topPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@top pos dependent on:%@is not superview",self, lsc.topPosInner.posRelaVal.view);
        }

        if (lsc.bottomPosInner.posRelaVal != nil)
        {
            //约束冲突：下边距依赖的视图不是父视图
            NSCAssert(lsc.bottomPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@bottom pos dependent on:%@is not superview",self, lsc.bottomPosInner.posRelaVal.view);

        }

        if (lsc.centerYPosInner.posRelaVal != nil)
        {
            //约束冲突：垂直中心点依赖的视图不是父视图
            NSCAssert(lsc.centerYPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! vertical center pos dependent on:%@is not superview",lsc.centerYPosInner.posRelaVal.view);
        }

        if (lsc.widthSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：宽度依赖的视图不是父视图
            NSCAssert(lsc.widthSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@width dependent on:%@is not superview",self, lsc.widthSizeInner.dimeRelaVal.view);
        }

        if (lsc.heightSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：高度依赖的视图不是父视图
            NSCAssert(lsc.heightSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@height dependent on:%@is not superview",self,lsc.heightSizeInner.dimeRelaVal.view);
        }

#endif

        if ([self gtcUpdateLayoutRectInNoLayoutSuperview:newSuperview])
        {
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃

            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可

            if (_isAddSuperviewKVO && self.superview != nil && ![self.superview isKindOfClass:[GTCBaseLayout class]])
            {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];

                }
                @catch (NSException *exception) {

                }
                @finally {

                }

                @try {
                    [self.superview removeObserver:self forKeyPath:@"bounds"];

                }
                @catch (NSException *exception) {

                }
                @finally {

                }


            }

            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_gtcObserverContextC];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_gtcObserverContextC];
            _isAddSuperviewKVO = YES;
        }
    }


    if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[GTCBaseLayout class]])
    {

        //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
        //然后在左边将异常断点清除即可

        _isAddSuperviewKVO = NO;
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];

        }
        @catch (NSException *exception) {

        }
        @finally {

        }

        @try {
            [self.superview removeObserver:self forKeyPath:@"bounds"];

        }
        @catch (NSException *exception) {

        }
        @finally {

        }


    }


    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
        {
            if (self.adjustScrollViewContentSizeMode == GTCAdjustScrollViewContentSizeModeAuto)
            {
                //这里预先设置一下contentSize主要是为了解决contentOffset在后续计算contentSize的偏移错误的问题。
                [UIView performWithoutAnimation:^{
                    UIScrollView *scrollSuperView = (UIScrollView*)newSuperview;
                    if (CGSizeEqualToSize(scrollSuperView.contentSize, CGSizeZero))
                    {
                        CGSize screenSize = [UIScreen mainScreen].bounds.size;
                        scrollSuperView.contentSize =  CGSizeMake(0, screenSize.height + 0.1);
                    }
                }];

                self.adjustScrollViewContentSizeMode = GTCAdjustScrollViewContentSizeModeYes;
            }
        }
    }
    else
    {
        self.beginLayoutBlock = nil;
        self.endLayoutBlock = nil;
    }


}


-(void)awakeFromNib
{
    [super awakeFromNib];

    if (self.superview != nil && ![self.superview isKindOfClass:[GTCBaseLayout class]])
        [self gtcUpdateLayoutRectInNoLayoutSuperview:self.superview];
}

-(void)safeAreaInsetsDidChange
{

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

    [super safeAreaInsetsDidChange];
#endif

    if (self.superview != nil && ![self.superview isKindOfClass:[GTCBaseLayout class]] &&
        (self.leadingPosInner.isSafeAreaPos ||
         self.trailingPosInner.isSafeAreaPos ||
         self.topPosInner.isSafeAreaPos ||
         self.bottomPosInner.isSafeAreaPos)
        )
    {
        if (!_isGTLayouting)
        {
            _isGTLayouting = YES;
            [self gtcUpdateLayoutRectInNoLayoutSuperview:self.superview];
            _isGTLayouting = NO;
        }
    }
}

-(void)layoutSubviews
{

    if (!self.autoresizesSubviews)
        return;

    if (self.beginLayoutBlock != nil)
        self.beginLayoutBlock();
    self.beginLayoutBlock = nil;

    int  currentScreenOrientation = 0;


    if (!self.isGTLayouting)
    {

        _isGTLayouting = YES;

        if (self.priorAutoresizingMask)
            [super layoutSubviews];

        //减少每次调用就计算设备方向以及sizeclass的次数。
        GTCSizeClass sizeClass = [self gtcGetGlobalSizeClass];
        if ((sizeClass & 0xF0) == GTCSizeClassPortrait)
            currentScreenOrientation = 1;
        else if ((sizeClass & 0xF0) == GTCSizeClassLandscape)
            currentScreenOrientation = 2;

        GTCFrame *selfGtcFrame = self.gtcFrame;
        if (selfGtcFrame.multiple)
            selfGtcFrame.sizeClass = [self gtcBestSizeClass:sizeClass];
        for (UIView *sbv in self.subviews)
        {
            GTCFrame *sbvFrame = sbv.gtcFrame;
            if (sbvFrame.multiple)
                sbv.gtcFrame.sizeClass = [sbv gtcBestSizeClass:sizeClass];

            if (!sbvFrame.hasObserver && sbvFrame.sizeClass != nil && !sbvFrame.sizeClass.useFrame)
            {
                [self gtcAddSubviewObserver:sbv sbvFrame:sbvFrame];
            }
        }

        GTCBaseLayout *lsc = (GTCBaseLayout*)selfGtcFrame.sizeClass;


        //计算布局
        CGSize oldSelfSize = self.bounds.size;
        CGSize newSelfSize;
        if (_useCacheRects && selfGtcFrame.width != CGFLOAT_MAX && selfGtcFrame.height != CGFLOAT_MAX)
        {
            newSelfSize = CGSizeMake(selfGtcFrame.width, selfGtcFrame.height);
        }
        else
        {
            newSelfSize = [self calcLayoutRect:[self gtcCalcSizeInNoLayoutSuperview:self.superview currentSize:oldSelfSize] isEstimate:NO pHasSubLayout:nil sizeClass:sizeClass sbs:nil];
        }
        newSelfSize = _gtcCGSizeRound(newSelfSize);
        _useCacheRects = NO;

        static CGFloat sSizeError = 0;
        if (sSizeError == 0)
            sSizeError = 1 / [UIScreen mainScreen].scale + 0.0001;  //误差量。

        //设置子视图的frame并还原
        for (UIView *sbv in self.subviews)
        {
            CGRect sbvOldBounds = sbv.bounds;
            CGPoint sbvOldCenter = sbv.center;

            GTCFrame *sbvFrame = sbv.gtcFrame;
            UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

            if (sbvFrame.leading != CGFLOAT_MAX && sbvFrame.top != CGFLOAT_MAX && !sbvsc.noLayout && !sbvsc.useFrame)
            {
                if (sbvFrame.width < 0)
                {
                    sbvFrame.width = 0;
                }
                if (sbvFrame.height < 0)
                {
                    sbvFrame.height = 0;
                }

                //这里的位置需要进行有效像素的舍入处理，否则可能出现文本框模糊，以及视图显示可能多出一条黑线的问题。
                //原因是当frame中的值不能有效的转化为最小可绘制的物理像素时就会出现模糊，虚化，多出黑线，以及layer处理圆角不圆的情况。
                //所以这里要将frame中的点转化为有效的点。
                //这里之所以讲布局子视图的转化方法和一般子视图的转化方法区分开来是因为。我们要保证布局子视图不能出现细微的重叠，因为布局子视图有边界线
                //如果有边界线而又出现细微重叠的话，那么边界线将无法正常显示，因此这里做了一个特殊的处理。
                CGRect rc;
                if ([sbv isKindOfClass:[GTCBaseLayout class]])
                {
                    rc  = _gtcLayoutCGRectRound(sbvFrame.frame);


                    CGRect sbvTempBounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rc.size.width, rc.size.height);

                    if (_gtcCGFloatErrorEqual(sbvTempBounds.size.width, sbvOldBounds.size.width, sSizeError))
                        sbvTempBounds.size.width = sbvOldBounds.size.width;

                    if (_gtcCGFloatErrorEqual(sbvTempBounds.size.height, sbvOldBounds.size.height, sSizeError))
                        sbvTempBounds.size.height = sbvOldBounds.size.height;


                    if (_gtcCGFloatErrorNotEqual(sbvTempBounds.size.width, sbvOldBounds.size.width, sSizeError)||
                        _gtcCGFloatErrorNotEqual(sbvTempBounds.size.height, sbvOldBounds.size.height, sSizeError))
                    {
                        sbv.bounds = sbvTempBounds;
                    }

                    CGPoint sbvTempCenter = CGPointMake(rc.origin.x + sbv.layer.anchorPoint.x * sbvTempBounds.size.width, rc.origin.y + sbv.layer.anchorPoint.y * sbvTempBounds.size.height);

                    if (_gtcCGFloatErrorEqual(sbvTempCenter.x, sbvOldCenter.x, sSizeError))
                        sbvTempCenter.x = sbvOldCenter.x;

                    if (_gtcCGFloatErrorEqual(sbvTempCenter.y, sbvOldCenter.y, sSizeError))
                        sbvTempCenter.y = sbvOldCenter.y;


                    if (_gtcCGFloatErrorNotEqual(sbvTempCenter.x, sbvOldCenter.x, sSizeError)||
                        _gtcCGFloatErrorNotEqual(sbvTempCenter.y, sbvOldCenter.y, sSizeError))
                    {
                        sbv.center = sbvTempCenter;
                    }


                }
                else
                {
                    rc = _gtcCGRectRound(sbvFrame.frame);

                    sbv.center = CGPointMake(rc.origin.x + sbv.layer.anchorPoint.x * rc.size.width, rc.origin.y + sbv.layer.anchorPoint.y * rc.size.height);
                    sbv.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rc.size.width, rc.size.height);

                }

            }

            if (sbvsc.gtc_visibility == GTCVisibilityGone && !sbv.isHidden)
            {
                sbv.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, 0, 0);
            }

            if (sbvFrame.sizeClass.viewLayoutCompleteBlock != nil)
            {
                sbvFrame.sizeClass.viewLayoutCompleteBlock(self, sbv);
                sbvFrame.sizeClass.viewLayoutCompleteBlock = nil;
            }


            if (sbvFrame.multiple)
                sbvFrame.sizeClass = [sbv gtcDefaultSizeClass];
            [sbvFrame reset];
        }


        if (newSelfSize.width != CGFLOAT_MAX && (lsc.wrapContentWidth || lsc.wrapContentHeight))
        {


            //因为布局子视图的新老尺寸计算在上面有两种不同的方法，因此这里需要考虑两种计算的误差值，而这两种计算的误差值是不超过1/屏幕精度的。
            //因此我们认为当二者的值超过误差时我们才认为有尺寸变化。
            BOOL isWidthAlter =  _gtcCGFloatErrorNotEqual(newSelfSize.width, oldSelfSize.width, sSizeError);
            BOOL isHeightAlter = _gtcCGFloatErrorNotEqual(newSelfSize.height, oldSelfSize.height, sSizeError);

            //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
            BOOL isAdjustSelf = YES;
            if (self.superview != nil && [self.superview isKindOfClass:[GTCBaseLayout class]])
            {
                GTCBaseLayout *supl = (GTCBaseLayout*)self.superview;
                if ([supl gtcIsNoLayoutSubview:self])
                    isAdjustSelf = NO;
            }
            if (isAdjustSelf && (isWidthAlter || isHeightAlter))
            {

                if (newSelfSize.width < 0)
                {
                    newSelfSize.width = 0;
                }

                if (newSelfSize.height < 0)
                {
                    newSelfSize.height = 0;
                }

                if (CGAffineTransformIsIdentity(self.transform))
                {
                    CGRect currentFrame = self.frame;
                    if (isWidthAlter && lsc.wrapContentWidth)
                        currentFrame.size.width = newSelfSize.width;

                    if (isHeightAlter && lsc.wrapContentHeight)
                        currentFrame.size.height = newSelfSize.height;

                    self.frame = currentFrame;
                }
                else
                {
                    CGRect currentBounds = self.bounds;
                    CGPoint currentCenter = self.center;

                    if (isWidthAlter && lsc.wrapContentWidth)
                    {
                        currentBounds.size.width = newSelfSize.width;
                        currentCenter.x += (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x;
                    }

                    if (isHeightAlter && lsc.wrapContentHeight)
                    {
                        currentBounds.size.height = newSelfSize.height;
                        currentCenter.y += (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y;
                    }

                    self.bounds = currentBounds;
                    self.center = currentCenter;

                }
            }
        }


        //这里只用width判断的原因是如果newSelfSize被计算成功则size中的所有值都不是CGFLOAT_MAX，所以这里选width只是其中一个代表。
        if (newSelfSize.width != CGFLOAT_MAX)
        {
            UIView *supv = self.superview;


            //更新边界线。
            if (_borderlineLayerDelegate != nil)
            {
                CGRect borderlineRect = CGRectMake(0, 0, newSelfSize.width, newSelfSize.height);
                if ([supv isKindOfClass:[GTCBaseLayout class]])
                {
                    //这里给父布局视图一个机会来可以改变当前布局的borderlineRect的值，也就是显示的边界线有可能会超出当前布局视图本身的区域。
                    //比如一些表格或者其他的情况。默认情况下这个函数什么也不做。
                    [((GTCBaseLayout*)supv) gtcHookSublayout:self borderlineRect:&borderlineRect];
                }

                [_borderlineLayerDelegate setNeedsLayoutIn:borderlineRect withLayer:self.layer];

            }

            //如果自己的父视图是非UIScrollView以及非布局视图。以及自己是wrapContentWidth或者wrapContentHeight时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
            if (supv != nil && ![supv isKindOfClass:[GTCBaseLayout class]])
            {
                CGPoint centerPonintSelf = self.center;
                CGRect rectSelf = self.bounds;
                CGRect rectSuper = supv.bounds;

                //特殊处理低版本下的top和bottom的两种安全区域的场景。
                if ((lsc.topPosInner.isSafeAreaPos || lsc.bottomPosInner.isSafeAreaPos) && [UIDevice currentDevice].systemVersion.doubleValue < 11 )
                {
                    if (lsc.topPosInner.isSafeAreaPos)
                    {
                        centerPonintSelf.y = [lsc.topPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                    }
                    else
                    {
                        centerPonintSelf.y  = rectSuper.size.height - rectSelf.size.height - [lsc.bottomPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                    }
                }

                //如果自己的父视图是非UIScrollView以及非布局视图。以及自己是wrapContentWidth或者wrapContentHeight时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
                if (![supv isKindOfClass:[UIScrollView class]] && (lsc.wrapContentWidth || lsc.wrapContentHeight))
                {

                    if ([GTCBaseLayout isRTL])
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;

                    if (lsc.wrapContentWidth)
                    {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (lsc.centerXPosInner.posVal != nil)
                        {
                            centerPonintSelf.x = (rectSuper.size.width - rectSelf.size.width)/2 + self.layer.anchorPoint.x * rectSelf.size.width;

                            centerPonintSelf.x += [lsc.centerXPosInner realPosIn:rectSuper.size.width];
                        }
                        else if (lsc.trailingPosInner.posVal != nil && lsc.leadingPosInner.posVal == nil)
                        {
                            centerPonintSelf.x  = rectSuper.size.width - rectSelf.size.width - [lsc.trailingPosInner realPosIn:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }

                    }

                    if (lsc.wrapContentHeight)
                    {
                        if (lsc.centerYPosInner.posVal != nil)
                        {
                            centerPonintSelf.y = (rectSuper.size.height - rectSelf.size.height)/2 + [lsc.centerYPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                        else if (lsc.bottomPosInner.posVal != nil && lsc.topPosInner.posVal == nil)
                        {
                            //这里可能有坑，在有安全区时。但是先不处理了。
                            centerPonintSelf.y  = rectSuper.size.height - rectSelf.size.height - [lsc.bottomPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                    }

                    if ([GTCBaseLayout isRTL])
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;

                }

                //如果有变化则只调整自己的center。而不变化
                if (!_gtcCGPointEqual(self.center, centerPonintSelf))
                {
                    self.center = centerPonintSelf;
                }

            }


            //这里处理当布局视图的父视图是非布局父视图，且父视图具有wrap属性时需要调整父视图的尺寸。
            if (supv != nil && ![supv isKindOfClass:[GTCBaseLayout class]])
            {
                if (supv.wrapContentHeight || supv.wrapContentWidth)
                {
                    //调整父视图的高度和宽度。frame值。
                    CGRect superBounds = supv.bounds;
                    CGPoint superCenter = supv.center;

                    if (supv.wrapContentHeight)
                    {
                        superBounds.size.height = [self gtcValidMeasure:supv.heightSizeInner sbv:supv calcSize:lsc.gtc_top + newSelfSize.height + lsc.gtc_bottom sbvSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.y += (superBounds.size.height - supv.bounds.size.height) * supv.layer.anchorPoint.y;
                    }

                    if (supv.wrapContentWidth)
                    {
                        superBounds.size.width = [self gtcValidMeasure:supv.widthSizeInner sbv:supv calcSize:lsc.gtc_leading + newSelfSize.width + lsc.gtc_trailing sbvSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.x += (superBounds.size.width - supv.bounds.size.width) * supv.layer.anchorPoint.x;
                    }

                    if (!_gtcCGRectEqual(supv.bounds, superBounds))
                    {
                        supv.center = superCenter;
                        supv.bounds = superBounds;
                    }

                }
            }

            //处理父视图是滚动视图时动态调整滚动视图的contentSize
            [self gtcAlterScrollViewContentSize:newSelfSize lsc:lsc];
        }


        if (selfGtcFrame.multiple)
            selfGtcFrame.sizeClass = [self gtcDefaultSizeClass];
        _isGTLayouting = NO;

    }

    if (self.endLayoutBlock != nil)
        self.endLayoutBlock();
    self.endLayoutBlock = nil;

    //执行屏幕旋转的处理逻辑。
    if (currentScreenOrientation != 0 && self.rotationToDeviceOrientationBlock != nil)
    {
        if (_lastScreenOrientation == 0)
        {
            _lastScreenOrientation = currentScreenOrientation;
            self.rotationToDeviceOrientationBlock(self,YES, currentScreenOrientation == 1);
        }
        else
        {
            if (_lastScreenOrientation != currentScreenOrientation)
            {
                _lastScreenOrientation = currentScreenOrientation;
                self.rotationToDeviceOrientationBlock(self, NO, currentScreenOrientation == 1);
            }
        }

        _lastScreenOrientation = currentScreenOrientation;
    }


}



#pragma mark -- Private Methods


-(BOOL)gtcIsRelativePos:(CGFloat)margin
{
    return margin > 0 && margin < 1;
}


-(GTCGravity)gtcGetSubviewVertGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc vertGravity:(GTCGravity)vertGravity
{
    GTCGravity sbvVertAligement = sbvsc.gtc_alignment & GTCGravityHorzMask;
    GTCGravity sbvVertGravity = GTCGravityVertTop;

    if (vertGravity != GTCGravityNone)
    {
        sbvVertGravity = vertGravity;
        if (sbvVertAligement != GTCGravityNone)
        {
            sbvVertGravity = sbvVertAligement;
        }
    }
    else
    {

        if (sbvVertAligement != GTCGravityNone)
        {
            sbvVertGravity = sbvVertAligement;
        }

        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            sbvVertGravity = GTCGravityVertFill;
        }
        else if (sbvsc.centerYPosInner.posVal != nil)
        {
            sbvVertGravity = GTCGravityVertCenter;
        }
        else if (sbvsc.topPosInner.posVal != nil)
        {
            sbvVertGravity = GTCGravityVertTop;
        }
        else if (sbvsc.bottomPosInner.posVal != nil)
        {
            sbvVertGravity = GTCGravityVertBottom;
        }
    }

    return sbvVertGravity;
}


-(void)gtcCalcVertGravity:(GTCGravity)vertGravity
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
              paddingTop:(CGFloat)paddingTop
           paddingBottom:(CGFloat)paddingBottom
             baselinePos:(CGFloat)baselinePos
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect
{


    CGFloat  topMargin =  [self gtcValidMargin:sbvsc.topPosInner sbv:sbv calcPos:[sbvsc.topPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];

    CGFloat  centerMargin = [self gtcValidMargin:sbvsc.centerYPosInner sbv:sbv calcPos:[sbvsc.centerYPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];

    CGFloat  bottomMargin = [self gtcValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:[sbvsc.bottomPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];

    //确保设置基线对齐的视图都是UILabel,UITextField,UITextView
    if (baselinePos == CGFLOAT_MAX && vertGravity == GTCGravityVertBaseline)
        vertGravity = GTCGravityVertTop;

    UIFont *sbvFont = nil;
    if (vertGravity == GTCGravityVertBaseline)
    {
        sbvFont = [self gtcGetSubviewFont:sbv];
    }

    if (sbvFont == nil && vertGravity == GTCGravityVertBaseline)
        vertGravity = GTCGravityVertTop;


    if (vertGravity == GTCGravityVertTop)
    {
        pRect->origin.y = paddingTop + topMargin;
    }
    else if (vertGravity == GTCGravityVertBottom)
    {
        pRect->origin.y = selfSize.height - paddingBottom - bottomMargin - pRect->size.height;
    }
    else if (vertGravity == GTCGravityVertBaseline)
    {
        //得到基线位置。
        pRect->origin.y = baselinePos - sbvFont.ascender - (pRect->size.height - sbvFont.lineHeight) / 2;

    }
    else if (vertGravity == GTCGravityVertFill)
    {
        pRect->origin.y = paddingTop + topMargin;
        pRect->size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingTop - paddingBottom - topMargin - bottomMargin  sbvSize:pRect->size selfLayoutSize:selfSize];
    }
    else if (vertGravity == GTCGravityVertCenter)
    {
        pRect->origin.y = (selfSize.height - paddingTop - paddingBottom - topMargin - bottomMargin - pRect->size.height)/2 + paddingTop + topMargin + centerMargin;
    }
    else if (vertGravity == GTCGravityVertWindowCenter)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (CGRectGetHeight(self.window.bounds) - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            pRect->origin.y =  [self.window convertPoint:pRect->origin toView:self].y;
        }
    }
    else
    {
        ;
    }


}


-(GTCGravity)gtcGetSubviewHorzGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc horzGravity:(GTCGravity)horzGravity
{
    GTCGravity sbvHorzAligement = [self gtcConvertLeftRightGravityToLeadingTrailing:sbvsc.gtc_alignment & GTCGravityVertMask];
    GTCGravity sbvHorzGravity = GTCGravityHorzLeading;

    if (horzGravity != GTCGravityNone)
    {
        sbvHorzGravity = horzGravity;
        if (sbvHorzAligement != GTCGravityNone)
        {
            sbvHorzGravity = sbvHorzAligement;
        }
    }
    else
    {

        if (sbvHorzAligement != GTCGravityNone)
        {
            sbvHorzGravity = sbvHorzAligement;
        }

        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            sbvHorzGravity = GTCGravityHorzFill;
        }
        else if (sbvsc.centerXPosInner.posVal != nil)
        {
            sbvHorzGravity = GTCGravityHorzCenter;
        }
        else if (sbvsc.leadingPosInner.posVal != nil)
        {
            sbvHorzGravity = GTCGravityHorzLeading;
        }
        else if (sbvsc.trailingPosInner.posVal != nil)
        {
            sbvHorzGravity = GTCGravityHorzTrailing;
        }
    }

    return sbvHorzGravity;
}


-(void)gtcCalcHorzGravity:(GTCGravity)horzGravity
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
          paddingLeading:(CGFloat)paddingLeading
         paddingTrailing:(CGFloat)paddingTrailing
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect
{
    CGFloat paddingHorz = paddingLeading + paddingTrailing;

    CGFloat leadingMargin = [self gtcValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:[sbvsc.leadingPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];

    CGFloat centerMargin = [self gtcValidMargin:sbvsc.centerXPosInner sbv:sbv calcPos:[sbvsc.centerXPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];

    CGFloat  trailingMargin = [self gtcValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:[sbvsc.trailingPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];


    if (horzGravity == GTCGravityHorzLeading)
    {
        pRect->origin.x = paddingLeading + leadingMargin;
    }
    else if (horzGravity == GTCGravityHorzTrailing)
    {
        pRect->origin.x = selfSize.width - paddingTrailing - trailingMargin - pRect->size.width;
    }
    if (horzGravity == GTCGravityHorzFill)
    {

        pRect->origin.x = paddingLeading + leadingMargin;
        pRect->size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingMargin -  trailingMargin sbvSize:pRect->size selfLayoutSize:selfSize];

    }
    else if (horzGravity == GTCGravityHorzCenter)
    {
        pRect->origin.x = (selfSize.width - paddingHorz - leadingMargin -  trailingMargin - pRect->size.width)/2 + paddingLeading + leadingMargin + centerMargin;
    }
    else if (horzGravity == GTCGravityHorzWindowCenter)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (CGRectGetWidth(self.window.bounds) - leadingMargin - trailingMargin - pRect->size.width)/2 + leadingMargin +  centerMargin;
            pRect->origin.x =  [self.window convertPoint:pRect->origin toView:self].x;

            //因为从右到左布局最后统一进行了转换，但是窗口居中是不按布局来控制的，所以这里为了保持不变需要进行特殊处理。
            if ([GTCBaseLayout isRTL])
            {
                pRect->origin.x = selfSize.width - pRect->origin.x - pRect->size.width;
            }
        }

    }
    else
    {
        ;
    }
}


-(void)gtcCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvFrame:(GTCFrame*)sbvFrame
{
    BOOL isLayoutView = [sbv isKindOfClass:[GTCBaseLayout class]];
    BOOL isWrapWidth = (sbvsc.widthSizeInner.dimeSelfVal != nil) || (!isLayoutView && sbvsc.wrapContentWidth); //宽度包裹特殊处理
    BOOL isWrapHeight = (sbvsc.heightSizeInner.dimeSelfVal != nil) || (!isLayoutView && sbvsc.wrapContentSize);//高度包裹也特殊处理


    if (isWrapWidth || isWrapHeight)
    {

        CGSize thatFits = CGSizeZero;
        //在一些场景中，计算包裹时有可能设置了最大的尺寸约束，所以这里要进行特殊处理。
        thatFits.width = sbvsc.widthSizeInner.uBoundValInner.dimeNumVal.doubleValue;
        thatFits.height = sbvsc.heightSizeInner.uBoundValInner.dimeNumVal.doubleValue;

        CGSize fitSize = [sbv sizeThatFits:thatFits];
        if (isWrapWidth)
        {
            if (sbvsc.wrapContentWidth)
                sbvFrame.width = fitSize.width;
            else
                sbvFrame.width = [sbvsc.widthSizeInner measureWith:fitSize.width];
        }

        if (isWrapHeight)
        {
            if (sbvsc.wrapContentHeight)
                sbvFrame.height = fitSize.height;
            else
                sbvFrame.height = [sbvsc.heightSizeInner measureWith:fitSize.height];
        }
    }
}


-(CGSize)gtcCalcSizeInNoLayoutSuperview:(UIView*)newSuperview currentSize:(CGSize)size
{
    if (newSuperview == nil || [newSuperview isKindOfClass:[GTCBaseLayout class]])
        return size;

    CGRect rectSuper = newSuperview.bounds;
    UIView *ssc = newSuperview.gtcCurrentSizeClassInner;
    UIView *lsc = self.gtcCurrentSizeClass;

    if (!ssc.wrapContentWidth)
    {
        if (lsc.widthSizeInner.dimeRelaVal.view == newSuperview)
        {
            if (lsc.widthSizeInner.dimeRelaVal.dime == GTCGravityHorzFill)
                size.width = [lsc.widthSizeInner measureWith:rectSuper.size.width];
            else
                size.width = [lsc.widthSizeInner measureWith:rectSuper.size.height];

            size.width = [self gtcValidMeasure:lsc.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
        }

        if (lsc.leadingPosInner.posVal != nil && lsc.trailingPosInner.posVal != nil)
        {
            CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
            CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
            size.width = rectSuper.size.width - leadingMargin - trailingMargin;
            size.width = [self gtcValidMeasure:lsc.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];

        }

        if (size.width < 0)
        {
            size.width = 0;
        }
    }

    if (!ssc.wrapContentHeight)
    {
        if (lsc.heightSizeInner.dimeRelaVal.view == newSuperview)
        {
            if (lsc.heightSizeInner.dimeRelaVal.dime == GTCGravityVertFill)
                size.height = [lsc.heightSizeInner measureWith:rectSuper.size.height];
            else
                size.height = [lsc.heightSizeInner measureWith:rectSuper.size.width];

            size.height = [self gtcValidMeasure:lsc.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];

        }

        if (lsc.topPosInner.posVal != nil && lsc.bottomPosInner.posVal != nil)
        {
            CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
            CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
            size.height = rectSuper.size.height - topMargin - bottomMargin;
            size.height = [self gtcValidMeasure:lsc.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];

        }

        if (size.height < 0)
        {
            size.height = 0;
        }

    }


    return size;
}


-(BOOL)gtcUpdateLayoutRectInNoLayoutSuperview:(UIView*)newSuperview
{
    BOOL isAdjust = NO;

    CGRect rectSuper = newSuperview.bounds;

    UIView *lsc = self.gtcCurrentSizeClass;

    CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
    CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
    CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
    CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
    CGRect rectSelf = self.bounds;

    //得到在设置center后的原始值。
    rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y;
    rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x;
    CGRect oldRectSelf = rectSelf;

    //确定左右边距和宽度。
    if (lsc.widthSizeInner.dimeVal != nil)
    {
        lsc.wrapContentWidth = NO;

        if (lsc.widthSizeInner.dimeRelaVal != nil)
        {
            if (lsc.widthSizeInner.dimeRelaVal.view == newSuperview)
            {
                if (lsc.widthSizeInner.dimeRelaVal.dime == GTCGravityHorzFill)
                    rectSelf.size.width = [lsc.widthSizeInner measureWith:rectSuper.size.width];
                else
                    rectSelf.size.width = [lsc.widthSizeInner measureWith:rectSuper.size.height];

            }
            else
            {
                rectSelf.size.width = [lsc.widthSizeInner measureWith:lsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.width = lsc.widthSizeInner.measure;

    }

    //这里要判断自己的宽度设置了最小和最大宽度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (lsc.widthSizeInner.lBoundValInner.dimeRelaVal.view == newSuperview || lsc.widthSizeInner.uBoundValInner.dimeRelaVal.view == newSuperview)
    {
        isAdjust = YES;
    }

    rectSelf.size.width = [self gtcValidMeasure:lsc.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];

    if ([GTCBaseLayout isRTL])
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;


    if (lsc.leadingPosInner.posVal != nil && lsc.trailingPosInner.posVal != nil)
    {
        isAdjust = YES;
        lsc.wrapContentWidth = NO;
        rectSelf.size.width = rectSuper.size.width - leadingMargin - trailingMargin;
        rectSelf.size.width = [self gtcValidMeasure:lsc.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

            //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
            //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.leadingPosInner.isSafeAreaPos)
            {
                leadingMargin = lsc.leadingPosInner.offsetVal + ([GTCBaseLayout isRTL] ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - ([GTCBaseLayout isRTL] ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left);
            }
        }
#endif

        rectSelf.origin.x = leadingMargin;
    }
    else if (lsc.centerXPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width)/2;
        rectSelf.origin.x += [lsc.centerXPosInner realPosIn:rectSuper.size.width];
    }
    else if (lsc.leadingPosInner.posVal != nil)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

            //iOS11中的滚动条的安全区会叠加到contentInset里面。因此这里要特殊处理，让x轴的开始位置不应该算偏移。
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.leadingPosInner.isSafeAreaPos)
            {
                leadingMargin = lsc.leadingPosInner.offsetVal + ([GTCBaseLayout isRTL] ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - ([GTCBaseLayout isRTL] ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left);
            }
        }
#endif
        rectSelf.origin.x = leadingMargin;
    }
    else if (lsc.trailingPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x  = rectSuper.size.width - rectSelf.size.width - trailingMargin;
    }
    else;


    if (lsc.heightSizeInner.dimeVal != nil)
    {
        lsc.wrapContentHeight = NO;

        if (lsc.heightSizeInner.dimeRelaVal != nil)
        {
            if (lsc.heightSizeInner.dimeRelaVal.view == newSuperview)
            {
                if (lsc.heightSizeInner.dimeRelaVal.dime == GTCGravityVertFill)
                    rectSelf.size.height = [lsc.heightSizeInner measureWith:rectSuper.size.height];
                else
                    rectSelf.size.height = [lsc.heightSizeInner measureWith:rectSuper.size.width];
            }
            else
            {
                rectSelf.size.height = [lsc.heightSizeInner measureWith:lsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.height = lsc.heightSizeInner.measure;
    }

    //这里要判断自己的高度设置了最小和最大高度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (lsc.heightSizeInner.lBoundValInner.dimeRelaVal.view == newSuperview || lsc.heightSizeInner.uBoundValInner.dimeRelaVal.view == newSuperview)
    {
        isAdjust = YES;
    }

    rectSelf.size.height = [self gtcValidMeasure:lsc.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];

    if (lsc.topPosInner.posVal != nil && lsc.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        lsc.wrapContentHeight = NO;
        rectSelf.size.height = rectSuper.size.height - topMargin - bottomMargin;
        rectSelf.size.height = [self gtcValidMeasure:lsc.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

            //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
            //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.topPosInner.isSafeAreaPos)
            {
                topMargin = lsc.topPosInner.offsetVal + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top;
            }
        }
#endif

        rectSelf.origin.y = topMargin;
    }
    else if (lsc.centerYPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height)/2 + [lsc.centerYPosInner realPosIn:rectSuper.size.height];
    }
    else if (lsc.topPosInner.posVal != nil)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

            //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
            //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.topPosInner.isSafeAreaPos)
            {
                topMargin = lsc.topPosInner.offsetVal + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top;
            }
        }
#endif
        rectSelf.origin.y = topMargin;
    }
    else if (lsc.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y  = rectSuper.size.height - rectSelf.size.height - bottomMargin;
    }
    else;

    if ([GTCBaseLayout isRTL])
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;

    rectSelf = _gtcCGRectRound(rectSelf);
    if (!_gtcCGRectEqual(rectSelf, oldRectSelf))
    {
        if (rectSelf.size.width < 0)
        {
            rectSelf.size.width = 0;
        }
        if (rectSelf.size.height < 0)
        {
            rectSelf.size.height = 0;
        }

        if (CGAffineTransformIsIdentity(self.transform))
        {
            self.frame = rectSelf;
        }
        else
        {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,rectSelf.size.width, rectSelf.size.height);
            self.center = CGPointMake(rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.size.width, rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.size.height);
        }
    }
    else if (lsc.wrapContentWidth || lsc.wrapContentHeight)
    {
        [self setNeedsLayout];
    }



    return isAdjust;

}

-(CGFloat)gtcHeightFromFlexedHeightView:(UIView*)sbv sbvsc:(UIView*)sbvsc inWidth:(CGFloat)width
{
    CGFloat h = [sbv sizeThatFits:CGSizeMake(width, 0)].height;
    if ([sbv isKindOfClass:[UIImageView class]])
    {
        //根据图片的尺寸进行等比缩放得到合适的高度。
        UIImage *img = ((UIImageView*)sbv).image;
        if (img != nil && img.size.width != 0)
        {
            h = img.size.height * (width / img.size.width);
        }
    }
    else if ([sbv isKindOfClass:[UIButton class]])
    {
        //按钮特殊处理多行的。。
        UIButton *button = (UIButton*)sbv;

        if (button.titleLabel != nil)
        {
            //得到按钮本身的高度，以及单行文本的高度，这样就能算出按钮和文本的间距
            CGSize buttonSize = [button sizeThatFits:CGSizeMake(0, 0)];
            CGSize buttonTitleSize = [button.titleLabel sizeThatFits:CGSizeMake(0, 0)];
            CGSize sz = [button.titleLabel sizeThatFits:CGSizeMake(width, 0)];
            h = sz.height + buttonSize.height - buttonTitleSize.height; //这个sz只是纯文本的高度，所以要加上原先按钮和文本的高度差。。
        }
    }
    else
        ;

    if (sbvsc.heightSizeInner == nil)
        return h;
    else
        return [sbvsc.heightSizeInner measureWith:h];
}


-(CGFloat)gtcGetBoundLimitMeasure:(GTCLayoutSize*)boundDime sbv:(UIView*)sbv dimeType:(GTCGravity)dimeType sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound
{
    CGFloat value = isUBound ? CGFLOAT_MAX : -CGFLOAT_MAX;
    if (boundDime == nil)
        return value;

    GTCLayoutValueType lValueType = boundDime.dimeValType;
    if (lValueType == GTCLayoutValueTypeNSNumber)
    {
        value = boundDime.dimeNumVal.doubleValue;
    }
    else if (lValueType == GTCLayoutValueTypeLayoutDime)
    {
        if (boundDime.dimeRelaVal.view == self)
        {
            if (boundDime.dimeRelaVal.dime == GTCGravityHorzFill)
                value = selfLayoutSize.width - (boundDime.dimeRelaVal.view == self ? (self.gtcLayoutLeadingPadding + self.gtcLayoutTrailingPadding) : 0);
            else
                value = selfLayoutSize.height - (boundDime.dimeRelaVal.view == self ? (self.gtcLayoutTopPadding + self.gtcLayoutBottomPadding) :0);
        }
        else if (boundDime.dimeRelaVal.view == sbv)
        {
            if (boundDime.dimeRelaVal.dime == dimeType)
            {
                //约束冲突：无效的边界设置方法
                NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
            }
            else
            {
                if (boundDime.dimeRelaVal.dime == GTCGravityHorzFill)
                    value = sbvSize.width;
                else
                    value = sbvSize.height;
            }
        }
        else if (boundDime.dimeSelfVal != nil)
        {
            if (dimeType == GTCGravityHorzFill)
                value = sbvSize.width;
            else
                value = sbvSize.height;
        }
        else
        {
            if (boundDime.dimeRelaVal.dime == GTCGravityHorzFill)
            {
                value = boundDime.dimeRelaVal.view.estimatedRect.size.width;
            }
            else
            {
                value = boundDime.dimeRelaVal.view.estimatedRect.size.height;
            }
        }

    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }

    if (value == CGFLOAT_MAX || value == -CGFLOAT_MAX)
        return value;

    return  [boundDime measureWith:value];

}



-(CGFloat)gtcValidMeasure:(GTCLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize
{
    if (dime == nil)
        return calcSize;

    //算出最大最小值。
    CGFloat min = dime.isActive? [self gtcGetBoundLimitMeasure:dime.lBoundValInner sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:NO] : -CGFLOAT_MAX;
    CGFloat max = dime.isActive ?  [self gtcGetBoundLimitMeasure:dime.uBoundValInner sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:YES] : CGFLOAT_MAX;

    calcSize = _gtcCGFloatMax(min, calcSize);
    calcSize = _gtcCGFloatMin(max, calcSize);

    return calcSize;
}


-(CGFloat)gtcGetBoundLimitMargin:(GTCLayoutPosition*)boundPos sbv:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize
{
    CGFloat value = 0;
    if (boundPos == nil)
        return value;

    GTCLayoutValueType lValueType = boundPos.posValType;
    if (lValueType == GTCLayoutValueTypeNSNumber)
        value = boundPos.posNumVal.doubleValue;
    else if (lValueType == GTCLayoutValueTypeLayoutDime)
    {
        CGRect rect = boundPos.posRelaVal.view.gtcFrame.frame;

        GTCGravity pos = boundPos.posRelaVal.pos;
        if (pos == GTCGravityHorzLeading)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMinX(rect);
        }
        else if (pos == GTCGravityHorzCenter)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMidX(rect);
        }
        else if (pos == GTCGravityHorzTrailing)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMaxX(rect);
        }
        else if (pos == GTCGravityVertTop)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMinY(rect);
        }
        else if (pos == GTCGravityVertCenter)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMidY(rect);
        }
        else if (pos == GTCGravityVertBottom)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMaxY(rect);
        }
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }

    return value + boundPos.offsetVal;
}


-(CGFloat)gtcValidMargin:(GTCLayoutPosition*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize
{
    if (pos == nil)
        return calcPos;

    //算出最大最小值
    CGFloat min = (pos.isActive && pos.lBoundValInner != nil) ? [self gtcGetBoundLimitMargin:pos.lBoundValInner sbv:sbv selfLayoutSize:selfLayoutSize] : -CGFLOAT_MAX;
    CGFloat max = (pos.isActive && pos.uBoundValInner != nil) ? [self gtcGetBoundLimitMargin:pos.uBoundValInner sbv:sbv selfLayoutSize:selfLayoutSize] : CGFLOAT_MAX;

    calcPos = _gtcCGFloatMax(min, calcPos);
    calcPos = _gtcCGFloatMin(max, calcPos);
    return calcPos;
}

-(BOOL)gtcIsNoLayoutSubview:(UIView*)sbv
{
    UIView *sbvsc = sbv.gtcCurrentSizeClass;

    if (sbvsc.useFrame)
        return YES;

    if (sbv.isHidden)
    {
        return sbvsc.gtc_visibility != GTCVisibilityInvisible;
    }
    else
    {
        return sbvsc.gtc_visibility == GTCVisibilityGone;
    }

}

-(NSMutableArray*)gtcGetLayoutSubviews
{
    return [self gtcGetLayoutSubviewsFrom:self.subviews];
}

-(NSMutableArray*)gtcGetLayoutSubviewsFrom:(NSArray*)sbsFrom
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:sbsFrom.count];
    BOOL isReverseLayout = self.reverseLayout;

    if (isReverseLayout)
    {
        [sbs addObjectsFromArray:[sbsFrom reverseObjectEnumerator].allObjects];
    }
    else
    {
        [sbs addObjectsFromArray:sbsFrom];

    }

    for (NSInteger i = sbs.count - 1; i >=0; i--)
    {
        UIView *sbv = sbs[i];
        if ([self gtcIsNoLayoutSubview:sbv])
        {
            [sbs removeObjectAtIndex:i];
        }
    }

    return sbs;

}

-(void)gtcSetSubviewRelativeDimeSize:(GTCLayoutSize*)dime selfSize:(CGSize)selfSize lsc:(GTCBaseLayout*)lsc pRect:(CGRect*)pRect
{
    if (dime.dimeRelaVal == nil)
        return;

    if (dime.dime == GTCGravityHorzFill)
    {

        if (dime.dimeRelaVal == lsc.widthSizeInner && !lsc.wrapContentWidth)
            pRect->size.width = [dime measureWith:(selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding)];
        else if (dime.dimeRelaVal == lsc.heightSizeInner)
            pRect->size.width = [dime measureWith:(selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding)];
        else if (dime.dimeRelaVal == dime.view.heightSizeInner)
            pRect->size.width = [dime measureWith:pRect->size.height];
        else if (dime.dimeRelaVal.dime == GTCGravityHorzFill)
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
    else
    {
        if (dime.dimeRelaVal == lsc.heightSizeInner && !lsc.wrapContentHeight)
            pRect->size.height = [dime measureWith:(selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding)];
        else if (dime.dimeRelaVal == lsc.widthSizeInner)
            pRect->size.height = [dime measureWith:(selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding)];
        else if (dime.dimeRelaVal == dime.view.widthSizeInner)
            pRect->size.height = [dime measureWith:pRect->size.width];
        else if (dime.dimeRelaVal.dime == GTCGravityHorzFill)
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
}

-(CGSize)gtcAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray *)sbs lsc:(GTCBaseLayout*)lsc
{
    //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
    if (sbs.count == 0 && !lsc.zeroPadding)
    {
        if (lsc.wrapContentWidth)
            size.width -= (lsc.gtcLayoutLeadingPadding + lsc.gtcLayoutTrailingPadding);
        if (lsc.wrapContentHeight)
            size.height -= (lsc.gtcLayoutTopPadding + lsc.gtcLayoutBottomPadding);
    }

    return size;
}

- (void)gtcAdjustLayoutSelfSize:(CGSize *)pSelfSize lsc:(GTCBaseLayout*)lsc
{
    //调整自己的尺寸。
    pSelfSize->height = [self gtcValidMeasure:lsc.heightSizeInner sbv:self calcSize:pSelfSize->height sbvSize:*pSelfSize selfLayoutSize:self.superview.bounds.size];

    pSelfSize->width = [self gtcValidMeasure:lsc.widthSizeInner sbv:self calcSize:pSelfSize->width sbvSize:*pSelfSize selfLayoutSize:self.superview.bounds.size];
}

-(void)gtcAdjustSubviewsRTLPos:(NSArray*)sbs selfWidth:(CGFloat)selfWidth
{
    if ([GTCBaseLayout isRTL])
    {
        for (UIView *sbv in sbs)
        {
            GTCFrame *gtcFrame = sbv.gtcFrame;

            gtcFrame.leading = selfWidth - gtcFrame.leading - gtcFrame.width;
            gtcFrame.trailing = gtcFrame.leading + gtcFrame.width;

        }
    }
}


-(void)gtcAdjustSubviewsLayoutTransform:(NSArray*)sbs lsc:(GTCBaseLayout*)lsc selfWidth:(CGFloat)selfWidth selfHeight:(CGFloat)selfHeight
{
    CGAffineTransform layoutTransform = lsc.layoutTransform;
    if (!CGAffineTransformIsIdentity(layoutTransform))
    {
        for (UIView *sbv in sbs)
        {
            GTCFrame *gtcFrame = sbv.gtcFrame;

            //取子视图中心点坐标。因为这个坐标系的原点是布局视图的左上角，所以要转化为数学坐标系的原点坐标, 才能应用坐标变换。
            CGPoint centerPoint = CGPointMake(gtcFrame.leading + gtcFrame.width / 2 - selfWidth / 2,
                                              gtcFrame.top + gtcFrame.height / 2 - selfHeight / 2);

            //应用坐标变换
            centerPoint = CGPointApplyAffineTransform(centerPoint, layoutTransform);

            //还原为左上角坐标系。
            centerPoint.x +=  selfWidth / 2;
            centerPoint.y += selfHeight / 2;

            //根据中心点的变化调整开始和结束位置。
            gtcFrame.leading = centerPoint.x - gtcFrame.width / 2;
            gtcFrame.trailing = gtcFrame.leading + gtcFrame.width;
            gtcFrame.top = centerPoint.y - gtcFrame.height / 2;
            gtcFrame.bottom = gtcFrame.top + gtcFrame.height;
        }
    }
}

-(GTCGravity)gtcConvertLeftRightGravityToLeadingTrailing:(GTCGravity)horzGravity
{
    if (horzGravity == GTCGravityHorzLeft)
    {
        if ([GTCBaseLayout isRTL])
            return GTCGravityHorzTrailing;
        else
            return GTCGravityHorzLeading;
    }
    else if (horzGravity == GTCGravityHorzRight)
    {
        if ([GTCBaseLayout isRTL])
            return GTCGravityHorzLeading;
        else
            return GTCGravityHorzTrailing;
    }
    else
        return horzGravity;

}

-(UIFont*)gtcGetSubviewFont:(UIView*)sbv
{
    UIFont *sbvFont = nil;
    if ([sbv isKindOfClass:[UILabel class]] ||
        [sbv isKindOfClass:[UITextField class]] ||
        [sbv isKindOfClass:[UITextView class]] ||
        [sbv isKindOfClass:[UIButton class]])
    {
        sbvFont = [sbv valueForKey:@"font"];
    }

    return sbvFont;
}

-(CGFloat)gtcLayoutTopPadding
{
    return self.gtcCurrentSizeClass.gtcLayoutTopPadding;
}
-(CGFloat)gtcLayoutBottomPadding
{
    return self.gtcCurrentSizeClass.gtcLayoutBottomPadding;
}
-(CGFloat)gtcLayoutLeftPadding
{
    return self.gtcCurrentSizeClass.gtcLayoutLeftPadding;
}
-(CGFloat)gtcLayoutRightPadding
{
    return self.gtcCurrentSizeClass.gtcLayoutRightPadding;
}
-(CGFloat)gtcLayoutLeadingPadding
{
    return self.gtcCurrentSizeClass.gtcLayoutLeadingPadding;
}
-(CGFloat)gtcLayoutTrailingPadding
{
    return self.gtcCurrentSizeClass.gtcLayoutTrailingPadding;
}


- (void)gtcAlterScrollViewContentSize:(CGSize)newSize lsc:(GTCBaseLayout*)lsc
{
    if (self.adjustScrollViewContentSizeMode == GTCAdjustScrollViewContentSizeModeYes && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGSize contsize = scrolv.contentSize;
        CGRect rectSuper = scrolv.bounds;

        //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
        CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
        CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
        CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
        CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            if (/*scrolv.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentAlways*/ 1)
            {
                if (lsc.leadingPosInner.isSafeAreaPos)
                    leadingMargin = lsc.leadingPosInner.offsetVal;// + scrolv.safeAreaInsets.left - scrolv.adjustedContentInset.left;

                if (lsc.trailingPosInner.isSafeAreaPos)
                    trailingMargin = lsc.trailingPosInner.offsetVal;// + scrolv.safeAreaInsets.right - scrolv.adjustedContentInset.right;

                if (lsc.topPosInner.isSafeAreaPos)
                    topMargin = lsc.topPosInner.offsetVal;

                if (lsc.bottomPosInner.isSafeAreaPos)
                    bottomMargin = lsc.bottomPosInner.offsetVal;
            }
        }
#endif



        if (contsize.height != newSize.height + topMargin + bottomMargin)
            contsize.height = newSize.height + topMargin + bottomMargin;
        if (contsize.width != newSize.width + leadingMargin + trailingMargin)
            contsize.width = newSize.width + leadingMargin + trailingMargin;

        //因为调整contentsize可能会调整contentOffset，所以为了保持一致性这里要还原掉原来的contentOffset
        CGPoint oldOffset = scrolv.contentOffset;
        if (!CGSizeEqualToSize(scrolv.contentSize, contsize))
            scrolv.contentSize =  contsize;

        if ((oldOffset.x <= 0 || oldOffset.x <= contsize.width - rectSuper.size.width) &&
            (oldOffset.y <= 0 || oldOffset.y <= contsize.height - rectSuper.size.height))
        {
            if (!CGPointEqualToPoint(scrolv.contentOffset, oldOffset))
            {
                scrolv.contentOffset = oldOffset;
            }
        }
    }
}

GTCSizeClass _gtcGlobalSizeClass = 0xFF;

//获取全局的当前的SizeClass,减少获取次数的调用。
-(GTCSizeClass)gtcGetGlobalSizeClass
{
    //找到最根部的父视图。
    if (_gtcGlobalSizeClass == 0xFF || ![self.superview isKindOfClass:[GTCBaseLayout class]])
    {
        GTCSizeClass sizeClass;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8)
            sizeClass = GTCSizeClasshAny | GTCSizeClasswAny;
        else
            sizeClass = (GTCSizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
#if TARGET_OS_IOS
        UIDeviceOrientation ori =   [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsPortrait(ori))
        {
            sizeClass |= GTCSizeClassPortrait;
        }
        else if (UIDeviceOrientationIsLandscape(ori))
        {
            sizeClass |= GTCSizeClassLandscape;
        }
        //如果 ori == UIDeviceOrientationUnknown 的话, 默认给竖屏设置
        else {
            sizeClass |= GTCSizeClassPortrait;
        };
#endif
        _gtcGlobalSizeClass = sizeClass;
    }
    else
    {
        ;
    }

    return _gtcGlobalSizeClass;
}

-(void)gtcRemoveSubviewObserver:(UIView*)subview
{

    GTCFrame *sbvFrame = objc_getAssociatedObject(subview, ASSOCIATEDOBJECT_KEY_GTLAYOUT_FRAME);
    if (sbvFrame != nil)
    {
        sbvFrame.sizeClass.viewLayoutCompleteBlock = nil;
        if (sbvFrame.hasObserver)
        {
            [subview removeObserver:self forKeyPath:@"hidden"];
            [subview removeObserver:self forKeyPath:@"frame"];

            //有时候我们可能会把滚动视图加入到布局视图中去，滚动视图的尺寸有可能设置为wrapContent,这样就会调整center。从而需要重新激发滚动视图的布局
            //这也就是为什么只监听center的原因了。布局子视图也是如此。
            if ([subview isKindOfClass:[GTCBaseLayout class]] || [subview isKindOfClass:[UIScrollView class]])
            {
                [subview removeObserver:self forKeyPath:@"center"];
            }
            else if ([subview isKindOfClass:[UILabel class]])
            {
                [subview removeObserver:self forKeyPath:@"text"];
                [subview removeObserver:self forKeyPath:@"attributedText"];
            }
            else;

            sbvFrame.hasObserver = NO;
        }
    }
}

-(void)gtcAddSubviewObserver:(UIView*)subview sbvFrame:(GTCFrame*)sbvFrame
{

    if (!sbvFrame.hasObserver)
    {
        //添加hidden, frame,center的属性通知。
        [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:_gtcObserverContextA];
        [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_gtcObserverContextA];
        if ([subview isKindOfClass:[GTCBaseLayout class]] || [subview isKindOfClass:[UIScrollView class]])
        {
            [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:_gtcObserverContextA];
        }
        else if ([subview isKindOfClass:[UILabel class]])
        {//如果是UILabel则一旦设置了text和attributedText则

            [subview addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:_gtcObserverContextB];
            [subview addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:_gtcObserverContextB];
        }
        else;

        sbvFrame.hasObserver = YES;

    }
}


-(void)gtcAdjustSubviewWrapContentSet:(UIView*)sbv isEstimate:(BOOL)isEstimate sbvFrame:(GTCFrame*)sbvFrame sbvsc:(UIView*)sbvsc selfSize:(CGSize)selfSize sizeClass:(GTCSizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout
{
    if (!isEstimate)
    {
        sbvFrame.frame = sbv.bounds;
        [self gtcCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvFrame:sbvFrame];
    }

    if ([sbv isKindOfClass:[GTCBaseLayout class]])
    {

        if (sbvsc.wrapContentHeight && (sbvsc.heightSizeInner.dimeVal != nil || (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)))
        {
            sbvsc.wrapContentHeight = NO;
        }

        if (sbvsc.wrapContentWidth && (sbvsc.widthSizeInner.dimeVal != nil || (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)))
        {
            sbvsc.wrapContentWidth = NO;
        }


        if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
            *pHasSubLayout = YES;

        if (isEstimate && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
        {
            [(GTCBaseLayout*)sbv sizeThatFits:sbvFrame.frame.size inSizeClass:sizeClass];
            if (sbvFrame.multiple)
            {
                sbvFrame.sizeClass = [sbv gtcBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
    }

}



-(void)gtcCalcSubViewRect:(UIView*)sbv
                   sbvsc:(UIView*)sbvsc
              sbvFrame:(GTCFrame*)sbvFrame
                     lsc:(GTCBaseLayout*)lsc
             vertGravity:(GTCGravity)vertGravity
             horzGravity:(GTCGravity)horzGravity
              inSelfSize:(CGSize)selfSize
              paddingTop:(CGFloat)paddingTop
          paddingLeading:(CGFloat)paddingLeading
           paddingBottom:(CGFloat)paddingBottom
         paddingTrailing:(CGFloat)paddingTrailing
            pMaxWrapSize:(CGSize*)pMaxWrapSize
{


    CGRect rect = sbvFrame.frame;

    if (sbvsc.widthSizeInner.dimeNumVal != nil)
    {//宽度等于固定的值。

        rect.size.width = sbvsc.widthSizeInner.measure;
    }
    else if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal.view != sbv)
    {//宽度等于其他的依赖的视图。

        if (sbvsc.widthSizeInner.dimeRelaVal == self.widthSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:selfSize.width - paddingLeading - paddingTrailing];
        else if (sbvsc.widthSizeInner.dimeRelaVal == self.heightSizeInner)
        {
            rect.size.width = [sbvsc.widthSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
        }
        else
            rect.size.width = [sbvsc.widthSizeInner measureWith:sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
    }

    rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
    [self gtcCalcHorzGravity:[self gtcGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:&rect];



    if (sbvsc.heightSizeInner.dimeNumVal != nil)
    {//高度等于固定的值。
        rect.size.height = sbvsc.heightSizeInner.measure;
    }
    else if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal.view != sbv)
    {//高度等于其他依赖的视图
        if (sbvsc.heightSizeInner.dimeRelaVal == self.heightSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
        else if (sbvsc.heightSizeInner.dimeRelaVal == self.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.width - paddingLeading - paddingTrailing];
        else
            rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
    }

    if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]])
    {//高度等于内容的高度
        rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
    }

    rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
    [self gtcCalcVertGravity:[self gtcGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom baselinePos:CGFLOAT_MAX selfSize:selfSize pRect:&rect];


    //特殊处理宽度等于高度
    if (sbvsc.widthSizeInner.dimeRelaVal.view == sbv && sbvsc.widthSizeInner.dimeRelaVal.dime == GTCGravityVertFill)
    {
        rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];

        [self gtcCalcHorzGravity:[self gtcGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:&rect];
    }

    //特殊处理高度等于宽度。
    if (sbvsc.heightSizeInner.dimeRelaVal.view == sbv && sbvsc.heightSizeInner.dimeRelaVal.dime == GTCGravityHorzFill)
    {
        rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];

        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]])
        {
            rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }

        rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

        [self gtcCalcVertGravity:[self gtcGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom baselinePos:CGFLOAT_MAX selfSize:selfSize pRect:&rect];

    }

    sbvFrame.frame = rect;

    if (pMaxWrapSize != NULL)
    {
        if (lsc.wrapContentWidth)
        {
            //如果同时设置左右边界则左右边界为最小的宽度
            if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
            {
                if (_gtcCGFloatLess(pMaxWrapSize->width, sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing))
                    pMaxWrapSize->width = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing;
            }

            //宽度不依赖布局并且没有同时设置左右边距则参与最大宽度计算。
            if ((sbvsc.widthSizeInner.dimeRelaVal.view != self) &&
                (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil))
            {

                if (_gtcCGFloatLess(pMaxWrapSize->width, sbvFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.centerXPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing))
                    pMaxWrapSize->width = sbvFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.centerXPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing;

                if (_gtcCGFloatLess(pMaxWrapSize->width,sbvFrame.trailing + sbvsc.trailingPosInner.absVal + paddingTrailing))
                    pMaxWrapSize->width = sbvFrame.trailing + sbvsc.trailingPosInner.absVal + paddingTrailing;

            }
        }

        if (lsc.wrapContentHeight)
        {
            //如果同时设置上下边界则上下边界为最小的高度
            if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
            {
                if (_gtcCGFloatLess(pMaxWrapSize->height, sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom))
                    pMaxWrapSize->height = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom;
            }

            //高度不依赖布局并且没有同时设置上下边距则参与最大高度计算。
            if ((sbvsc.heightSizeInner.dimeRelaVal.view != self) &&
                (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
            {
                if (_gtcCGFloatLess(pMaxWrapSize->height, sbvFrame.height + sbvsc.topPosInner.absVal + sbvsc.centerYPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom))
                    pMaxWrapSize->height = sbvFrame.height + sbvsc.topPosInner.absVal + sbvsc.centerYPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom;

                if (_gtcCGFloatLess(pMaxWrapSize->height, sbvFrame.bottom + sbvsc.bottomPosInner.absVal + paddingBottom))
                    pMaxWrapSize->height = sbvFrame.bottom + sbvsc.bottomPosInner.absVal + paddingBottom;
            }
        }
    }


}

-(void)gtcHookSublayout:(GTCBaseLayout *)sublayout borderlineRect:(CGRect *)pRect
{
    //do nothing...
}


@end


@implementation GTCFrame

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _leading = CGFLOAT_MAX;
        _trailing = CGFLOAT_MAX;
        _top = CGFLOAT_MAX;
        _bottom = CGFLOAT_MAX;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
    }

    return self;
}

-(void)reset
{
    _leading = CGFLOAT_MAX;
    _trailing = CGFLOAT_MAX;
    _top = CGFLOAT_MAX;
    _bottom = CGFLOAT_MAX;
    _width = CGFLOAT_MAX;
    _height = CGFLOAT_MAX;
}


-(CGRect)frame
{
    return CGRectMake(_leading, _top,_width, _height);
}

-(void)setFrame:(CGRect)frame
{
    _leading = frame.origin.x;
    _top = frame.origin.y;
    _width  = frame.size.width;
    _height = frame.size.height;
    _trailing = _leading + _width;
    _bottom = _top + _height;
}

-(BOOL)multiple
{
    return self.sizeClasses.count > 1;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"leading:%g, top:%g, width:%g, height:%g, trailing:%g, bottom:%g",_leading,_top,_width,_height,_trailing,_bottom];
}

@end


