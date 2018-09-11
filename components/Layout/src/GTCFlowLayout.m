//
//  GTCFlowLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/11.
//

#import "GTCFlowLayout.h"
#import "GTCLayoutInner.h"

@implementation GTCFlowLayout


#pragma mark -- Public Methods

-(instancetype)initWithFrame:(CGRect)frame orientation:(GTCOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.gtcCurrentSizeClass.orientation = orientation;
        self.gtcCurrentSizeClass.arrangedCount = arrangedCount;
    }

    return  self;
}

-(instancetype)initWithOrientation:(GTCOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    return [self initWithFrame:CGRectZero orientation:orientation arrangedCount:arrangedCount];
}


+(instancetype)flowLayoutWithOrientation:(GTCOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    GTCFlowLayout *layout = [[[self class] alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

-(void)setOrientation:(GTCOrientation)orientation
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(GTCOrientation)orientation
{
    return self.gtcCurrentSizeClass.orientation;
}


-(void)setArrangedCount:(NSInteger)arrangedCount
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.arrangedCount != arrangedCount)
    {
        lsc.arrangedCount = arrangedCount;
        [self setNeedsLayout];
    }
}

-(NSInteger)arrangedCount
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;
    return lsc.arrangedCount;
}


-(NSInteger)pagedCount
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;
    return lsc.pagedCount;
}

-(void)setPagedCount:(NSInteger)pagedCount
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.pagedCount != pagedCount)
    {
        lsc.pagedCount = pagedCount;
        [self setNeedsLayout];
    }
}


-(void)setAutoArrange:(BOOL)autoArrange
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;

    if (lsc.autoArrange != autoArrange)
    {
        lsc.autoArrange = autoArrange;
        [self setNeedsLayout];
    }
}

-(BOOL)autoArrange
{
    return self.gtcCurrentSizeClass.autoArrange;
}


-(void)setArrangedGravity:(GTCGravity)arrangedGravity
{
    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;
    if (lsc.arrangedGravity != arrangedGravity)
    {
        lsc.arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

-(GTCGravity)arrangedGravity
{
    return self.gtcCurrentSizeClass.arrangedGravity;
}


-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:GTCSizeClasshAny | GTCSizeClasswAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(GTCSizeClass)sizeClass
{
    GTCFlowLayoutViewSizeClass *lsc = (GTCFlowLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    lsc.subviewSize = subviewSize;
    lsc.maxSpace = maxSpace;
    lsc.minSpace = minSpace;
    [self setNeedsLayout];
}


#pragma mark -- Override Methods

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTCSizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];

    if (sbs == nil)
        sbs = [self gtcGetLayoutSubviews];

    GTCFlowLayout *lsc = self.gtcCurrentSizeClass;

    GTCOrientation orientation = lsc.orientation;
    GTCGravity gravity = lsc.gravity;
    GTCGravity arrangedGravity = lsc.arrangedGravity;

    for (UIView *sbv in sbs)
    {
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (!isEstimate)
        {
            sbvFrame.frame = sbv.bounds;
            [self gtcCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvFrame:sbvFrame];
        }

        if ([sbv isKindOfClass:[GTCBaseLayout class]])
        {

            if (sbvsc.wrapContentWidth)
            {
                if (lsc.pagedCount > 0 || sbvsc.widthSizeInner.dimeVal != nil ||
                    (orientation == GTCOrientationHorz && (arrangedGravity & GTCGravityVertMask) == GTCGravityHorzFill) ||
                    (orientation == GTCOrientationVert && ((gravity & GTCGravityVertMask) == GTCGravityHorzFill || sbvsc.weight != 0)))
                {
                    sbvsc.wrapContentWidth = NO;
                }
            }

            if (sbvsc.wrapContentHeight)
            {
                if (lsc.pagedCount > 0 || sbvsc.heightSizeInner.dimeVal != nil ||
                    (orientation == GTCOrientationVert && (arrangedGravity & GTCGravityHorzMask) == GTCGravityVertFill) ||
                    (orientation == GTCOrientationHorz && ((gravity & GTCGravityHorzMask) == GTCGravityVertFill || sbvsc.weight != 0)))
                {
                    sbvsc.wrapContentHeight = NO;
                }
            }


            BOOL isSbvWrap = sbvsc.wrapContentHeight || sbvsc.wrapContentWidth;

            if (pHasSubLayout != nil && isSbvWrap)
                *pHasSubLayout = YES;

            if (isEstimate && isSbvWrap)
            {
                [(GTCBaseLayout*)sbv sizeThatFits:sbvFrame.frame.size inSizeClass:sizeClass];
                if (sbvFrame.multiple)
                {
                    sbvFrame.sizeClass = [sbv gtcBestSizeClass:sizeClass]; //因为sizeThatFits执行后会还原，所以这里要重新设置
                }
            }
        }
    }



    if (orientation == GTCOrientationVert)
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self gtcLayoutSubviewsForVertContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self gtcLayoutSubviewsForVert:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }
    else
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self gtcLayoutSubviewsForHorzContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self gtcLayoutSubviewsForHorz:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }

    //调整布局视图自己的尺寸。
    [self gtcAdjustLayoutSelfSize:&selfSize lsc:lsc];
    //对所有子视图进行布局变换
    [self gtcAdjustSubviewsLayoutTransform:sbs lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtcAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];

    return [self gtcAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [GTCFlowLayoutViewSizeClass new];
}

#pragma mark -- Private Methods


- (void)gtcCalcVertLayoutSinglelineWeight:(CGSize)selfSize totalFloatWidth:(CGFloat)totalFloatWidth totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (sbvsc.weight != 0)
        {
            CGFloat tempWidth = _gtcCGFloatRound((totalFloatWidth * sbvsc.weight / totalWeight));
            if (sbvsc.widthSizeInner != nil)
                tempWidth = [sbvsc.widthSizeInner measureWith:tempWidth];

            totalFloatWidth -= tempWidth;
            totalWeight -= sbvsc.weight;

            sbvFrame.width =  [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:tempWidth sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
            sbvFrame.trailing = sbvFrame.leading + sbvFrame.width;
        }
    }
}

- (void)gtcCalcHorzLayoutSinglelineWeight:(CGSize)selfSize totalFloatHeight:(CGFloat)totalFloatHeight totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (sbvsc.weight != 0)
        {
            CGFloat tempHeight = _gtcCGFloatRound((totalFloatHeight * sbvsc.weight / totalWeight));
            if (sbvsc.heightSizeInner != nil)
                tempHeight = [sbvsc.heightSizeInner measureWith:tempHeight];

            totalFloatHeight -= tempHeight;
            totalWeight -= sbvsc.weight;

            sbvFrame.height =  [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:tempHeight sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
            sbvFrame.bottom = sbvFrame.top + sbvFrame.height;

            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: sbvFrame.height ] sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];

        }
    }
}



- (void)gtcCalcVertLayoutSinglelineAlignment:(CGSize)selfSize rowMaxHeight:(CGFloat)rowMaxHeight rowMaxWidth:(CGFloat)rowMaxWidth horzGravity:(GTCGravity)horzGravity vertAlignment:(GTCGravity)vertAlignment sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(GTCFlowLayout*)lsc
{

    CGFloat paddingLeading = lsc.gtcLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtcLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;

    CGFloat addXPos = 0; //多出来的空隙区域，用于停靠处理。
    CGFloat addXFill = 0;  //多出来的平均区域，用于拉伸间距或者尺寸
    BOOL averageArrange = (horzGravity == GTCGravityHorzFill);

    if (!averageArrange || lsc.arrangedCount == 0)
    {
        switch (horzGravity) {
            case GTCGravityHorzCenter:
            {
                addXPos = (selfSize.width - paddingHorz - rowMaxWidth) / 2;
            }
                break;
            case GTCGravityHorzTrailing:
            {
                addXPos = selfSize.width - paddingHorz - rowMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
            }
                break;
            case GTCGravityHorzBetween:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果最后一行的数量和其他行的数量一样除外)。
                if ((startIndex != sbs.count || count == lsc.arrangedCount) && count > 1)
                {
                    addXFill = (selfSize.width - paddingHorz - rowMaxWidth) / (count - 1);
                }
            }
                break;
            default:
                break;
        }

        //处理内容拉伸的情况。这里是只有内容约束布局才支持尺寸拉伸。
        if (lsc.arrangedCount == 0 && averageArrange)
        {
            //不是最后一行。。
            if (startIndex != sbs.count)
            {
                addXFill = (selfSize.width - paddingHorz - rowMaxWidth) / count;
            }

        }
    }


    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];

        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[GTCBaseLayout class]])
            {
                GTCBaseLayout *sbvl = (GTCBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;

                    //如果不是最后一行就画下面，
                    if (startIndex != sbs.count)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }

                    //如果不是最后一列就画右边,
                    if (j < startIndex - 1)
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    }

                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && lsc.arrangedCount != count )
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    }

                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && startIndex - count != 0)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }

                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && j != startIndex - count)
                    {
                        sbvl.leadingBorderline = self.intelligentBorderline;
                    }

                }
            }
        }

        GTCGravity sbvVertAlignment = sbvsc.gtc_alignment & GTCGravityHorzMask;
        if (sbvVertAlignment == GTCGravityNone)
            sbvVertAlignment = vertAlignment;
        if (vertAlignment == GTCGravityVertBetween)
            sbvVertAlignment = GTCGravityVertBetween;

        if ((sbvVertAlignment != GTCGravityNone && sbvVertAlignment != GTCGravityVertTop) || _gtcCGFloatNotEqual(addXPos, 0)  ||  _gtcCGFloatNotEqual(addXFill, 0))
        {

            sbvFrame.leading += addXPos;

            //内容约束布局并且是拉伸尺寸。。
            if (lsc.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbvFrame.width += addXFill;

                if (j != startIndex - count)
                {
                    sbvFrame.leading += addXFill * (j - (startIndex - count));

                }
            }
            else
            {
                //其他的只拉伸间距
                sbvFrame.leading += addXFill * (j - (startIndex - count));
            }


            switch (sbvVertAlignment) {
                case GTCGravityVertCenter:
                {
                    sbvFrame.top += (rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvFrame.height) / 2;

                }
                    break;
                case GTCGravityVertBottom:
                {
                    sbvFrame.top += rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvFrame.height;
                }
                    break;
                case GTCGravityVertFill:
                {
                    sbvFrame.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }

}

- (void)gtcCalcHorzLayoutSinglelineAlignment:(CGSize)selfSize colMaxWidth:(CGFloat)colMaxWidth colMaxHeight:(CGFloat)colMaxHeight vertGravity:(GTCGravity)vertGravity  horzAlignment:(GTCGravity)horzAlignment sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(GTCFlowLayout*)lsc
{

    CGFloat paddingTop = lsc.gtcLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtcLayoutBottomPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;

    CGFloat addYPos = 0;
    CGFloat addYFill = 0;

    BOOL averageArrange = (vertGravity == GTCGravityVertFill);

    if (!averageArrange || lsc.arrangedCount == 0)
    {
        switch (vertGravity) {
            case GTCGravityVertCenter:
            {
                addYPos = (selfSize.height - paddingVert - colMaxHeight) / 2;
            }
                break;
            case GTCGravityVertBottom:
            {
                addYPos = selfSize.height - paddingVert - colMaxHeight;
            }
                break;
            case GTCGravityVertBetween:
            {
                //总高度减去最大的高度。再除以数量表示每个应该扩展的空间。最后一行无效(如果数量和单行的数量相等除外)。
                if ((startIndex != sbs.count || count == lsc.arrangedCount) && count > 1)
                {
                    addYFill = (selfSize.height - paddingVert - colMaxHeight) / (count - 1);
                }

            }
            default:
                break;
        }

        //处理内容拉伸的情况。
        if (lsc.arrangedCount == 0 && averageArrange)
        {
            if (startIndex != sbs.count)
            {
                addYFill = (selfSize.height  - paddingVert - colMaxHeight) / count;
            }

        }

    }




    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];


        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[GTCBaseLayout class]])
            {
                GTCBaseLayout *sbvl = (GTCBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;


                    //如果不是最后一行就画下面，
                    if (j < startIndex - 1)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }

                    //如果不是最后一列就画右边,
                    if (startIndex != sbs.count )
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;

                    }

                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && lsc.arrangedCount != count )
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }

                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && j != startIndex - count)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }

                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && startIndex - count != 0  )
                    {
                        sbvl.leadingBorderline = self.intelligentBorderline;

                    }



                }
            }
        }


        GTCGravity sbvHorzAlignment = [self gtcConvertLeftRightGravityToLeadingTrailing:sbvsc.gtc_alignment & GTCGravityVertMask];
        if (sbvHorzAlignment == GTCGravityNone)
            sbvHorzAlignment = horzAlignment;
        if (horzAlignment == GTCGravityHorzBetween)
            sbvHorzAlignment = GTCGravityHorzBetween;

        if ((sbvHorzAlignment != GTCGravityNone && sbvHorzAlignment != GTCGravityHorzLeading) || _gtcCGFloatNotEqual(addYPos, 0) || _gtcCGFloatNotEqual(addYFill, 0) )
        {
            sbvFrame.top += addYPos;

            if (lsc.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbvFrame.height += addYFill;

                if (j != startIndex - count)
                {
                    sbvFrame.top += addYFill * (j - (startIndex - count));

                }
            }
            else
            {
                //只拉伸间距
                sbvFrame.top += addYFill * (j - (startIndex - count));
            }

            switch (sbvHorzAlignment) {
                case GTCGravityHorzCenter:
                {
                    sbvFrame.leading += (colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvFrame.width) / 2;

                }
                    break;
                case GTCGravityHorzTrailing:
                {
                    sbvFrame.leading += colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvFrame.width;
                }
                    break;
                case GTCGravityHorzFill:
                {
                    sbvFrame.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal sbvSize:sbvFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


-(CGFloat)gtcCalcSinglelineSize:(NSArray*)sbs space:(CGFloat)space
{
    CGFloat size = 0;
    for (UIView *sbv in sbs)
    {
        size += sbv.gtcFrame.trailing;
        if (sbv != sbs.lastObject)
            size += space;
    }

    return size;
}

-(NSArray*)gtcGetAutoArrangeSubviews:(NSMutableArray*)sbs selfSize:(CGFloat)selfSize space:(CGFloat)space
{

    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:sbs.count];

    NSMutableArray *bestSinglelineArray = [NSMutableArray arrayWithCapacity:sbs.count /2];

    while (sbs.count) {

        [self gtcCalcAutoArrangeSinglelineSubviews:sbs
                                            index:0
                                        calcArray:@[]
                                         selfSize:selfSize
                                            space:space
                              bestSinglelineArray:bestSinglelineArray];

        [retArray addObjectsFromArray:bestSinglelineArray];

        [bestSinglelineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            [sbs removeObject:obj];
        }];

        [bestSinglelineArray removeAllObjects];
    }

    return retArray;
}

-(void)gtcCalcAutoArrangeSinglelineSubviews:(NSMutableArray*)sbs
                                     index:(NSInteger)index
                                 calcArray:(NSArray*)calcArray
                                  selfSize:(CGFloat)selfSize
                                     space:(CGFloat)space
                       bestSinglelineArray:(NSMutableArray*)bestSinglelineArray
{
    if (index >= sbs.count)
    {
        CGFloat s1 = [self gtcCalcSinglelineSize:calcArray space:space];
        CGFloat s2 = [self gtcCalcSinglelineSize:bestSinglelineArray space:space];
        if (_gtcCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)) && _gtcCGFloatLessOrEqual(s1, selfSize) )
        {
            [bestSinglelineArray setArray:calcArray];
        }

        return;
    }


    for (NSInteger i = index; i < sbs.count; i++) {


        NSMutableArray *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:sbs[i]];

        CGFloat s1 = [self gtcCalcSinglelineSize:calcArray2 space:space];
        if (_gtcCGFloatLessOrEqual(s1, selfSize))
        {
            CGFloat s2 = [self gtcCalcSinglelineSize:bestSinglelineArray space:space];
            if (_gtcCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)))
            {
                [bestSinglelineArray setArray:calcArray2];
            }

            if (_gtcCGFloatEqual(s1, selfSize))
                break;

            [self gtcCalcAutoArrangeSinglelineSubviews:sbs
                                                index:i + 1
                                            calcArray:calcArray2
                                             selfSize:selfSize
                                                space:space
                                  bestSinglelineArray:bestSinglelineArray];

        }
        else
            break;

    }

}


-(CGSize)gtcLayoutSubviewsForVertContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTCFlowLayout*)lsc
{

    CGFloat paddingTop = lsc.gtcLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtcLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtcLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtcLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;

    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值

    GTCGravity vertGravity = lsc.gravity & GTCGravityHorzMask;
    GTCGravity horzGravity = [self gtcConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTCGravityVertMask];
    GTCGravity vertAlign = lsc.arrangedGravity & GTCGravityHorzMask;

    //支持浮动水平间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {

        CGFloat minSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).maxSpace;

        NSInteger rowCount =  floor((selfSize.width - paddingHorz  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            horzSpace = (selfSize.width - paddingHorz - subviewSize * rowCount)/(rowCount - 1);
            if (_gtcCGFloatGreat(horzSpace, maxSpace))
            {
                horzSpace = maxSpace;

                subviewSize =  (selfSize.width - paddingHorz -  horzSpace * (rowCount - 1)) / rowCount;

            }
        }
    }


    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            GTCFrame *sbvFrame = sbv.gtcFrame;
            UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

#ifdef DEBUG
            //约束异常：垂直流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! vertical flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
            CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
            CGRect rect = sbvFrame.frame;

            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;


            [self gtcSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];

            rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];

            //暂时把宽度存放sbv.gtcFrame.trailing上。因为浮动布局来说这个属性无用。
            sbvFrame.trailing = leadingSpace + rect.size.width + trailingSpace;
            if (_gtcCGFloatGreat(sbvFrame.trailing, selfSize.width - paddingHorz))
                sbvFrame.trailing = selfSize.width - paddingHorz;
        }

        [sbs setArray:[self gtcGetAutoArrangeSubviews:sbs selfSize:selfSize.width - paddingHorz space:horzSpace]];

    }


    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];

        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvFrame.frame;


        if (subviewSize != 0)
            rect.size.width = subviewSize;

        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;

        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;


        [self gtcSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];

        [self gtcSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];


        if (sbvsc.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatWidth = selfSize.width - paddingHorz - rowMaxWidth;
            if (_gtcCGFloatLessOrEqual(floatWidth, 0))
            {
                floatWidth += rowMaxWidth;
                arrangedIndex = 0;
            }

            if (arrangedIndex != 0)
                floatWidth -= horzSpace;

            rect.size.width = (floatWidth + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace;

        }


        rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];

        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width ];


        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]])
            rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];

        rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

        //计算xPos的值加上leadingSpace + rect.size.width + trailingSpace 的值要小于整体的宽度。
        CGFloat place = xPos + leadingSpace + rect.size.width + trailingSpace;
        if (arrangedIndex != 0)
            place += horzSpace;
        place += paddingTrailing;

        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.width > 0.0001)
        {
            xPos = paddingLeading;
            yPos += vertSpace;
            yPos += rowMaxHeight;


            [arrangeIndexSet addIndex:i - arrangedIndex];
            //计算每行的gravity情况。
            [self gtcCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];

            //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
            if (_gtcCGFloatGreat(leadingSpace + trailingSpace + rect.size.width, selfSize.width - paddingHorz))
            {

                rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];

                if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]])
                {
                    rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                    rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }

            }

            rowMaxHeight = 0;
            rowMaxWidth = 0;
            arrangedIndex = 0;

        }

        if (arrangedIndex != 0)
            xPos += horzSpace;


        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;

        if (_gtcCGFloatLess(rowMaxHeight, topSpace + bottomSpace + rect.size.height))
            rowMaxHeight = topSpace + bottomSpace + rect.size.height;

        if (_gtcCGFloatLess(rowMaxWidth, (xPos - paddingLeading)))
            rowMaxWidth = (xPos - paddingLeading);



        sbvFrame.frame = rect;

        arrangedIndex++;



    }

    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];

    [self gtcCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];


    if (lsc.wrapContentHeight)
        selfSize.height = yPos + paddingBottom + rowMaxHeight;
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;

        if (vertGravity == GTCGravityVertCenter)
        {
            addYPos = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / 2;
        }
        else if (vertGravity == GTCGravityVertBottom)
        {
            addYPos = selfSize.height - paddingBottom - rowMaxHeight - yPos;
        }
        else if (vertGravity == GTCGravityVertFill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / arrangeIndexSet.count;
        }
        else if (vertGravity == GTCGravityVertBetween)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / (arrangeIndexSet.count - 1);
        }

        if (addYPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];

                GTCFrame *sbvFrame = sbv.gtcFrame;

                sbvFrame.top += addYPos;

                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }

                sbvFrame.height += fill;
                sbvFrame.top += fill * line;

                sbvFrame.top += between * line;

            }
        }

    }


    return selfSize;

}


-(CGSize)gtcLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTCFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.gtcLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtcLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtcLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtcLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;

    BOOL autoArrange = lsc.autoArrange;
    NSInteger arrangedCount = lsc.arrangedCount;
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    CGFloat maxWidth = paddingLeading;  //全部行的最宽值
    CGFloat maxHeight = paddingTop; //最大的高度
    GTCGravity vertGravity = lsc.gravity & GTCGravityHorzMask;
    GTCGravity horzGravity = [self gtcConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTCGravityVertMask];
    GTCGravity vertAlign = lsc.arrangedGravity & GTCGravityHorzMask;



    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;

    CGFloat subviewSize = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        CGFloat maxSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).maxSpace;
        CGFloat minSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).minSpace;
        if (arrangedCount > 1)
        {
            horzSpace = (selfSize.width - paddingHorz - subviewSize * arrangedCount)/(arrangedCount - 1);
            if (_gtcCGFloatGreat(horzSpace, maxSpace) || _gtcCGFloatLess(horzSpace, minSpace))
            {
                if (_gtcCGFloatGreat(horzSpace, maxSpace))
                    horzSpace = maxSpace;
                if (_gtcCGFloatLess(horzSpace, minSpace))
                    horzSpace = minSpace;

                subviewSize =  (selfSize.width - paddingHorz -  horzSpace * (arrangedCount - 1)) / arrangedCount;

            }
        }
    }

#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] && ((UIScrollView*)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif

    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger rows = lsc.pagedCount / arrangedCount;  //每页的行数。

        //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
        if (lsc.wrapContentWidth)
        {
            isHorzPaging = YES;
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (arrangedCount - 1) * horzSpace ) / arrangedCount;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - arrangedCount * horzSpace ) / arrangedCount;

            pagingItemHeight = (selfSize.height - paddingVert - (rows - 1) * vertSpace) / rows;
        }
        else
        {
            isVertPaging = YES;
            pagingItemWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (rows - 1) * vertSpace) / rows;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - rows * vertSpace) / rows;

        }

    }


    BOOL averageArrange = (horzGravity == GTCGravityHorzFill);

    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedWidth = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];

        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;

            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self gtcCalcVertLayoutSinglelineWeight:selfSize totalFloatWidth:selfSize.width - paddingHorz - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }

            rowTotalWeight = 0;
            rowTotalFixedWidth = 0;

        }

        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvFrame.frame;


        if (sbvsc.weight != 0)
        {

            rowTotalWeight += sbvsc.weight;
        }
        else
        {
            if (subviewSize != 0)
                rect.size.width = subviewSize;

            if (pagingItemWidth != 0)
                rect.size.width = pagingItemWidth;

            if (sbvsc.widthSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.width = sbvsc.widthSizeInner.measure;


            [self gtcSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];


            rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];

            rowTotalFixedWidth += rect.size.width;
        }

        rowTotalFixedWidth += leadingSpace + trailingSpace;

        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedWidth += horzSpace;


        sbvFrame.frame = rect;

        arrangedIndex++;

    }

    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedWidth -= horzSpace;

        [self gtcCalcVertLayoutSinglelineWeight:selfSize totalFloatWidth:selfSize.width - paddingHorz - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }

    //每列的下一个位置。
    NSMutableArray<NSValue*> *nextPointOfRows = nil;
    if (autoArrange)
    {
        nextPointOfRows = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++)
        {
            [nextPointOfRows addObject:[NSValue valueWithCGPoint:CGPointMake(paddingLeading, paddingTop)]];
        }
    }

    CGFloat pageWidth  = 0; //页宽。
    CGFloat averageWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        //新的一行
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            yPos += rowMaxHeight;
            yPos += vertSpace;

            //分别处理水平分页和垂直分页。
            if (isHorzPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageWidth += CGRectGetWidth(self.superview.bounds);

                    if (!isPagingScroll)
                        pageWidth -= paddingLeading;

                    yPos = paddingTop;
                }

            }

            if (isVertPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {

                    if (isPagingScroll)
                    {
                        yPos -= vertSpace;
                        yPos += paddingVert;

                    }
                }
            }


            xPos = paddingLeading + pageWidth;


            //计算每行的gravity情况。
            [self gtcCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            rowMaxHeight = 0;
            rowMaxWidth = 0;

        }


        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvFrame.frame;
        BOOL isFlexedHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self;

        if (pagingItemHeight != 0)
            rect.size.height = pagingItemHeight;


        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;

        if (averageArrange)
        {
            rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:averageWidth - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
        }


        [self gtcSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];

        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
            rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];


        rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

        //得到最大的行高
        if (_gtcCGFloatLess(rowMaxHeight, topSpace + bottomSpace + rect.size.height))
            rowMaxHeight = topSpace + bottomSpace + rect.size.height;


        //自动排列。
        if (autoArrange)
        {
            //查找能存放当前子视图的最小y轴的位置以及索引。
            CGPoint minPt = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++)
            {
                CGPoint pt = nextPointOfRows[idx].CGPointValue;
                if (minPt.y > pt.y)
                {
                    minPt = pt;
                    minNextPointIndex = idx;
                }
            }

            //找到的minNextPointIndex中的
            xPos = minPt.x;
            yPos = minPt.y;

            minPt.y = minPt.y + topSpace + rect.size.height + bottomSpace + vertSpace;
            nextPointOfRows[minNextPointIndex] = [NSValue valueWithCGPoint:minPt];
            if (minNextPointIndex + 1 <= arrangedCount - 1)
            {
                minPt = nextPointOfRows[minNextPointIndex + 1].CGPointValue;
                minPt.x = xPos + leadingSpace + rect.size.width + trailingSpace + horzSpace;
                nextPointOfRows[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPt];
            }

            if (_gtcCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace))
                maxHeight = yPos + topSpace + rect.size.height + bottomSpace;

        }
        else if (vertAlign == GTCGravityVertBetween)
        { //当列是紧凑排列时需要特殊处理当前的垂直位置。
            //第0行特殊处理。
            if (i - arrangedCount < 0)
            {
                yPos = paddingTop;
            }
            else
            {
                //取前一行的对应的列的子视图。
                GTCFrame *gtcPrevColSbvFrame = ((UIView*)sbs[i - arrangedCount]).gtcFrame;
                UIView *gtcPrevColSbvsc = [self gtcCurrentSizeClassFrom:gtcPrevColSbvFrame];
                //当前子视图的位置等于前一行对应列的最大y的值 + 前面对应列的底部间距 + 子视图之间的行间距。
                yPos =  CGRectGetMaxY(gtcPrevColSbvFrame.frame)+ gtcPrevColSbvsc.bottomPosInner.absVal + vertSpace;
            }

            if (_gtcCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace))
                maxHeight = yPos + topSpace + rect.size.height + bottomSpace;
        }
        else
        {//正常排列。
            //这里的最大其实就是最后一个视图的位置加上最高的子视图的尺寸。
            maxHeight = yPos + rowMaxHeight;
        }

        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;

        if (arrangedIndex != (arrangedCount - 1) && !autoArrange)
            xPos += horzSpace;



        if (_gtcCGFloatLess(rowMaxWidth, (xPos - paddingLeading)))
            rowMaxWidth = (xPos - paddingLeading);

        if (_gtcCGFloatLess(maxWidth, xPos))
            maxWidth = xPos;



        sbvFrame.frame = rect;

        arrangedIndex++;

    }

    //最后一行
    [self gtcCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];

    maxHeight += paddingBottom;

    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxHeight;

        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtcCGFloatLess(selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds)))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }

    }
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        int arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount);

        if (vertGravity == GTCGravityVertCenter)
        {
            addYPos = (selfSize.height - maxHeight) / 2;
        }
        else if (vertGravity == GTCGravityVertBottom)
        {
            addYPos = selfSize.height - maxHeight;
        }
        else if (vertGravity == GTCGravityVertFill)
        {
            if (arranges > 0)
                fill = (selfSize.height - maxHeight) / arranges;
        }
        else if (vertGravity == GTCGravityVertBetween)
        {

            if (arranges > 1)
                between = (selfSize.height - maxHeight) / (arranges - 1);
        }


        if (addYPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];

                GTCFrame *sbvFrame = sbv.gtcFrame;

                int lines = i / arrangedCount;
                sbvFrame.height += fill;
                sbvFrame.top += fill * lines;

                sbvFrame.top += addYPos;

                sbvFrame.top += between * lines;

            }
        }

    }

    if (lsc.wrapContentWidth && !averageArrange)
    {
        selfSize.width = maxWidth + paddingTrailing;

        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtcCGFloatLess(selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds)))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }

    }

    return selfSize;
}





-(CGSize)gtcLayoutSubviewsForHorzContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTCFlowLayout*)lsc
{

    CGFloat paddingTop = lsc.gtcLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtcLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtcLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtcLayoutTrailingPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;

    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat colMaxWidth = 0;  //某一列的最宽值。
    CGFloat colMaxHeight = 0;   //某一列的最高值

    GTCGravity vertGravity = lsc.gravity & GTCGravityHorzMask;
    GTCGravity horzGravity = [self gtcConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTCGravityVertMask];
    GTCGravity horzAlign =  [self gtcConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & GTCGravityVertMask];


    //支持浮动垂直间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {

        CGFloat minSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).maxSpace;
        NSInteger rowCount =  floor((selfSize.height - paddingVert  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            vertSpace = (selfSize.height - paddingVert - subviewSize * rowCount)/(rowCount - 1);
            if (_gtcCGFloatGreat(vertSpace, maxSpace))
            {
                vertSpace = maxSpace;

                subviewSize =  (selfSize.height - paddingVert -  vertSpace * (rowCount - 1)) / rowCount;

            }
        }
    }


    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            GTCFrame *sbvFrame = sbv.gtcFrame;
            UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

#ifdef DEBUG
            //约束异常：水平流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! horizontal flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif


            CGFloat topSpace = sbvsc.topPosInner.absVal;
            CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
            CGRect rect = sbvFrame.frame;

            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;

            if (subviewSize != 0)
                rect.size.height = subviewSize;

            if (sbvsc.heightSizeInner.dimeNumVal != nil)
                rect.size.height = sbvsc.heightSizeInner.measure;

            [self gtcSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];

            rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

            [self gtcSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];

            rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];


            //如果高度是浮动的则需要调整高度。
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]])
            {
                rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];

                rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }


            //暂时把宽度存放sbv.gtcFrame.trailing上。因为浮动布局来说这个属性无用。
            sbvFrame.trailing = topSpace + rect.size.height + bottomSpace;
            if (_gtcCGFloatGreat(sbvFrame.trailing, selfSize.height - paddingVert))
                sbvFrame.trailing = selfSize.height - paddingVert;
        }

        [sbs setArray:[self gtcGetAutoArrangeSubviews:sbs selfSize:selfSize.height - paddingVert space:vertSpace]];

    }



    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];

        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];


        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvFrame.frame;

        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;

        if (subviewSize != 0)
            rect.size.height = subviewSize;

        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;

        [self gtcSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];

        [self gtcSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];


        if (sbvsc.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatHeight = selfSize.height - paddingVert - colMaxHeight;
            if (_gtcCGFloatLessOrEqual(floatHeight, 0))
            {
                floatHeight += colMaxHeight;
                arrangedIndex = 0;
            }

            if (arrangedIndex != 0)
                floatHeight -= vertSpace;

            rect.size.height = (floatHeight + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace;

        }


        rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height ];



        rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];

        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]])
        {
            rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];

            rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }

        //计算yPos的值加上topSpace + rect.size.height + bottomSpace的值要小于整体的高度。
        CGFloat place = yPos + topSpace + rect.size.height + bottomSpace;
        if (arrangedIndex != 0)
            place += vertSpace;
        place += paddingBottom;

        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.height > 0.0001)
        {
            yPos = paddingTop;
            xPos += horzSpace;
            xPos += colMaxWidth;


            //计算每行的gravity情况。
            [arrangeIndexSet addIndex:i - arrangedIndex];
            [self gtcCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];

            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (_gtcCGFloatGreat(topSpace + bottomSpace + rect.size.height, selfSize.height - paddingVert))
            {
                rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingVert - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
            }

            colMaxWidth = 0;
            colMaxHeight = 0;
            arrangedIndex = 0;

        }

        if (arrangedIndex != 0)
            yPos += vertSpace;


        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;

        if (_gtcCGFloatLess(colMaxWidth, leadingSpace + trailingSpace + rect.size.width))
            colMaxWidth = leadingSpace + trailingSpace + rect.size.width;

        if (_gtcCGFloatLess(colMaxHeight, (yPos - paddingTop)))
            colMaxHeight = (yPos - paddingTop);



        sbvFrame.frame = rect;

        arrangedIndex++;



    }

    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    [self gtcCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];


    if (lsc.wrapContentWidth)
        selfSize.width = xPos + paddingTrailing + colMaxWidth;
    else
    {
        CGFloat addXPos = 0;
        CGFloat fill = 0;
        CGFloat between = 0;

        if (horzGravity == GTCGravityHorzCenter)
        {
            addXPos = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / 2;
        }
        else if (horzGravity == GTCGravityHorzTrailing)
        {
            addXPos = selfSize.width - paddingTrailing - colMaxWidth - xPos;
        }
        else if (horzGravity == GTCGravityHorzFill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / arrangeIndexSet.count;
        }
        else if (horzGravity == GTCGravityHorzBetween)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / (arrangeIndexSet.count - 1);
        }


        if (addXPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                GTCFrame *sbvFrame = sbv.gtcFrame;

                sbvFrame.leading += addXPos;

                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }

                sbvFrame.width += fill;
                sbvFrame.leading += fill * line;

                sbvFrame.leading += between * line;

            }
        }

    }


    return selfSize;
}



-(CGSize)gtcLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTCFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.gtcLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtcLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtcLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtcLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;

    BOOL autoArrange = lsc.autoArrange;
    NSInteger arrangedCount = lsc.arrangedCount;
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat colMaxWidth = 0;  //每列的最大宽度
    CGFloat colMaxHeight = 0; //每列的最大高度
    CGFloat maxHeight = paddingTop;
    CGFloat maxWidth = paddingLeading; //最大的宽度。

    GTCGravity vertGravity = lsc.gravity & GTCGravityHorzMask;
    GTCGravity horzGravity = [self gtcConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTCGravityVertMask];
    GTCGravity horzAlign =  [self gtcConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & GTCGravityVertMask];


    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {

        CGFloat maxSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).maxSpace;
        CGFloat minSpace = ((GTCFlowLayoutViewSizeClass*)self.gtcCurrentSizeClass).minSpace;
        if (arrangedCount > 1)
        {
            vertSpace = (selfSize.height - paddingVert - subviewSize * arrangedCount)/(arrangedCount - 1);
            if (_gtcCGFloatGreat(vertSpace, maxSpace) || _gtcCGFloatLess(vertSpace, minSpace))
            {
                if (_gtcCGFloatGreat(vertSpace, maxSpace))
                    vertSpace = maxSpace;
                if (_gtcCGFloatLess(vertSpace, minSpace))
                    vertSpace = minSpace;

                subviewSize =  (selfSize.height - paddingVert -  vertSpace * (arrangedCount - 1)) / arrangedCount;

            }
        }
    }

    //父滚动视图是否分页滚动。
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] && ((UIScrollView*)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif

    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger cols = lsc.pagedCount / arrangedCount;  //每页的列数。

        //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
        if (lsc.wrapContentHeight)
        {
            isVertPaging = YES;
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (arrangedCount - 1) * vertSpace ) / arrangedCount;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - arrangedCount * vertSpace ) / arrangedCount;

            pagingItemWidth = (selfSize.width - paddingHorz - (cols - 1) * horzSpace) / cols;
        }
        else
        {
            isHorzPaging = YES;
            pagingItemHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (cols - 1) * horzSpace) / cols;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - cols * horzSpace) / cols;

        }

    }

    BOOL averageArrange = (vertGravity == GTCGravityVertFill);

    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedHeight = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;

            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self gtcCalcHorzLayoutSinglelineWeight:selfSize totalFloatHeight:selfSize.height - paddingVert - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }

            rowTotalWeight = 0;
            rowTotalFixedHeight = 0;

        }

        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGRect rect = sbvFrame.frame;


        if (pagingItemWidth != 0)
            rect.size.width = pagingItemWidth;

        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;

        //当子视图的尺寸是相对依赖于其他尺寸的值。
        [self gtcSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];


        rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];


        if (sbvsc.weight != 0)
        {

            rowTotalWeight += sbvsc.weight;
        }
        else
        {

            BOOL isFlexedHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTCBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self;

            if (subviewSize != 0)
                rect.size.height = subviewSize;

            if (pagingItemHeight != 0)
                rect.size.height = pagingItemHeight;

            if (sbvsc.heightSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.height = sbvsc.heightSizeInner.measure;

            //当子视图的尺寸是相对依赖于其他尺寸的值。
            [self gtcSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];


            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
                rect.size.height = [self gtcHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];

            rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];

            rowTotalFixedHeight += rect.size.height;
        }

        rowTotalFixedHeight += topSpace + bottomSpace;


        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedHeight += vertSpace;


        sbvFrame.frame = rect;

        arrangedIndex++;

    }

    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedHeight -= vertSpace;

        [self gtcCalcHorzLayoutSinglelineWeight:selfSize totalFloatHeight:selfSize.height - paddingVert - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }

    //每行的下一个位置。
    NSMutableArray<NSValue*> *nextPointOfRows = nil;
    if (autoArrange)
    {
        nextPointOfRows = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++)
        {
            [nextPointOfRows addObject:[NSValue valueWithCGPoint:CGPointMake(paddingLeading, paddingTop)]];
        }
    }

    CGFloat pageHeight = 0; //页高
    CGFloat averageHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        GTCFrame *sbvFrame = sbv.gtcFrame;
        UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos += colMaxWidth;
            xPos += horzSpace;

            //分别处理水平分页和垂直分页。
            if (isVertPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageHeight += CGRectGetHeight(self.superview.bounds);

                    if (!isPagingScroll)
                        pageHeight -= paddingTop;

                    xPos = paddingLeading;
                }

            }

            if (isHorzPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {

                    if (isPagingScroll)
                    {
                        xPos -= horzSpace;
                        xPos += paddingTrailing;
                        xPos += paddingLeading;
                    }
                }
            }


            yPos = paddingTop + pageHeight;


            //计算每行的gravity情况。
            [self gtcCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];

            colMaxWidth = 0;
            colMaxHeight = 0;
        }

        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvFrame.frame;


        if (averageArrange)
        {

            rect.size.height = [self gtcValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:averageHeight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];

            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                rect.size.width = [self gtcValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
        }

        //得到最大的列宽
        if (_gtcCGFloatLess(colMaxWidth, leadingSpace + trailingSpace + rect.size.width))
            colMaxWidth = leadingSpace + trailingSpace + rect.size.width;

        //自动排列。
        if (autoArrange)
        {
            //查找能存放当前子视图的最小x轴的位置以及索引。
            CGPoint minPt = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++)
            {
                CGPoint pt = nextPointOfRows[idx].CGPointValue;
                if (minPt.x > pt.x)
                {
                    minPt = pt;
                    minNextPointIndex = idx;
                }
            }

            //找到的minNextPointIndex中的
            xPos = minPt.x;
            yPos = minPt.y;

            minPt.x = minPt.x + leadingSpace + rect.size.width + trailingSpace + horzSpace;
            nextPointOfRows[minNextPointIndex] = [NSValue valueWithCGPoint:minPt];
            if (minNextPointIndex + 1 <= arrangedCount - 1)
            {
                minPt = nextPointOfRows[minNextPointIndex + 1].CGPointValue;
                minPt.y = yPos + topSpace + rect.size.height + bottomSpace + vertSpace;
                nextPointOfRows[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPt];
            }

            if (_gtcCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace))
                maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace;

        }
        else if (horzAlign == GTCGravityHorzBetween)
        { //当列是紧凑排列时需要特殊处理当前的水平位置。
            //第0列特殊处理。
            if (i - arrangedCount < 0)
            {
                xPos = paddingLeading;
            }
            else
            {
                //取前一列的对应的行的子视图。
                GTCFrame *gtcPrevColSbvFrame = ((UIView*)sbs[i - arrangedCount]).gtcFrame;
                UIView *gtcPrevColSbvsc = [self gtcCurrentSizeClassFrom:gtcPrevColSbvFrame];
                //当前子视图的位置等于前一列对应行的最大x的值 + 前面对应行的尾部间距 + 子视图之间的列间距。
                xPos =  CGRectGetMaxX(gtcPrevColSbvFrame.frame)+ gtcPrevColSbvsc.trailingPosInner.absVal + horzSpace;
            }

            if (_gtcCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace))
                maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace;
        }
        else
        {//正常排列。
            //这里的最大其实就是最后一个视图的位置加上最宽的子视图的尺寸。
            maxWidth = xPos + colMaxWidth;
        }

        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;

        //不是最后一行以及非自动排列时才添加布局视图设置的行间距。自动排列的情况下上面已经有添加行间距了。
        if (arrangedIndex != (arrangedCount - 1) && !autoArrange)
            yPos += vertSpace;


        if (_gtcCGFloatLess(colMaxHeight, (yPos - paddingTop)))
            colMaxHeight = yPos - paddingTop;

        if (_gtcCGFloatLess(maxHeight, yPos))
            maxHeight = yPos;


        sbvFrame.frame = rect;


        arrangedIndex++;

    }

    //最后一列
    [self gtcCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];

    if (lsc.wrapContentHeight && !averageArrange)
    {
        selfSize.height = maxHeight + paddingBottom;

        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtcCGFloatLess(selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds)))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
    }


    maxWidth += paddingTrailing;

    if (lsc.wrapContentWidth)
    {
        selfSize.width = maxWidth;

        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtcCGFloatLess(selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds)))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }

    }
    else
    {

        CGFloat addXPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        int arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount); //列数

        if (horzGravity == GTCGravityHorzCenter)
        {
            addXPos = (selfSize.width - maxWidth) / 2;
        }
        else if (horzGravity == GTCGravityHorzTrailing)
        {
            addXPos = selfSize.width - maxWidth;
        }
        else if (horzGravity == GTCGravityHorzFill)
        {
            if (arranges > 0)
                fill = (selfSize.width - maxWidth) / arranges;
        }
        else if (horzGravity == GTCGravityHorzBetween)
        {
            if (arranges > 1)
                between = (selfSize.width - maxWidth) / (arranges - 1);
        }

        if (addXPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];

                GTCFrame *sbvFrame = sbv.gtcFrame;

                int lines = i / arrangedCount;
                sbvFrame.width += fill;
                sbvFrame.leading += fill * lines;

                sbvFrame.leading += addXPos;

                sbvFrame.leading += between * lines;

            }
        }
    }


    return selfSize;

}



@end
