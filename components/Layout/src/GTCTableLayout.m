//
//  GTCTableLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/11.
//

#import "GTCTableLayout.h"
#import "GTCLayoutInner.h"

static CGFloat sColCountTag = -100000;

@interface GTCTableRowLayout : GTCLinearLayout


+(GTCTableRowLayout *)rowSize:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(GTCOrientation)orientation;

@property(nonatomic,assign, readonly) CGFloat rowSize;
@property(nonatomic,assign, readonly) CGFloat colSize;

@end

@implementation GTCTableRowLayout
{
    CGFloat _rowSize;
    CGFloat _colSize;
}


-(instancetype)initWith:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(GTCOrientation)orientation
{
    self = [super initWithOrientation:orientation];
    if (self != nil)
    {
        _rowSize = rowSize;
        _colSize = colSize;

        UIView *lsc = self.gtcCurrentSizeClass;

        if (rowSize == GTCLayoutSize.average)
            lsc.weight = 1;
        else if (rowSize > 0)
        {
            if (orientation == GTCOrientationHorz)
                lsc.gtc_height = rowSize;
            else
                lsc.gtc_width = rowSize;
        }
        else if (rowSize == GTCLayoutSize.wrap)
        {
            if (orientation == GTCOrientationHorz)
                lsc.wrapContentHeight = YES;
            else
                lsc.wrapContentWidth = YES;
        }
        else
        {
            NSCAssert(0, @"Constraint exception !! rowSize can not set to MyLayoutSize.fill");
        }

        if (colSize == GTCLayoutSize.average || colSize == GTCLayoutSize.fill || colSize < sColCountTag)
        {
            if (orientation == GTCOrientationHorz)
            {
                lsc.wrapContentWidth = NO;
                lsc.gtc_horzMargin = 0;
            }
            else
            {
                lsc.wrapContentHeight = NO;
                lsc.gtc_vertMargin = 0;
            }

        }
    }

    return self;
}

-(void)gtcHookSublayout:(GTCBaseLayout *)sublayout borderlineRect:(CGRect *)pRect
{
    /*
     如果行布局是包裹的，那么意味着里面的列子视图都需要自己指定行的尺寸，这样列子视图就会有不同的尺寸，如果是有智能边界线时就会出现每个列子视图的边界线的长度不一致的情况。
     有时候我们希望列子视图的边界线能够布满整个行(比如垂直表格中，所有列子视图的的高度都和所在行的行高是一致的）因此我们需要将列子视图的边界线的可显示范围进行调整。
     因此我们重载这个方法来解决这个问题，这个方法可以将列子视图的边界线的区域进行扩充和调整，目的是为了让列子视图的边界线能够布满整个行布局上。
     */
    if (self.rowSize == GTCLayoutSize.wrap)
    {
        if (self.orientation == GTCOrientationHorz)
        {
            //垂直表格下，行是水平的，所以这里需要将列子视图的y轴的位置和行对齐。
            pRect->origin.y = 0 - sublayout.frame.origin.y;
            //垂直表格下，行是水平的，所以这里需要将子视图的边界线的高度和行的高度保持一致。
            pRect->size.height = self.bounds.size.height;
        }
        else
        {
            //水平表格下，行是垂直的，所以这里需要将列子视图的x轴的位置和行对齐。
            pRect->origin.x = 0 - sublayout.frame.origin.x;
            //水平表格下，行是垂直的，所以这里需要将子视图的边界线的宽度和行的宽度保持一致。
            pRect->size.width = self.bounds.size.width;
        }
    }
}


+(GTCTableRowLayout *)rowSize:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(GTCOrientation)orientation
{
    return [[self alloc] initWith:rowSize colSize:colSize orientation:orientation];
}


@end


@implementation NSIndexPath(GTCTableLayoutEx)

+(instancetype)indexPathForCol:(NSInteger)col inRow:(NSInteger)row
{
    return [self indexPathForRow:row inSection:col];
}

-(NSInteger)col
{
    return self.section;
}

@end


@implementation GTCTableLayout


#pragma mark -- Public Methods

+(instancetype)tableLayoutWithOrientation:(GTCOrientation)orientation
{
    return [self linearLayoutWithOrientation:orientation];
}


-(GTCLinearLayout*)addRow:(CGFloat)rowSize colSize:(CGFloat)colSize
{
    return [self insertRow:rowSize colSize:colSize atIndex:self.countOfRow];
}

-(GTCLinearLayout*)addRow:(CGFloat)rowSize colCount:(NSUInteger)colCount
{
    return [self insertRow:rowSize colCount:colCount atIndex:self.countOfRow];
}

-(GTCLinearLayout*)insertRow:(CGFloat)rowSize colCount:(NSUInteger)colCount atIndex:(NSInteger)rowIndex
{
    //这里特殊处理用-100000 - colCount 来表示一个特殊的列尺寸。其实是数量。
    return [self  insertRow:rowSize colSize:sColCountTag - colCount atIndex:rowIndex];
}


-(GTCLinearLayout*)insertRow:(CGFloat)rowSize colSize:(CGFloat)colSize atIndex:(NSInteger)rowIndex
{
    GTCTableLayout *lsc = self.gtcCurrentSizeClass;

    GTCOrientation ori = GTCOrientationVert;
    if (lsc.orientation == GTCOrientationVert)
        ori = GTCOrientationHorz;
    else
        ori = GTCOrientationVert;

    GTCTableRowLayout *rowView = [GTCTableRowLayout rowSize:rowSize colSize:colSize orientation:ori];
    if (ori == GTCOrientationHorz)
    {
        rowView.subviewHSpace = lsc.subviewHSpace;
    }
    else
    {
        rowView.subviewVSpace = lsc.subviewVSpace;
    }
    rowView.intelligentBorderline = self.intelligentBorderline;
    [super insertSubview:rowView atIndex:rowIndex];
    return rowView;
}

-(void)removeRowAt:(NSInteger)rowIndex
{
    [[self viewAtRowIndex:rowIndex] removeFromSuperview];
}

-(void)exchangeRowAt:(NSInteger)rowIndex1 withRow:(NSInteger)rowIndex2
{
    [super exchangeSubviewAtIndex:rowIndex1 withSubviewAtIndex:rowIndex2];
}

-(GTCLinearLayout*)viewAtRowIndex:(NSInteger)rowIndex;
{
    return [self.subviews objectAtIndex:rowIndex];
}

-(NSUInteger)countOfRow
{
    return self.subviews.count;
}

//列操作
-(void)addCol:(UIView*)colView atRow:(NSInteger)rowIndex
{
    [self insertCol:colView atIndexPath:[NSIndexPath indexPathForCol:[self countOfColInRow:rowIndex] inRow:rowIndex]];
}

-(void)insertCol:(UIView*)colView atIndexPath:(NSIndexPath*)indexPath
{
    GTCTableRowLayout *rowView = (GTCTableRowLayout*)[self viewAtRowIndex:indexPath.row];

    GTCLinearLayout *rowsc = rowView.gtcCurrentSizeClass;
    UIView *colsc = colView.gtcCurrentSizeClass;

    //colSize为0表示均分尺寸，为-1表示由子视图决定尺寸，大于0表示固定尺寸。
    if (rowView.colSize == GTCLayoutSize.average)
    {
        colsc.weight = 1;
    }
    else if (rowView.colSize < sColCountTag)
    {
        NSUInteger colCount = sColCountTag - rowView.colSize;
        if (rowsc.orientation == GTCOrientationHorz)
        {
#ifdef GT_USEPREFIXMETHOD
            colsc.widthSize.myEqualTo(rowView.widthSize).myMultiply(1.0 / colCount).myAdd(-1 * rowView.subviewHSpace * (colCount - 1.0)/ colCount);
#else
            colsc.widthSize.equalTo(rowView.widthSize).multiply(1.0 / colCount).add(-1 * rowView.subviewHSpace * (colCount - 1.0)/ colCount);
#endif
        }
        else
        {
#ifdef GT_USEPREFIXMETHOD
            colsc.heightSize.myEqualTo(rowView.heightSize).myMultiply(1.0 / colCount).myAdd(-1 * rowView.subviewVSpace * (colCount - 1.0)/ colCount);
#else
            colsc.heightSize.equalTo(rowView.heightSize).multiply(1.0 / colCount).add(-1 * rowView.subviewVSpace * (colCount - 1.0)/ colCount);
#endif
        }

    }
    else if (rowView.colSize > 0)
    {
        if (rowsc.orientation == GTCOrientationHorz)
            colsc.gtc_width = rowView.colSize;
        else
            colsc.gtc_height = rowView.colSize;
    }

    if (rowsc.orientation == GTCOrientationHorz)
    {
        if (CGRectGetHeight(colView.bounds) == 0 && colsc.heightSizeInner.dimeVal == nil)
        {
            if ([colView isKindOfClass:[GTCBaseLayout class]])
            {
                if (!colsc.wrapContentHeight)
                    [colsc.heightSize __equalTo:rowsc.heightSize];
            }
            else
                [colsc.heightSize __equalTo:rowsc.heightSize];
        }
    }
    else
    {
        if (CGRectGetWidth(colView.bounds) == 0 && colsc.widthSizeInner.dimeVal == nil)
        {

            if ([colView isKindOfClass:[GTCBaseLayout class]])
            {
                if (!colsc.wrapContentWidth)
                    [colsc.widthSize __equalTo:rowsc.widthSize];
            }
            else
                [colsc.widthSize __equalTo:rowsc.widthSize];
        }

    }


    [rowView insertSubview:colView atIndex:indexPath.col];
}

-(void)removeColAt:(NSIndexPath*)indexPath
{
    [[self viewAtIndexPath:indexPath] removeFromSuperview];
}

-(void)exchangeColAt:(NSIndexPath*)indexPath1 withCol:(NSIndexPath*)indexPath2
{
    UIView * colView1 = [self viewAtIndexPath:indexPath1];
    UIView * colView2 = [self viewAtIndexPath:indexPath2];

    if (colView1 == colView2)
        return;


    [self removeColAt:indexPath1];
    [self removeColAt:indexPath2];

    [self insertCol:colView1 atIndexPath:indexPath2];
    [self insertCol:colView2 atIndexPath:indexPath1];
}

-(UIView*)viewAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self viewAtRowIndex:indexPath.row].subviews objectAtIndex:indexPath.col];
}

-(NSUInteger)countOfColInRow:(NSInteger)rowIndex
{
    return [self viewAtRowIndex:rowIndex].subviews.count;
}

#pragma mark -- Override Methods


-(void)setSubviewVSpace:(CGFloat)subviewVSpace
{
    [super setSubviewVSpace:subviewVSpace];
    if (self.orientation == GTCOrientationHorz)
    {
        for (NSInteger i  = 0; i < self.countOfRow; i++)
        {
            [self viewAtRowIndex:i].subviewVSpace = subviewVSpace;
        }
    }
}

-(void)setSubviewHSpace:(CGFloat)subviewHSpace
{
    [super setSubviewHSpace:subviewHSpace];
    if (self.orientation == GTCOrientationVert)
    {
        for (NSInteger i  = 0; i < self.countOfRow; i++)
        {
            [self viewAtRowIndex:i].subviewHSpace = subviewHSpace;
        }
    }

}


//不能直接调用如下的函数。
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    NSCAssert(0, @"Constraint exception!! Can't call insertSubview");
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    NSCAssert(0, @"Constraint exception!! Can't call exchangeSubviewAtIndex");
}

- (void)addSubview:(UIView *)view
{
    [self addCol:view atRow:[self countOfRow] - 1];
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    NSCAssert(0, @"Constraint exception!! Can't call insertSubview");
}
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    NSCAssert(0, @"Constraint exception!! Can't call insertSubview");
}


-(id)createSizeClassInstance
{
    return [GTCTableLayoutViewSizeClass new];
}



@end
