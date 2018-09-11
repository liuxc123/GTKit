//
//  GTCRelativeLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/11.
//

#import "GTCRelativeLayout.h"
#import "GTCLayoutInner.h"

@implementation GTCRelativeLayout



#pragma mark -- Override Methods

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTCSizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];

    GTCRelativeLayout *lsc = self.gtcCurrentSizeClass;


    for (UIView *sbv in self.subviews)
    {
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (sbvsc.useFrame)
            continue;

        if (!isEstimate || (pHasSubLayout != nil && (*pHasSubLayout) == YES))
            [sbvFrame reset];


        if ([sbv isKindOfClass:[GTCBaseLayout class]])
        {

            if (sbvsc.wrapContentWidth)
            {
                //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                if ((sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil) || sbvsc.widthSizeInner.dimeVal != nil)
                    sbvsc.wrapContentWidth = NO;
            }

            if (sbvsc.wrapContentHeight)
            {
                if ((sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil) || sbvsc.heightSizeInner.dimeVal != nil)
                    sbvsc.wrapContentHeight = NO;
            }

            if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
                *pHasSubLayout = YES;

            if (isEstimate && (sbvsc.wrapContentWidth || sbvsc.wrapContentHeight))
            {
                [(GTCBaseLayout*)sbv sizeThatFits:sbvFrame.frame.size inSizeClass:sizeClass];

                sbvFrame.leading = sbvFrame.trailing = sbvFrame.top = sbvFrame.bottom = CGFLOAT_MAX;

                if (sbvFrame.multiple)
                {
                    sbvFrame.sizeClass = [sbv gtcBestSizeClass:sizeClass]; //因为sizeThatFits执行后会还原，所以这里要重新设置
                }
            }
        }
    }


    BOOL reCalc = NO;
    CGSize maxSize = [self gtcCalcLayout:&reCalc lsc:lsc selfSize:selfSize];

    if (lsc.wrapContentWidth || lsc.wrapContentHeight)
    {
        if (_gtcCGFloatNotEqual(selfSize.height, maxSize.height)  || _gtcCGFloatNotEqual(selfSize.width, maxSize.width))
        {

            if (lsc.wrapContentWidth)
            {
                selfSize.width = maxSize.width;
            }

            if (lsc.wrapContentHeight)
            {
                selfSize.height = maxSize.height;
            }

            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    GTCFrame *sbvFrame = sbv.gtcFrame;
                    //如果是布局视图则不清除尺寸，其他清除。
                    if (isEstimate  && [sbv isKindOfClass:[GTCBaseLayout class]])
                    {
                        sbvFrame.leading = sbvFrame.trailing = sbvFrame.top = sbvFrame.bottom = CGFLOAT_MAX;
                    }
                    else
                        [sbvFrame reset];
                }

                [self gtcCalcLayout:NULL lsc:lsc selfSize:selfSize];
            }
        }

    }


    //调整布局视图自己的尺寸。
    [self gtcAdjustLayoutSelfSize:&selfSize lsc:lsc];

    //如果是反向则调整所有子视图的左右位置。
    NSArray *sbs2 = [self gtcGetLayoutSubviews];

    //对所有子视图进行布局变换
    [self gtcAdjustSubviewsLayoutTransform:sbs2 lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtcAdjustSubviewsRTLPos:sbs2 selfWidth:selfSize.width];

    return [self gtcAdjustSizeWhenNoSubviews:selfSize sbs:sbs2 lsc:lsc];

}

-(id)createSizeClassInstance
{
    return [GTCRelativeLayoutViewSizeClass new];
}



#pragma mark -- Private Method
-(void)gtcCalcSubViewLeadingTrailing:(UIView*)sbv
                              sbvsc:(UIView*)sbvsc
                                lsc:(GTCRelativeLayout*)lsc
                         sbvFrame:(GTCFrame*)sbvFrame
                           selfSize:(CGSize)selfSize
{


    //确定宽度，如果跟父一样宽则设置宽度和设置左右值，这时候三个参数设置完毕
    //如果和其他视图的宽度一样，则先计算其他视图的宽度并返回其他视图的宽度
    //如果没有指定宽度
    //检测左右设置。
    //如果设置了左右值则计算左右值。然后再计算宽度为两者之间的差
    //如果没有设置则宽度为width

    //检测是否有centerX，如果设置了centerX的值为父视图则左右值都设置OK，这时候三个参数完毕
    //如果不是父视图则计算其他视图的centerX的值。并返回位置，根据宽度设置后，三个参数完毕。

    //如果没有设置则计算左边的位置。

    //如果设置了左边，计算左边的值， 右边的值确定。

    //如果设置右边，则计算右边的值，左边的值确定。

    //如果都没有设置则，左边为左边距，右边为左边+宽度。

    //左右和宽度设置完毕。



    if (sbvFrame.leading != CGFLOAT_MAX && sbvFrame.trailing != CGFLOAT_MAX && sbvFrame.width != CGFLOAT_MAX)
        return;


    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self gtcCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize])
        return;


    if (sbvsc.centerXPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerXPosInner.posRelaVal.view;

        sbvFrame.leading = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.centerXPosInner.posRelaVal.pos selfSize:selfSize] - sbvFrame.width / 2 +  sbvsc.centerXPosInner.absVal;

        if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
        {
            sbvFrame.leading -= sbvsc.centerXPosInner.absVal;
        }

        if (sbvFrame.leading < 0 && relaView == self && lsc.wrapContentWidth)
            sbvFrame.leading = 0;

        sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
    }
    else if (sbvsc.centerXPosInner.posNumVal != nil)
    {
        sbvFrame.leading = (selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding - sbvFrame.width) / 2 + lsc.gtcLayoutLeadingPadding + sbvsc.centerXPosInner.absVal;

        if (sbvFrame.leading < 0 && lsc.wrapContentWidth)
            sbvFrame.leading = 0;

        sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
    }
    else
    {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (sbvsc.leadingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.leadingPosInner.posRelaVal.view;

            sbvFrame.leading = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;

            if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
            {
                sbvFrame.leading -= sbvsc.leadingPosInner.absVal;
            }

            sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
        }
        else if (sbvsc.leadingPosInner.posNumVal != nil)
        {
            sbvFrame.leading = sbvsc.leadingPosInner.absVal + lsc.gtcLayoutLeadingPadding;
            sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
        }
        else if (sbvsc.trailingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.trailingPosInner.posRelaVal.view;


            sbvFrame.trailing = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;

            if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
            {
                sbvFrame.trailing += sbvsc.trailingPosInner.absVal;
            }

            sbvFrame.leading = sbvFrame.trailing - sbvFrame.width;

        }
        else if (sbvsc.trailingPosInner.posNumVal != nil)
        {
            sbvFrame.trailing = selfSize.width -  lsc.gtcLayoutTrailingPadding -  sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            sbvFrame.leading = sbvFrame.trailing - sbvFrame.width;
        }
        else
        {

            sbvFrame.leading = sbvsc.leadingPosInner.absVal + lsc.gtcLayoutLeadingPadding;
            sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
        }

    }

    //这里要更新左边最小和右边最大约束的情况。
    GTCLayoutPosition *lBoundPos = sbvsc.leadingPosInner.lBoundValInner;
    GTCLayoutPosition *uBoundPos = sbvsc.trailingPosInner.uBoundValInner;

    if (lBoundPos.posRelaVal != nil && uBoundPos.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minLeading = [self gtcCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;

        CGFloat  maxTrailing = [self gtcCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] - uBoundPos.offsetVal;

        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        CGFloat intervalWidth = maxTrailing - minLeading;
        if (_gtcCGFloatLess(intervalWidth, sbvFrame.width))
        {
            sbvFrame.width = intervalWidth;
            sbvFrame.leading = minLeading;
        }
        else
        {
            sbvFrame.leading = (intervalWidth - sbvFrame.width) / 2 + minLeading;
        }

        sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;


    }
    else if (lBoundPos.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minLeading = [self gtcCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;


        if (_gtcCGFloatLess(sbvFrame.leading, minLeading))
        {
            sbvFrame.leading = minLeading;
            sbvFrame.width = sbvFrame.trailing - sbvFrame.leading;
        }
    }
    else if (uBoundPos.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxTrailing = [self gtcCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] -  uBoundPos.offsetVal;

        if (_gtcCGFloatGreat(sbvFrame.trailing, maxTrailing))
        {
            sbvFrame.trailing = maxTrailing;
            sbvFrame.width = sbvFrame.trailing - sbvFrame.leading;
        }
    }


}

-(void)gtcCalcSubViewTopBottom:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(GTCRelativeLayout*)lsc sbvFrame:(GTCFrame*)sbvFrame selfSize:(CGSize)selfSize
{


    if (sbvFrame.top != CGFLOAT_MAX && sbvFrame.bottom != CGFLOAT_MAX && sbvFrame.height != CGFLOAT_MAX)
        return;


    //先检测高度,如果高度是父亲的高度则高度和上下都确定
    if ([self gtcCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize])
        return;

    if (sbvsc.baselinePosInner.posRelaVal != nil)
    {
        //得到基线的位置。基线的位置等于top + (子视图的高度 - 字体的高度) / 2 + 字体基线以上的高度。
        UIFont *sbvFont = [self gtcGetSubviewFont:sbv];

        if (sbvFont != nil)
        {
            //得到基线的位置。
            UIView *relaView = sbvsc.baselinePosInner.posRelaVal.view;
            sbvFrame.top = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.baselinePosInner.posRelaVal.pos selfSize:selfSize] - sbvFont.ascender - (sbvFrame.height - sbvFont.lineHeight) / 2 + sbvsc.baselinePosInner.absVal;

            if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
            {
                sbvFrame.top -= sbvsc.baselinePosInner.absVal;
            }
        }
        else
        {
            sbvFrame.top =  lsc.topPadding + sbvsc.baselinePosInner.absVal;
        }

        sbvFrame.bottom = sbvFrame.top + sbvFrame.height;

    }
    else if (sbvsc.baselinePosInner.posNumVal != nil)
    {
        UIFont *sbvFont = [self gtcGetSubviewFont:sbv];

        if (sbvFont != nil)
        {
            //根据基线位置反退顶部位置。
            sbvFrame.top = lsc.topPadding + sbvsc.baselinePosInner.absVal - sbvFont.ascender - (sbvFrame.height - sbvFont.lineHeight) / 2;
        }
        else
        {
            sbvFrame.top = lsc.topPadding + sbvsc.baselinePosInner.absVal;
        }

        sbvFrame.bottom = sbvFrame.top + sbvFrame.height;

    }
    else if (sbvsc.centerYPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerYPosInner.posRelaVal.view;

        sbvFrame.top = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.centerYPosInner.posRelaVal.pos selfSize:selfSize] - sbvFrame.height / 2 + sbvsc.centerYPosInner.absVal;


        if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
        {
            sbvFrame.top -= sbvsc.centerYPosInner.absVal;
        }

        if (sbvFrame.top < 0 && relaView == self && lsc.wrapContentHeight)
            sbvFrame.top = 0;

        sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
    }
    else if (sbvsc.centerYPosInner.posNumVal != nil)
    {
        sbvFrame.top = (selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding -  sbvFrame.height) / 2 + lsc.gtcLayoutTopPadding + sbvsc.centerYPosInner.absVal;

        if (sbvFrame.top < 0 && lsc.wrapContentHeight)
            sbvFrame.top = 0;

        sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
    }
    else
    {
        if (sbvsc.topPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.topPosInner.posRelaVal.view;

            sbvFrame.top = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;

            if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
            {
                sbvFrame.top -= sbvsc.topPosInner.absVal;
            }

            sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
        }
        else if (sbvsc.topPosInner.posNumVal != nil)
        {
            sbvFrame.top = sbvsc.topPosInner.absVal + lsc.gtcLayoutTopPadding;
            sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
        }
        else if (sbvsc.bottomPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.bottomPosInner.posRelaVal.view;

            sbvFrame.bottom = [self gtcCalcSubView:relaView lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;

            if (relaView != nil && relaView != self && [self gtcIsNoLayoutSubview:relaView])
            {
                sbvFrame.bottom += sbvsc.bottomPosInner.absVal;
            }

            sbvFrame.top = sbvFrame.bottom - sbvFrame.height;

        }
        else if (sbvsc.bottomPosInner.posNumVal != nil)
        {
            if (selfSize.height == 0 && lsc.wrapContentHeight)
            {
                sbvFrame.top = lsc.gtcLayoutTopPadding;
                sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
            }
            else
            {

                sbvFrame.bottom = selfSize.height -  sbvsc.bottomPosInner.absVal - lsc.gtcLayoutBottomPadding + sbvsc.topPosInner.absVal;
                sbvFrame.top = sbvFrame.bottom - sbvFrame.height;
            }
        }
        else
        {
            sbvFrame.top = sbvsc.topPosInner.absVal + lsc.gtcLayoutTopPadding;
            sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
        }
    }

    //这里要更新上边最小和下边最大约束的情况。
    if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil && sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self gtcCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;

        CGFloat   maxBottom = [self gtcCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;

        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (_gtcCGFloatLess(maxBottom - minTop, sbvFrame.height))
        {
            sbvFrame.height = maxBottom - minTop;
            sbvFrame.top = minTop;
        }
        else
        {
            sbvFrame.top = (maxBottom - minTop - sbvFrame.height) / 2 + minTop;
        }

        sbvFrame.bottom = sbvFrame.top + sbvFrame.height;


    }
    else if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self gtcCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;

        if (_gtcCGFloatLess(sbvFrame.top, minTop))
        {
            sbvFrame.top = minTop;
            sbvFrame.height = sbvFrame.bottom - sbvFrame.top;
        }

    }
    else if (sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self gtcCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        if (_gtcCGFloatGreat(sbvFrame.bottom, maxBottom))
        {
            sbvFrame.bottom = maxBottom;
            sbvFrame.height = sbvFrame.bottom - sbvFrame.top;
        }

    }


}



-(CGFloat)gtcCalcSubView:(UIView*)sbv lsc:(GTCRelativeLayout*)lsc gravity:(GTCGravity)gravity selfSize:(CGSize)selfSize
{
    GTCFrame *sbvFrame = sbv.gtcFrame;
    UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

    switch (gravity) {
        case GTCGravityHorzLeading:
        {
            if (sbv == self || sbv == nil)
                return lsc.gtcLayoutLeadingPadding;


            if (sbvFrame.leading != CGFLOAT_MAX)
                return sbvFrame.leading;

            [self gtcCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.leading;

        }
            break;
        case GTCGravityHorzTrailing:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.gtcLayoutTrailingPadding;

            if (sbvFrame.trailing != CGFLOAT_MAX)
                return sbvFrame.trailing;

            [self gtcCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.trailing;

        }
            break;
        case GTCGravityVertTop:
        {
            if (sbv == self || sbv == nil)
                return lsc.gtcLayoutTopPadding;


            if (sbvFrame.top != CGFLOAT_MAX)
                return sbvFrame.top;

            [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.top;

        }
            break;
        case GTCGravityVertBottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.gtcLayoutBottomPadding;


            if (sbvFrame.bottom != CGFLOAT_MAX)
                return sbvFrame.bottom;

            [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.bottom;
        }
            break;
        case GTCGravityVertBaseline:
        {
            if (sbv == self || sbv == nil)
                return lsc.topPadding;

            UIFont *sbvFont = [self gtcGetSubviewFont:sbv];
            if (sbvFont != nil)
            {
                if (sbvFrame.top == CGFLOAT_MAX || sbvFrame.height == CGFLOAT_MAX)
                    [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

                //得到基线的位置。
                return sbvFrame.top + (sbvFrame.height - sbvFont.lineHeight)/2.0 + sbvFont.ascender;

            }
            else
            {
                if (sbvFrame.top != CGFLOAT_MAX)
                    return sbvFrame.top;

                [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

                return sbvFrame.top;
            }

        }
            break;
        case GTCGravityHorzFill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding;


            if (sbvFrame.width != CGFLOAT_MAX)
                return sbvFrame.width;

            [self gtcCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.width;

        }
            break;
        case GTCGravityVertFill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding;


            if (sbvFrame.height != CGFLOAT_MAX)
                return sbvFrame.height;

            [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.height;
        }
            break;
        case GTCGravityHorzCenter:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding) / 2 + lsc.gtcLayoutLeadingPadding;

            if (sbvFrame.leading != CGFLOAT_MAX && sbvFrame.trailing != CGFLOAT_MAX &&  sbvFrame.width != CGFLOAT_MAX)
                return sbvFrame.leading + sbvFrame.width / 2;

            [self gtcCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.leading + sbvFrame.width / 2;

        }
            break;

        case GTCGravityVertCenter:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding) / 2 + lsc.gtcLayoutTopPadding;

            if (sbvFrame.top != CGFLOAT_MAX && sbvFrame.bottom != CGFLOAT_MAX &&  sbvFrame.height != CGFLOAT_MAX)
                return sbvFrame.top + sbvFrame.height / 2;

            [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

            return sbvFrame.top + sbvFrame.height / 2;
        }
            break;
        default:
            break;
    }

    return 0;
}


-(BOOL)gtcCalcWidth:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(GTCRelativeLayout*)lsc sbvFrame:(GTCFrame*)sbvFrame selfSize:(CGSize)selfSize
{

    if (sbvFrame.width == CGFLOAT_MAX)
    {

        if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {

            sbvFrame.width = [sbvsc.widthSizeInner measureWith:[self gtcCalcSubView:sbvsc.widthSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.widthSizeInner.dimeRelaVal.dime selfSize:selfSize] ];

            sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvFrame.width sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

        }
        else if (sbvsc.widthSizeInner.dimeNumVal != nil)
        {
            sbvFrame.width = sbvsc.widthSizeInner.measure;
            sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvFrame.width sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

        }
        else;

        if ([self gtcIsNoLayoutSubview:sbv])
        {
            sbvFrame.width = 0;
        }

        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            if (sbvsc.leadingPosInner.posRelaVal != nil)
                sbvFrame.leading = [self gtcCalcSubView:sbvsc.leadingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            else
                sbvFrame.leading = sbvsc.leadingPosInner.absVal + lsc.gtcLayoutLeadingPadding;

            if (sbvsc.trailingPosInner.posRelaVal != nil)
                sbvFrame.trailing = [self gtcCalcSubView:sbvsc.trailingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal;
            else
                sbvFrame.trailing = selfSize.width - sbvsc.trailingPosInner.absVal - lsc.gtcLayoutTrailingPadding;

            sbvFrame.width = sbvFrame.trailing - sbvFrame.leading;
            sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvFrame.width sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

            if ([self gtcIsNoLayoutSubview:sbv])
            {
                sbvFrame.width = 0;
                sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
            }


            return YES;

        }


        if (sbvFrame.width == CGFLOAT_MAX)
        {
            sbvFrame.width = CGRectGetWidth(sbv.bounds);
            sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvFrame.width sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
        }
    }

    if ((sbvsc.widthSizeInner.lBoundValInner != nil && sbvsc.widthSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.widthSizeInner.uBoundValInner != nil && sbvsc.widthSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX) )
    {
        sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvFrame.width sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
    }


    return NO;
}


-(BOOL)gtcCalcHeight:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(GTCRelativeLayout*)lsc sbvFrame:(GTCFrame*)sbvFrame selfSize:(CGSize)selfSize
{

    if (sbvFrame.height == CGFLOAT_MAX)
    {
        if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {

            sbvFrame.height = [sbvsc.heightSizeInner measureWith:[self gtcCalcSubView:sbvsc.heightSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.heightSizeInner.dimeRelaVal.dime selfSize:selfSize] ];

            sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

        }
        else if (sbvsc.heightSizeInner.dimeNumVal != nil)
        {
            sbvFrame.height = sbvsc.heightSizeInner.measure;
            sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

        }
        else;

        if ([self gtcIsNoLayoutSubview:sbv])
        {
            sbvFrame.height = 0;
        }


        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            if (sbvsc.topPosInner.posRelaVal != nil)
                sbvFrame.top = [self gtcCalcSubView:sbvsc.topPosInner.posRelaVal.view lsc:lsc  gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            else
                sbvFrame.top = sbvsc.topPosInner.absVal + lsc.gtcLayoutTopPadding;

            if (sbvsc.bottomPosInner.posRelaVal != nil)
                sbvFrame.bottom = [self gtcCalcSubView:sbvsc.bottomPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal;
            else
                sbvFrame.bottom = selfSize.height - sbvsc.bottomPosInner.absVal - lsc.gtcLayoutBottomPadding;

            sbvFrame.height = sbvFrame.bottom - sbvFrame.top;
            sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

            if ([self gtcIsNoLayoutSubview:sbv])
            {
                sbvFrame.height = 0;
                sbvFrame.bottom = sbvFrame.top + sbvFrame.height;
            }


            return YES;

        }


        if (sbvFrame.height == CGFLOAT_MAX)
        {
            sbvFrame.height = CGRectGetHeight(sbv.bounds);

            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]] && ![self gtcIsNoLayoutSubview:sbv])
            {
                if (sbvFrame.width == CGFLOAT_MAX)
                    [self gtcCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

                sbvFrame.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvFrame.width];
            }

            sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];


        }
    }

    if ( (sbvsc.heightSizeInner.lBoundValInner != nil && sbvsc.heightSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.heightSizeInner.uBoundValInner != nil && sbvsc.heightSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX))
    {
        sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
    }

    return NO;

}


-(CGSize)gtcCalcLayout:(BOOL*)pRecalc lsc:(GTCRelativeLayout*)lsc selfSize:(CGSize)selfSize
{
    if (pRecalc != NULL)
        *pRecalc = NO;


    //遍历所有子视图，算出所有宽度和高度根据自身内容确定的子视图的尺寸.以及计算出那些有依赖关系的尺寸限制。。。
    for (UIView *sbv in self.subviews)
    {
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];


        [self gtcCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvFrame:sbvFrame];

        if (sbvFrame.width != CGFLOAT_MAX)
        {
            if (sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self gtcCalcWidth:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.gtcCurrentSizeClass
                              lsc:lsc
                       sbvFrame:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.gtcFrame
                         selfSize:selfSize];
            }

            if (sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self gtcCalcWidth:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.gtcCurrentSizeClass
                              lsc:lsc
                       sbvFrame:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.gtcFrame
                         selfSize:selfSize];
            }

            sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvFrame.width sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
        }

        if (sbvFrame.height != CGFLOAT_MAX)
        {
            if (sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self gtcCalcHeight:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.gtcCurrentSizeClass
                               lsc:lsc
                        sbvFrame:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.gtcFrame
                          selfSize:selfSize];
            }

            if (sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self gtcCalcHeight:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.gtcCurrentSizeClass
                               lsc:lsc
                        sbvFrame:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.gtcFrame
                          selfSize:selfSize];
            }

            sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
        }

    }

    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (sbvsc.widthSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;

            NSArray *dimeArray = sbvsc.widthSizeInner.dimeArrVal;

            BOOL isViewHidden = [self gtcIsNoLayoutSubview:sbv];
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.widthSizeInner.multiVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbvsc.widthSizeInner.addVal;
            for (GTCLayoutSize *dime in dimeArray)
            {

                if (dime.isActive)
                {
                    isViewHidden = [self gtcIsNoLayoutSubview:dime.view];
                    if (!isViewHidden)
                    {
                        if (dime.dimeVal != nil)
                        {
                            [self gtcCalcWidth:dime.view
                                        sbvsc:dime.view.gtcCurrentSizeClass
                                          lsc:lsc
                                   sbvFrame:dime.view.gtcFrame
                                     selfSize:selfSize];

                            totalAdd += -1 * dime.view.gtcFrame.width;
                        }
                        else
                        {
                            totalMulti += dime.multiVal;
                        }

                        totalAdd += dime.addVal;

                    }
                }

            }

            CGFloat floatingWidth = selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding + totalAdd;
            if ( _gtcCGFloatLessOrEqual(floatingWidth, 0))
                floatingWidth = 0;

            if (totalMulti != 0)
            {
                CGFloat tempWidth = _gtcCGFloatRound(floatingWidth * (sbvsc.widthSizeInner.multiVal / totalMulti));

                sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:tempWidth sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

                if ([self gtcIsNoLayoutSubview:sbv])
                {
                    sbvFrame.width = 0;
                }
                else
                {
                    floatingWidth -= tempWidth;
                    totalMulti -= sbvsc.widthSizeInner.multiVal;
                }

                for (GTCLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive && ![self gtcIsNoLayoutSubview:dime.view])
                    {
                        if (dime.dimeVal == nil)
                        {
                            tempWidth = _gtcCGFloatRound(floatingWidth * (dime.multiVal / totalMulti));
                            floatingWidth -= tempWidth;
                            totalMulti -= dime.multiVal;
                            dime.view.gtcFrame.width = tempWidth;

                        }

                        dime.view.gtcFrame.width = [self gtcValidMeasure:dime.view.widthSize sbv:dime.view calcSize:dime.view.gtcFrame.width sbvSize:dime.view.gtcFrame.frame.size selfLayoutSize:selfSize];
                    }
                    else
                    {
                        dime.view.gtcFrame.width = 0;
                    }
                }
            }
        }

        if (sbvsc.heightSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;

            NSArray *dimeArray = sbvsc.heightSizeInner.dimeArrVal;

            BOOL isViewHidden = [self gtcIsNoLayoutSubview:sbv];

            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.heightSizeInner.multiVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbvsc.heightSizeInner.addVal;
            for (GTCLayoutSize *dime in dimeArray)
            {
                if (dime.isActive)
                {
                    isViewHidden = [self gtcIsNoLayoutSubview:dime.view];
                    if (!isViewHidden)
                    {
                        if (dime.dimeVal != nil)
                        {
                            [self gtcCalcHeight:dime.view
                                         sbvsc:dime.view.gtcCurrentSizeClass
                                           lsc:lsc
                                    sbvFrame:dime.view.gtcFrame
                                      selfSize:selfSize];

                            totalAdd += -1 * dime.view.gtcFrame.height;
                        }
                        else
                            totalMulti += dime.multiVal;

                        totalAdd += dime.addVal;
                    }
                }
            }

            CGFloat floatingHeight = selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding + totalAdd;
            if (_gtcCGFloatLessOrEqual(floatingHeight, 0))
                floatingHeight = 0;

            if (totalMulti != 0)
            {
                CGFloat tempHeight = _gtcCGFloatRound(floatingHeight * (sbvsc.heightSizeInner.multiVal / totalMulti));
                sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:tempHeight sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

                if ([self gtcIsNoLayoutSubview:sbv])
                {
                    sbvFrame.height = 0;
                }
                else
                {
                    floatingHeight -= tempHeight;
                    totalMulti -= sbvsc.heightSizeInner.multiVal;
                }

                for (GTCLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive && ![self gtcIsNoLayoutSubview:dime.view])
                    {
                        if (dime.dimeVal == nil)
                        {
                            tempHeight = _gtcCGFloatRound(floatingHeight * (dime.multiVal / totalMulti));
                            floatingHeight -= tempHeight;
                            totalMulti -= dime.multiVal;
                            dime.view.gtcFrame.height = tempHeight;
                        }

                        dime.view.gtcFrame.height = [self gtcValidMeasure:dime.view.heightSize sbv:dime.view calcSize:dime.view.gtcFrame.height sbvSize:dime.view.gtcFrame.frame.size selfLayoutSize:selfSize];

                    }
                    else
                    {
                        dime.view.gtcFrame.height = 0;
                    }
                }
            }
        }


        //表示视图数组水平居中
        if (sbvsc.centerXPosInner.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *centerArray = sbvsc.centerXPosInner.posArrVal;

            CGFloat totalWidth = 0;
            CGFloat totalOffset = 0;

            GTCLayoutPosition *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                GTCLayoutPosition *pos = centerArray[i];
                if (![self gtcIsNoLayoutSubview:pos.view])
                {
                    if (totalWidth != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerXPos.absVal;
                    }

                    [self gtcCalcWidth:pos.view sbvsc:pos.view.gtcCurrentSizeClass lsc:lsc sbvFrame:pos.view.gtcFrame selfSize:selfSize];
                    totalWidth += pos.view.gtcFrame.width;
                }

                nextPos = pos;
            }

            if (![self gtcIsNoLayoutSubview:sbv])
            {
                if (totalWidth != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerXPos.absVal;
                }

                [self gtcCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];
                totalWidth += sbvFrame.width;
                totalOffset += sbvsc.centerXPosInner.absVal;
            }


            //所有宽度算出后，再分别设置
            CGFloat leadingOffset = (selfSize.width - lsc.gtcLayoutLeadingPadding - lsc.gtcLayoutTrailingPadding - totalWidth - totalOffset) / 2;
            leadingOffset += lsc.gtcLayoutLeadingPadding;
            id prev = @(leadingOffset);
            [sbvsc.leadingPos __equalTo:prev];
            prev = sbvsc.trailingPos;
            for (GTCLayoutPosition *pos in centerArray)
            {
                [[pos.view.leadingPos __equalTo:prev] __offset:pos.view.centerXPos.absVal];
                prev = pos.view.trailingPos;
            }
        }

        //表示视图数组垂直居中
        if (sbvsc.centerYPosInner.posArrVal != nil)
        {
            NSArray *centerArray = sbvsc.centerYPosInner.posArrVal;

            CGFloat totalHeight = 0;
            CGFloat totalOffset = 0;

            GTCLayoutPosition *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                GTCLayoutPosition *pos = centerArray[i];
                if (![self gtcIsNoLayoutSubview:pos.view])
                {
                    if (totalHeight != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerYPos.absVal;
                    }

                    [self gtcCalcHeight:pos.view sbvsc:pos.view.gtcCurrentSizeClass lsc:lsc sbvFrame:pos.view.gtcFrame selfSize:selfSize];
                    totalHeight += pos.view.gtcFrame.height;
                }

                nextPos = pos;
            }

            if (![self gtcIsNoLayoutSubview:sbv])
            {
                if (totalHeight != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerYPos.absVal;
                }

                [self gtcCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];
                totalHeight += sbvFrame.height;
                totalOffset += sbvsc.centerYPosInner.absVal;
            }


            //所有高度算出后，再分别设置
            CGFloat topOffset = (selfSize.height - lsc.gtcLayoutTopPadding - lsc.gtcLayoutBottomPadding - totalHeight - totalOffset) / 2;
            topOffset += lsc.gtcLayoutTopPadding;

            id prev = @(topOffset);
            [sbvsc.topPos __equalTo:prev];
            prev = sbvsc.bottomPos;
            for (GTCLayoutPosition *pos in centerArray)
            {
                [[pos.view.topPos __equalTo:prev] __offset:pos.view.centerYPos.absVal];
                prev = pos.view.bottomPos;
            }

        }


    }

    //计算最大的宽度和高度
    CGFloat maxWidth = lsc.gtcLayoutLeadingPadding + lsc.gtcLayoutTrailingPadding;
    CGFloat maxHeight = lsc.gtcLayoutTopPadding + lsc.gtcLayoutBottomPadding;

    for (UIView *sbv in self.subviews)
    {

        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];
        BOOL sbvWrapContentHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]];

        [self gtcCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

        //特殊处理高度包裹的情况，如果高度包裹时则同时设置顶部和底部将无效。
        if (sbvWrapContentHeight)
        {
            sbvFrame.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvFrame.width];
            sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvFrame.height sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
        }

        [self gtcCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvFrame:sbvFrame selfSize:selfSize];

        if ([self gtcIsNoLayoutSubview:sbv])
            continue;


        if (lsc.wrapContentWidth && pRecalc != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了右边或者中间的值，或者宽度依赖父视图)
            if(sbvsc.trailingPosInner.posNumVal != nil ||
               sbvsc.trailingPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posNumVal != nil ||
               sbvsc.widthSizeInner.dimeRelaVal.view == self
               )
            {
                *pRecalc = YES;
            }

            //宽度最小是任何一个子视图的左右偏移和外加内边距和。
            if (_gtcCGFloatLess(maxWidth, sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtcLayoutLeadingPadding + lsc.gtcLayoutTrailingPadding))
            {
                maxWidth = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtcLayoutLeadingPadding + lsc.gtcLayoutTrailingPadding;
            }

            if (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != self.widthSizeInner)
            {
                if (sbvsc.centerXPosInner.posVal != nil)
                {
                    if (_gtcCGFloatLess(maxWidth, sbvFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtcLayoutLeadingPadding + lsc.gtcLayoutTrailingPadding))
                        maxWidth = sbvFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtcLayoutLeadingPadding + lsc.gtcLayoutTrailingPadding;
                }
                else if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
                {
                    if (_gtcCGFloatLess(maxWidth, fabs(sbvFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.gtcLayoutLeadingPadding))
                    {
                        maxWidth = fabs(sbvFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.gtcLayoutLeadingPadding;
                    }

                }
                else if (sbvsc.trailingPosInner.posVal != nil)
                {
                    if (_gtcCGFloatLess(maxWidth, fabs(sbvFrame.leading) + lsc.gtcLayoutLeadingPadding))
                        maxWidth = fabs(sbvFrame.leading) + lsc.gtcLayoutLeadingPadding;
                }
                else
                {
                    if (_gtcCGFloatLess(maxWidth, fabs(sbvFrame.trailing) + lsc.gtcLayoutTrailingPadding))
                        maxWidth = fabs(sbvFrame.trailing) + lsc.gtcLayoutTrailingPadding;
                }


                if (_gtcCGFloatLess(maxWidth, sbvFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.gtcLayoutTrailingPadding))
                    maxWidth = sbvFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.gtcLayoutTrailingPadding;
            }
        }

        if (lsc.wrapContentHeight && pRecalc != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了下边或者中间的值，或者高度依赖父视图)
            if(sbvsc.bottomPosInner.posNumVal != nil ||
               sbvsc.bottomPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posNumVal != nil ||
               sbvsc.heightSizeInner.dimeRelaVal.view == self
               )
            {
                *pRecalc = YES;
            }

            if (_gtcCGFloatLess(maxHeight, sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtcLayoutTopPadding + lsc.gtcLayoutBottomPadding))
            {
                maxHeight = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtcLayoutTopPadding + lsc.gtcLayoutBottomPadding;
            }


            //这里加入特殊的条件sbvWrapContentHeight，因为有可能有同时设置顶部和底部位置又同时设置wrapContentHeight的情况，这种情况我们也让其加入最大高度计算行列。
            if (sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != self.heightSizeInner)
            {

                if (sbvsc.centerYPosInner.posVal != nil)
                {
                    if (_gtcCGFloatLess(maxHeight, sbvFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtcLayoutTopPadding + lsc.gtcLayoutBottomPadding))
                        maxHeight = sbvFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtcLayoutTopPadding + lsc.gtcLayoutBottomPadding;
                }
                else if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
                {
                    if (_gtcCGFloatLess(maxHeight, fabs(sbvFrame.bottom) + sbvsc.topPosInner.absVal + lsc.gtcLayoutTopPadding))
                    {
                        maxHeight = fabs(sbvFrame.bottom) + sbvsc.topPosInner.absVal + lsc.gtcLayoutTopPadding;
                    }
                }
                else if (sbvsc.bottomPosInner.posVal != nil)
                {
                    if (_gtcCGFloatLess(maxHeight, fabs(sbvFrame.top) + lsc.gtcLayoutTopPadding))
                        maxHeight = fabs(sbvFrame.top) + lsc.gtcLayoutTopPadding;
                }
                else
                {
                    if (_gtcCGFloatLess(maxHeight, fabs(sbvFrame.bottom) + lsc.gtcLayoutBottomPadding))
                        maxHeight = fabs(sbvFrame.bottom) + lsc.gtcLayoutBottomPadding;
                }


                if (_gtcCGFloatLess(maxHeight, sbvFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.gtcLayoutBottomPadding))
                    maxHeight = sbvFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.gtcLayoutBottomPadding;

            }
        }
    }


    return CGSizeMake(maxWidth, maxHeight);

}



@end
