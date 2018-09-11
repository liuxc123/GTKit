//
//  GTCGridLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/11.
//

#import "GTCGridLayout.h"
#import "GTCLayoutInner.h"
#import "GTCGridNode.h"

NSString * const kGTCGridTag = @"tag";
NSString * const kGTCGridAction = @"action";
NSString * const kGTCGridActionData = @"action-data";
NSString * const kGTCGridRows = @"rows";
NSString * const kGTCGridCols = @"cols";
NSString * const kGTCGridSize = @"size";
NSString * const kGTCGridPadding = @"padding";
NSString * const kGTCGridSpace = @"space";
NSString * const kGTCGridGravity = @"gravity";
NSString * const kGTCGridPlaceholder = @"placeholder";
NSString * const kGTCGridAnchor = @"anchor";
NSString * const kGTCGridOverlap = @"overlap";
NSString * const kGTCGridTopBorderline = @"top-borderline";
NSString * const kGTCGridBottomBorderline = @"bottom-borderline";
NSString * const kGTCGridLeftBorderline = @"left-borderline";
NSString * const kGTCGridRightBorderline = @"right-borderline";

NSString * const kGTCGridBorderlineColor = @"color";
NSString * const kGTCGridBorderlineThick = @"thick";
NSString * const kGTCGridBorderlineHeadIndent = @"head";
NSString * const kGTCGridBorderlineTailIndent = @"tail";
NSString * const kGTCGridBorderlineOffset = @"offset";
NSString * const kGTCGridBorderlineDash = @"dash";


NSString * const vGTCGridSizeWrap = @"wrap";
NSString * const vGTCGridSizeFill = @"fill";


NSString * const vGTCGridGravityTop = @"top";
NSString * const vGTCGridGravityBottom = @"bottom";
NSString * const vGTCGridGravityLeft = @"left";
NSString * const vGTCGridGravityRight = @"right";
NSString * const vGTCGridGravityLeading = @"leading";
NSString * const vGTCGridGravityTrailing = @"trailing";
NSString * const vGTCGridGravityCenterX = @"centerX";
NSString * const vGTCGridGravityCenterY = @"centerY";
NSString * const vGTCGridGravityWidthFill = @"width";
NSString * const vGTCGridGravityHeightFill = @"height";


//视图组和动作数据
@interface GTCViewGroupAndActionData : NSObject

@property(nonatomic, strong) NSMutableArray *viewGroup;
@property(nonatomic, strong) id actionData;

+(instancetype)viewGroup:(NSArray*)viewGroup actionData:(id)actionData;

@end

@implementation GTCViewGroupAndActionData

-(instancetype)initWithViewGroup:(NSArray*)viewGroup actionData:(id)actionData
{
    self = [self init];
    if (self != nil)
    {
        _viewGroup = [NSMutableArray arrayWithArray:viewGroup];
        _actionData = actionData;
    }

    return self;
}

+(instancetype)viewGroup:(NSArray*)viewGroup actionData:(id)actionData
{
    return [[[self class] alloc] initWithViewGroup:viewGroup actionData:actionData];
}


@end





@interface GTCGridLayout()<GTCGridNode>

@property(nonatomic, weak) GTCGridLayoutViewSizeClass *lastSizeClass;

@property(nonatomic, strong) NSMutableDictionary *tagsDict;
@property(nonatomic, assign) BOOL tagsDictLock;

@end


@implementation GTCGridLayout

-(NSMutableDictionary*)tagsDict
{
    if (_tagsDict == nil)
    {
        _tagsDict = [NSMutableDictionary new];
    }

    return _tagsDict;
}

#pragma mark -- Public Methods

+(id<GTCGrid>)createTemplateGrid:(NSInteger)gridTag
{
    id<GTCGrid> grid  =  [[GTCGridNode alloc] initWithMeasure:0 superGrid:nil];
    grid.tag = gridTag;

    return grid;
}


//删除所有子栅格
-(void)removeGrids
{
    [self removeGridsIn:GTCSizeClasshAny | GTCSizeClasswAny];
}

-(void)removeGridsIn:(GTCSizeClass)sizeClass
{
    id<GTCGridNode> lsc = (id<GTCGridNode>)[self fetchLayoutSizeClass:sizeClass];
    [lsc.subGrids removeAllObjects];
    lsc.subGridsType = GTCSubGridsTypeUnknown;

    [self setNeedsLayout];
}

-(id<GTCGrid>) gridContainsSubview:(UIView*)subview
{
    return [self gridHitTest:subview.center];
}

-(NSArray<UIView*>*) subviewsContainedInGrid:(id<GTCGrid>)grid
{

    id<GTCGridNode> gridNode = (id<GTCGridNode>)grid;

#ifdef DEBUG
    NSAssert([gridNode gridLayoutView] == self, @"oops! 非栅格布局中的栅格");
#endif

    NSMutableArray *retSbs = [NSMutableArray new];
    NSArray *sbs = [self gtcGetLayoutSubviews];
    for (UIView *sbv in sbs)
    {
        if (CGRectContainsRect(gridNode.gridRect, sbv.frame))
        {
            [retSbs addObject:sbv];
        }
    }

    return retSbs;
}


-(void)addViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData to:(NSInteger)gridTag
{
    [self insertViewGroup:viewGroup withActionData:actionData atIndex:(NSUInteger)-1 to:gridTag];
}

-(void)insertViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag
{
    if (gridTag == 0)
    {
        for (UIView *sbv in viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [self addSubview:sbv];
        }

        return;
    }

    //...
    NSNumber *key = @(gridTag);
    NSMutableArray *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil)
    {
        viewGroupArray = [NSMutableArray new];
        [self.tagsDict setObject:viewGroupArray forKey:key];
    }

    GTCViewGroupAndActionData *va = [GTCViewGroupAndActionData viewGroup:viewGroup actionData:actionData];
    if (index == (NSUInteger)-1)
    {
        [viewGroupArray addObject:va];
    }
    else
    {
        [viewGroupArray insertObject:va atIndex:index];
    }

    for (UIView *sbv in viewGroup)
    {
        if (sbv != (UIView*)[NSNull null])
            [self addSubview:sbv];
    }

    [self setNeedsLayout];
}

-(void)replaceViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag
{
    if (gridTag == 0)
    {
        return;
    }

    //...
    NSNumber *key = @(gridTag);
    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil || (index >= viewGroupArray.count))
    {
        [self addViewGroup:viewGroup withActionData:actionData to:gridTag];
        return;
    }


    //这里面有可能有存在的视图， 有可能存在于子视图数组里面，有可能存在于其他视图组里面。
    //如果存在于其他标签则要从其他标签删除。。。
    //而且多余的还要删除。。。这个好复杂啊。。
    //先不考虑这么复杂的情况，只认为替换掉当前索引的视图即可，如果视图本来就在子视图里面则不删除，否则就添加。而被替换掉的则需要删除。
    //每个视图都在老的里面查找，如果找到则处理，如果没有找到
    self.tagsDictLock = YES;

    GTCViewGroupAndActionData *va = viewGroupArray[index];
    va.actionData = actionData;

    if (va.viewGroup != viewGroup)
    {
        for (UIView *sbv in viewGroup)
        {
            NSUInteger oldIndex = [va.viewGroup indexOfObject:sbv];
            if (oldIndex == NSNotFound)
            {
                if (sbv != (UIView*)[NSNull null])
                    [self addSubview:sbv];
            }
            else
            {
                [va.viewGroup removeObjectAtIndex:oldIndex];
            }
        }

        //原来多余的视图删除
        for (UIView *sbv in va.viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [sbv removeFromSuperview];
        }

        //将新的视图组给替换掉。
        [va.viewGroup setArray:viewGroup];
    }

    self.tagsDictLock = NO;


    [self setNeedsLayout];

}


-(void)moveViewGroupAtIndex:(NSUInteger)index from:(NSInteger)origGridTag to:(NSInteger)destGridTag
{
    [self moveViewGroupAtIndex:index from:origGridTag toIndex:-1 to:destGridTag];
}

-(void)moveViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)origGridTag  toIndex:(NSUInteger)index2 to:(NSInteger)destGridTag
{
    if (origGridTag == 0 || destGridTag == 0 || (origGridTag == destGridTag))
        return;

    if (_tagsDict == nil)
        return;

    NSNumber *origKey = @(origGridTag);
    NSMutableArray<GTCViewGroupAndActionData*> *origViewGroupArray = [self.tagsDict objectForKey:origKey];

    if (index1 < origViewGroupArray.count)
    {

        NSNumber *destKey = @(destGridTag);

        NSMutableArray<GTCViewGroupAndActionData*> *destViewGroupArray = [self.tagsDict objectForKey:destKey];
        if (destViewGroupArray == nil)
        {
            destViewGroupArray = [NSMutableArray new];
            [self.tagsDict setObject:destViewGroupArray forKey:destKey];
        }

        if (index2 > destViewGroupArray.count)
            index2 = destViewGroupArray.count;


        GTCViewGroupAndActionData *va = origViewGroupArray[index1];
        [origViewGroupArray removeObjectAtIndex:index1];
        if (origViewGroupArray.count == 0)
        {
            [self.tagsDict removeObjectForKey:origKey];
        }

        [destViewGroupArray insertObject:va atIndex:index2];


    }

    [self setNeedsLayout];

}



-(void)removeViewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag
{
    if (gridTag == 0)
        return;

    if (_tagsDict == nil)
        return;

    NSNumber *key = @(gridTag);
    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count)
    {
        GTCViewGroupAndActionData *va = viewGroupArray[index];

        self.tagsDictLock = YES;
        for (UIView *sbv in va.viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [sbv removeFromSuperview];
        }
        self.tagsDictLock = NO;


        [viewGroupArray removeObjectAtIndex:index];

        if (viewGroupArray.count == 0)
        {
            [self.tagsDict removeObjectForKey:key];
        }

    }

    [self setNeedsLayout];
}



-(void)removeViewGroupFrom:(NSInteger)gridTag
{
    if (gridTag == 0)
        return;

    if (_tagsDict == nil)
        return;

    NSNumber *key = @(gridTag);
    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray != nil)
    {
        self.tagsDictLock = YES;
        for (GTCViewGroupAndActionData * va in viewGroupArray)
        {
            for (UIView *sbv in va.viewGroup)
            {
                if (sbv != (UIView*)[NSNull null])
                    [sbv removeFromSuperview];
            }
        }

        self.tagsDictLock = NO;

        [self.tagsDict removeObjectForKey:key];
    }

    [self setNeedsLayout];

}



-(void)exchangeViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)gridTag1  withViewGroupAtIndex:(NSUInteger)index2 from:(NSInteger)gridTag2
{
    if (gridTag1 == 0 || gridTag2 == 0)
        return;

    NSNumber *key1 = @(gridTag1);
    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray1 = [self.tagsDict objectForKey:key1];

    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray2 = nil;

    if (gridTag1 == gridTag2)
    {
        viewGroupArray2 = viewGroupArray1;
        if (index1 == index2)
            return;
    }
    else
    {
        NSNumber *key2 = @(gridTag2);
        viewGroupArray2 = [self.tagsDict objectForKey:key2];
    }

    if (index1 < viewGroupArray1.count && index2 < viewGroupArray2.count)
    {
        self.tagsDictLock = YES;

        if (gridTag1 == gridTag2)
        {
            [viewGroupArray1 exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        }
        else
        {
            GTCViewGroupAndActionData *va1 = viewGroupArray1[index1];
            GTCViewGroupAndActionData *va2 = viewGroupArray2[index2];

            [viewGroupArray1 removeObjectAtIndex:index1];
            [viewGroupArray2 removeObjectAtIndex:index2];

            [viewGroupArray1 insertObject:va2 atIndex:index1];
            [viewGroupArray2 insertObject:va1 atIndex:index2];
        }


        self.tagsDictLock = NO;


    }

    [self setNeedsLayout];

}


-(NSUInteger)viewGroupCountOf:(NSInteger)gridTag
{
    if (gridTag == 0)
        return 0;

    if (_tagsDict == nil)
        return 0;

    NSNumber *key = @(gridTag);
    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];

    return viewGroupArray.count;
}



-(NSArray<UIView*> *)viewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag
{
    if (gridTag == 0)
        return nil;

    if (_tagsDict == nil)
        return nil;


    NSNumber *key = @(gridTag);
    NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count)
    {
        return viewGroupArray[index].viewGroup;
    }

    return nil;
}








#pragma mark -- GTCGrid

-(id)actionData
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return lsc.actionData;
}

-(void)setActionData:(id)actionData
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.actionData = actionData;
}

//添加行。返回新的栅格。
-(id<GTCGrid>)addRow:(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    id<GTCGridNode> node = (id<GTCGridNode>)[lsc addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列。返回新的栅格。
-(id<GTCGrid>)addCol:(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    id<GTCGridNode> node = (id<GTCGridNode>)[lsc addCol:measure];
    node.superGrid = self;
    return node;
}

-(id<GTCGrid>)addRowGrid:(id<GTCGrid>)grid
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    id<GTCGridNode> node = (id<GTCGridNode>)[lsc addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTCGrid>)addColGrid:(id<GTCGrid>)grid
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    id<GTCGridNode> node = (id<GTCGridNode>)[lsc addColGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTCGrid>)addRowGrid:(id<GTCGrid>)grid measure:(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    id<GTCGridNode> node = (id<GTCGridNode>)[lsc addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;

}

-(id<GTCGrid>)addColGrid:(id<GTCGrid>)grid measure:(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    id<GTCGridNode> node = (id<GTCGridNode>)[lsc addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;

}



-(id<GTCGrid>)cloneGrid
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return [lsc cloneGrid];
}

-(void)removeFromSuperGrid
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return [lsc removeFromSuperGrid];

}

-(id<GTCGrid>)superGrid
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;

    return lsc.superGrid;
}

-(void)setSuperGrid:(id<GTCGridNode>)superGrid
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.superGrid = superGrid;
}

-(BOOL)placeholder
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;

    return lsc.placeholder;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.placeholder = placeholder;
}


-(BOOL)anchor
{

    GTCGridLayout *lsc = self.gtcCurrentSizeClass;

    return lsc.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.anchor = anchor;
}

-(GTCGravity)overlap
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;

    return lsc.overlap;
}

-(void)setOverlap:(GTCGravity)overlap
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.overlap = overlap;
}

-(NSDictionary*)gridDictionary
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return lsc.gridDictionary;
}


-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.gridDictionary = gridDictionary;
}


#pragma mark -- GTCGridNode


-(NSMutableArray<id<GTCGridNode>> *)subGrids
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return (NSMutableArray<id<GTCGridNode>> *)(lsc.subGrids);
}

-(void)setSubGrids:(NSMutableArray<id<GTCGridNode>> *)subGrids
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.subGrids = subGrids;
}

-(GTCSubGridsType)subGridsType
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;

    return lsc.subGridsType;
}

-(void)setSubGridsType:(GTCSubGridsType)subGridsType
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.subGridsType = subGridsType;
}


-(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return lsc.measure;
}

-(void)setMeasure:(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.measure = measure;
}

-(CGRect)gridRect
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return lsc.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    lsc.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<GTCGridNode>)superGrid withMeasure:(CGFloat)measure
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return [lsc updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<GTCGridNode>)superGrid withOffset:(CGFloat)offset
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;

    return [lsc updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}



-(UIView*)gridLayoutView
{
    return self;
}

-(SEL)gridAction
{
    return nil;
}

-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    [lsc setBorderlineNeedLayoutIn:rect withLayer:layer];

}

-(void)showBorderline:(BOOL)show
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    [lsc showBorderline:show];

}

-(id<GTCGrid>)gridHitTest:(CGPoint)point
{
    GTCGridLayout *lsc = self.gtcCurrentSizeClass;
    return [lsc gridHitTest:point];
}


#pragma mark -- Touches Event

-(id<GTCGridNode>)gtcBestHitGrid:(NSSet *)touches
{
    GTCSizeClass sizeClass = [self gtcGetGlobalSizeClass];
    id<GTCGridNode> bestSC = (id<GTCGridNode>)[self gtcBestSizeClass:sizeClass];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return  [bestSC gridHitTest:point];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [[self gtcBestHitGrid:touches] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gtcBestHitGrid:touches] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gtcBestHitGrid:touches] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gtcBestHitGrid:touches] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- Override Methods

-(void)dealloc
{
    //这里提前释放所有的数据，防止willRemoveSubview中重复删除。。
    _tagsDict = nil;
}

-(void)removeAllSubviews
{
    _tagsDict = nil;  //提前释放所有绑定的数据
    [super removeAllSubviews];
}

-(void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];

    //如果子试图在样式里面则从样式里面删除
    if (_tagsDict != nil && !self.tagsDictLock)
    {
        [_tagsDict enumerateKeysAndObjectsUsingBlock:^(id   key, id   obj, BOOL *  stop) {

            NSMutableArray *viewGroupArray = (NSMutableArray*)obj;
            NSInteger sbsCount = viewGroupArray.count;
            for (NSInteger j = 0; j < sbsCount; j++)
            {
                GTCViewGroupAndActionData *va = viewGroupArray[j];
                NSInteger sbvCount = va.viewGroup.count;
                for (NSInteger i = 0; i < sbvCount; i++)
                {
                    if (va.viewGroup[i] == subview)
                    {
                        [va.viewGroup removeObjectAtIndex:i];
                        break;
                        *stop = YES;
                    }
                }

                if (va.viewGroup.count == 0)
                {
                    [viewGroupArray removeObjectAtIndex:j];
                    break;
                }

                if (*stop)
                    break;
            }


        }];
    }
}


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTCSizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];

    if (sbs == nil)
        sbs = [self gtcGetLayoutSubviews];


    GTCFrame *gtcFrame = self.gtcFrame;

    GTCGridLayout *lsc =  [self gtcCurrentSizeClassFrom:gtcFrame];

    //只有在非评估，并且当sizeclass的数量大于1个，并且当前的sizeclass和lastSizeClass不一致的时候
    if (!isEstimate && gtcFrame.multiple)
    {
        //将子栅格中的layer隐藏。
        if (self.lastSizeClass != nil && ((GTCGridLayoutViewSizeClass*)lsc) != self.lastSizeClass)
            [((id<GTCGridNode>)self.lastSizeClass) showBorderline:NO];

        self.lastSizeClass = (GTCGridLayoutViewSizeClass*)lsc;
    }


    //设置根格子的rect为布局视图的大小。
    lsc.gridRect = CGRectMake(0, 0, selfSize.width, selfSize.height);


    NSMutableDictionary *tagKeyIndexDict = [NSMutableDictionary dictionaryWithCapacity:self.tagsDict.count];
    for (NSNumber *key in self.tagsDict)
    {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }

    //遍历尺寸
    NSInteger index = 0;
    CGFloat selfMeasure = [self gtcTraversalGridSize:lsc gridSize:selfSize lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagKeyIndexDict tagViewGroup:nil pTagIndex:nil];
    if (lsc.wrapContentHeight)
    {
        selfSize.height =  selfMeasure;
    }

    if (lsc.wrapContentWidth)
    {
        selfSize.width = selfMeasure;
    }

    //遍历位置。
    for (NSNumber *key in self.tagsDict)
    {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }

    NSEnumerator<UIView*> *enumerator = sbs.objectEnumerator;
    [self gtcTraversalGridOrigin:lsc gridOrigin:CGPointMake(0, 0) lsc:lsc sbvEnumerator:enumerator tagViewGroupIndexDict:tagKeyIndexDict tagSbvEnumerator:nil  isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];


    //遍历那些还剩余的然后设置为0.
    [tagKeyIndexDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *viewGroupIndexNumber, BOOL *  stop) {

        NSArray<GTCViewGroupAndActionData*> *viewGroupArray = self.tagsDict[key];
        NSInteger viewGroupIndex = viewGroupIndexNumber.integerValue;
        for (NSInteger i = viewGroupIndex; i < viewGroupArray.count; i++)
        {
            GTCViewGroupAndActionData *va = viewGroupArray[i];
            for (UIView *sbv in va.viewGroup)
            {
                if (sbv != (UIView*)[NSNull null])
                {
                    sbv.gtcFrame.frame = CGRectZero;

                    //这里面让所有视图的枚举器也走一遍，解决下面的重复设置的问题。
                    UIView *anyway = enumerator.nextObject;
                    anyway = nil;  //防止有anyway编译告警而设置。
                }
            }
        }
    }];


    //处理那些剩余没有放入格子的子视图的frame设置为0
    for (UIView *sbv = enumerator.nextObject; sbv; sbv = enumerator.nextObject)
    {
        sbv.gtcFrame.frame = CGRectZero;
    }


    [self gtcAdjustLayoutSelfSize:&selfSize lsc:lsc];

    //对所有子视图进行布局变换
    [self gtcAdjustSubviewsLayoutTransform:sbs lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtcAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];

    return [self gtcAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [GTCGridLayoutViewSizeClass new];
}

#pragma mark -- Private Methods

//遍历位置
-(void)gtcTraversalGridOrigin:(id<GTCGridNode>)grid  gridOrigin:(CGPoint)gridOrigin lsc:(GTCGridLayout*)lsc sbvEnumerator:(NSEnumerator<UIView*>*)sbvEnumerator tagViewGroupIndexDict:(NSMutableDictionary*)tagViewGroupIndexDict tagSbvEnumerator:(NSEnumerator<UIView*>*)tagSbvEnumerator isEstimate:(BOOL)isEstimate sizeClass:(GTCSizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout
{
    //这要优化减少不必要的空数组的建立。。
    NSArray<id<GTCGridNode>> * subGrids = nil;
    if (grid.subGridsType != GTCSubGridsTypeUnknown)
        subGrids = grid.subGrids;

    //绘制边界线。。
    if (!isEstimate)
    {
        [grid setBorderlineNeedLayoutIn:grid.gridRect withLayer:self.layer];
    }


    if (grid.tag != 0)
    {
        NSNumber *key = @(grid.tag);

        NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil)
        {
            if (viewGroupIndex.integerValue < viewGroupArray.count)
            {
                //这里将动作的数据和栅格进行关联。
                grid.actionData = viewGroupArray[viewGroupIndex.integerValue].actionData;

                tagSbvEnumerator =  viewGroupArray[viewGroupIndex.integerValue].viewGroup.objectEnumerator;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            }
            else
            {
                grid.actionData = nil;
                tagSbvEnumerator = nil;
                sbvEnumerator = nil;
            }
        }
        else
        {
            tagSbvEnumerator = nil;
        }
    }

    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == lsc)
    {
        paddingTop = lsc.gtcLayoutTopPadding;
        paddingLeading = lsc.gtcLayoutLeadingPadding;
        paddingBottom = lsc.gtcLayoutBottomPadding;
        paddingTrailing = lsc.gtcLayoutTrailingPadding;
    }
    else
    {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [GTCBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [GTCBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }

    //处理叶子节点。
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        //设置子视图的位置和尺寸。。
        UIView *sbv = nil;
        UIView *tagSbv = tagSbvEnumerator.nextObject;

        if (tagSbv != (UIView*)[NSNull null])
            sbv = sbvEnumerator.nextObject;

        if (tagSbv != nil && tagSbv != (UIView*)[NSNull null] && tagSbvEnumerator != nil)
            sbv = tagSbv;

        if (sbv != nil)
        {
            //调整位置和尺寸。。。
            GTCFrame *sbvFrame = sbv.gtcFrame;

            UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];

            //取垂直和水平对齐
            GTCGravity vertGravity = grid.gravity & GTCGravityHorzMask;
            if (vertGravity == GTCGravityNone)
                vertGravity = GTCGravityVertFill;

            GTCGravity horzGravity = grid.gravity & GTCGravityVertMask;
            if (horzGravity == GTCGravityNone)
                horzGravity = GTCGravityHorzFill;
            else
                horzGravity = [self gtcConvertLeftRightGravityToLeadingTrailing:horzGravity];


            //如果非叶子栅格设置为anchor则子视图的内容总是填充的
            CGFloat tempPaddingTop = paddingTop;
            CGFloat tempPaddingLeading = paddingLeading;
            CGFloat tempPaddingBottom = paddingBottom;
            CGFloat tempPaddingTrailing = paddingTrailing;

            if (grid.anchor && subGrids.count > 0)
            {
                vertGravity = GTCGravityVertFill;
                horzGravity = GTCGravityHorzFill;
                tempPaddingTop = 0;
                tempPaddingLeading = 0;
                tempPaddingBottom = 0;
                tempPaddingTrailing = 0;
            }

            //如果是尺寸为0，并且设置为了anchor的话那么就根据自身

            //如果尺寸是0则因为前面有算出尺寸，所以这里就不进行调整了。
            if (grid.measure != 0 && [sbv isKindOfClass:[GTCBaseLayout class]])
            {
                [self gtcAdjustSubviewWrapContentSet:sbv isEstimate:isEstimate sbvFrame:sbvFrame sbvsc:sbvsc selfSize:grid.gridRect.size sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
            }
            else
            {
            }

            [self gtcCalcSubViewRect:sbv sbvsc:sbvsc sbvFrame:sbvFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:grid.gridRect.size paddingTop:tempPaddingTop paddingLeading:tempPaddingLeading paddingBottom:tempPaddingBottom paddingTrailing:tempPaddingTrailing pMaxWrapSize:NULL];

            sbvFrame.leading += gridOrigin.x;
            sbvFrame.top += gridOrigin.y;

        }
    }



    //处理子格子的位置。

    CGFloat offset = 0;
    if (grid.subGridsType == GTCSubGridsTypeCol)
    {
        offset = gridOrigin.x + paddingLeading;

        GTCGravity horzGravity = [self gtcConvertLeftRightGravityToLeadingTrailing:grid.gravity & GTCGravityVertMask];
        if (horzGravity == GTCGravityHorzCenter || horzGravity == GTCGravityHorzTrailing)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsWidth = 0;
            for (id<GTCGridNode> sbvGrid in subGrids)
            {
                subGridsWidth += sbvGrid.gridRect.size.width;
            }

            if (subGrids.count > 1)
                subGridsWidth += grid.subviewSpace * (subGrids.count - 1);


            if (horzGravity == GTCGravityHorzCenter)
            {
                offset += (grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth)/2;
            }
            else
            {
                offset += grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth;
            }
        }


    }
    else if (grid.subGridsType == GTCSubGridsTypeRow)
    {
        offset = gridOrigin.y + paddingTop;

        GTCGravity vertGravity = grid.gravity & GTCGravityHorzMask;
        if (vertGravity == GTCGravityVertCenter || vertGravity == GTCGravityVertBottom)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsHeight = 0;
            for (id<GTCGridNode> sbvGrid in subGrids)
            {
                subGridsHeight += sbvGrid.gridRect.size.height;
            }

            if (subGrids.count > 1)
                subGridsHeight += grid.subviewSpace * (subGrids.count - 1);

            if (vertGravity == GTCGravityVertCenter)
            {
                offset += (grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight)/2;
            }
            else
            {
                offset += grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight;
            }
        }

    }
    else
    {

    }



    CGPoint paddingGridOrigin = CGPointMake(gridOrigin.x + paddingLeading, gridOrigin.y + paddingTop);
    for (id<GTCGridNode> sbvGrid in subGrids)
    {
        offset += [sbvGrid updateGridOrigin:paddingGridOrigin superGrid:grid withOffset:offset];
        offset += grid.subviewSpace;
        [self gtcTraversalGridOrigin:sbvGrid gridOrigin:sbvGrid.gridRect.origin lsc:lsc sbvEnumerator:sbvEnumerator tagViewGroupIndexDict:tagViewGroupIndexDict tagSbvEnumerator:((sbvGrid.tag != 0)? nil: tagSbvEnumerator) isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    }

    //如果栅格中的tagSbvEnumerator还有剩余的视图没有地方可填，那么就将尺寸和位置设置为0
    if (grid.tag != 0)
    {
        //枚举那些剩余的
        for (UIView *sbv = tagSbvEnumerator.nextObject; sbv; sbv = tagSbvEnumerator.nextObject)
        {
            if (sbv != (UIView*)[NSNull null])
            {
                sbv.gtcFrame.frame = CGRectZero;

                //所有子视图枚举器也要移动。
                UIView *anyway = sbvEnumerator.nextObject;
                anyway = nil;
            }
        }
    }

}

-(void)gtcBlankTraverse:(id<GTCGridNode>)grid sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex tagSbs:(NSArray<UIView*> *)tagSbs pTagIndex:(NSInteger*)pTagIndex
{
    NSArray<id<GTCGridNode>> *subGrids = nil;
    if (grid.subGridsType != GTCSubGridsTypeUnknown)
        subGrids = grid.subGrids;

    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        BOOL isNoNullSbv = YES;
        if (grid.tag == 0 && pTagIndex != NULL)
        {
            *pTagIndex = *pTagIndex + 1;

            if (tagSbs != nil && *pTagIndex < tagSbs.count && tagSbs[*pTagIndex] == (UIView*)[NSNull null])
                isNoNullSbv = NO;
        }

        if (isNoNullSbv)
            *pIndex = *pIndex + 1;

    }

    for (id<GTCGridNode> sbvGrid in subGrids)
    {
        [self gtcBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagSbs pTagIndex:(grid.tag != 0)? NULL : pTagIndex];
    }
}

//遍历尺寸。
-(CGFloat)gtcTraversalGridSize:(id<GTCGridNode>)grid gridSize:(CGSize)gridSize lsc:(GTCGridLayout*)lsc sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex tagViewGroupIndexDict:(NSMutableDictionary*)tagViewGroupIndexDict  tagViewGroup:(NSArray<UIView*>*)tagViewGroup  pTagIndex:(NSInteger*)pTagIndex
{
    NSArray<id<GTCGridNode>> *subGrids = nil;
    if (grid.subGridsType != GTCSubGridsTypeUnknown)
        subGrids = grid.subGrids;


    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == lsc)
    {
        paddingTop = lsc.gtcLayoutTopPadding;
        paddingLeading = lsc.gtcLayoutLeadingPadding;
        paddingBottom = lsc.gtcLayoutBottomPadding;
        paddingTrailing = lsc.gtcLayoutTrailingPadding;
    }
    else
    {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [GTCBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [GTCBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }

    CGFloat fixedMeasure = 0;  //固定部分的尺寸
    CGFloat validMeasure = 0;  //整体有效的尺寸
    if (subGrids.count > 1)
        fixedMeasure += (subGrids.count - 1) * grid.subviewSpace;

    if (grid.subGridsType == GTCSubGridsTypeCol)
    {
        fixedMeasure += paddingLeading + paddingTrailing;
        validMeasure = grid.gridRect.size.width - fixedMeasure;
    }
    else if(grid.subGridsType == GTCSubGridsTypeRow)
    {
        fixedMeasure += paddingTop + paddingBottom;
        validMeasure = grid.gridRect.size.height - fixedMeasure;
    }
    else;


    //得到匹配的form
    if (grid.tag != 0)
    {
        NSNumber *key = @(grid.tag);
        NSMutableArray<GTCViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil)
        {
            if (viewGroupIndex.integerValue < viewGroupArray.count)
            {
                tagViewGroup = viewGroupArray[viewGroupIndex.integerValue].viewGroup;
                NSInteger tagIndex = 0;
                pTagIndex = &tagIndex;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            }
            else
            {
                tagViewGroup = nil;
                pTagIndex = NULL;
                sbs = nil;
            }
        }
        else
        {
            tagViewGroup = nil;
            pTagIndex = NULL;
        }
    }


    //叶子节点
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        BOOL isNotNullSbv = YES;
        NSArray *tempSbs = sbs;
        NSInteger *pTempIndex = pIndex;

        if (tagViewGroup != nil && pTagIndex != NULL)
        {
            tempSbs = tagViewGroup;
            pTempIndex = pTagIndex;
        }

        //如果尺寸是包裹
        if (grid.measure == GTCLayoutSize.wrap ||  (grid.measure == 0 && grid.anchor))
        {
            if (*pTempIndex < tempSbs.count)
            {
                //加这个条件是根栅格如果是叶子栅格的话不处理这种情况。
                if (grid.superGrid != nil)
                {
                    UIView *sbv = tempSbs[*pTempIndex];
                    if (sbv != (UIView*)[NSNull null])
                    {

                        //叶子节点
                        if (!grid.anchor || (grid.measure == 0 && grid.anchor))
                        {
                            GTCFrame *sbvFrame = sbv.gtcFrame;
                            UIView *sbvsc = [self gtcCurrentSizeClassFrom:sbvFrame];
                            sbvFrame.frame = sbv.bounds;

                            //如果子视图不设置任何约束但是又是包裹的则这里特殊处理。
                            if (sbvsc.widthSizeInner == nil && sbvsc.heightSizeInner == nil && !sbvsc.wrapContentSize)
                            {
                                CGSize size = CGSizeZero;
                                if (grid.superGrid.subGridsType == GTCSubGridsTypeRow)
                                {
                                    size.width = gridSize.width - paddingLeading - paddingTrailing;
                                }
                                else
                                {
                                    size.height = gridSize.height - paddingTop - paddingBottom;
                                }

                                size = [sbv sizeThatFits:size];
                                sbvFrame.width = size.width;
                                sbvFrame.height = size.height;
                            }
                            else
                            {

                                [self gtcCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvFrame:sbvFrame];

                                [self gtcCalcSubViewRect:sbv sbvsc:sbvsc sbvFrame:sbvFrame lsc:lsc vertGravity:GTCGravityNone horzGravity:GTCGravityNone inSelfSize:grid.gridRect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
                            }

                            if (grid.superGrid.subGridsType == GTCSubGridsTypeRow)
                            {
                                fixedMeasure = paddingTop + paddingBottom + sbvFrame.height;
                            }
                            else
                            {
                                fixedMeasure = paddingLeading + paddingTrailing + sbvFrame.width;
                            }
                        }
                    }
                    else
                        isNotNullSbv = NO;
                }
            }
        }

        //索引加1跳转到下一个节点。
        if (tagViewGroup != nil &&  pTagIndex != NULL)
        {
            *pTempIndex = *pTempIndex + 1;
        }

        if (isNotNullSbv)
            *pIndex = *pIndex + 1;
    }


    if (subGrids.count > 0)
    {

        NSMutableArray<id<GTCGridNode>> *weightSubGrids = [NSMutableArray new];  //比重尺寸子格子数组
        NSMutableArray<NSNumber*> *weightSubGridsIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber*> *weightSubGridsTagIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引


        NSMutableArray<id<GTCGridNode>> *fillSubGrids = [NSMutableArray new];    //填充尺寸格子数组
        NSMutableArray<NSNumber*> *fillSubGridsIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber*> *fillSubGridsTagIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引


        //包裹尺寸先遍历所有子格子
        CGSize gridSize2 = gridSize;
        if (grid.subGridsType == GTCSubGridsTypeRow)
        {
            gridSize2.width -= (paddingLeading + paddingTrailing);
        }
        else
        {
            gridSize2.height -= (paddingTop + paddingBottom);
        }

        for (id<GTCGridNode> sbvGrid in subGrids)
        {
            if (sbvGrid.measure == GTCLayoutSize.wrap)
            {

                CGFloat measure = [self gtcTraversalGridSize:sbvGrid gridSize:gridSize2 lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid  withMeasure:measure];

            }
            else if (sbvGrid.measure >= 1 || sbvGrid.measure == 0)
            {
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:sbvGrid.measure];

                //遍历儿子节点。。
                [self gtcTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];

            }
            else if (sbvGrid.measure > 0 && sbvGrid.measure < 1)
            {
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:validMeasure * sbvGrid.measure];

                //遍历儿子节点。。
                [self gtcTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];

            }
            else if (sbvGrid.measure < 0 && sbvGrid.measure > -1)
            {
                [weightSubGrids addObject:sbvGrid];
                [weightSubGridsIndexs addObject:@(*pIndex)];

                if (pTagIndex != NULL)
                {
                    [weightSubGridsTagIndexs addObject:@(*pTagIndex)];
                }

                //这里面空转一下。
                [self gtcBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];


            }
            else if (sbvGrid.measure == GTCLayoutSize.fill)
            {
                [fillSubGrids addObject:sbvGrid];

                [fillSubGridsIndexs addObject:@(*pIndex)];

                if (pTagIndex != NULL)
                {
                    [fillSubGridsTagIndexs addObject:@(*pTagIndex)];
                }

                //这里面空转一下。
                [self gtcBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];
            }
            else
            {
                NSAssert(0, @"oops!");
            }
        }


        //算出剩余的尺寸。
        BOOL hasTagIndex = (pTagIndex != NULL);
        CGFloat remainedMeasure = 0;
        if (grid.subGridsType == GTCSubGridsTypeCol)
        {
            remainedMeasure = grid.gridRect.size.width - fixedMeasure;
        }
        else if (grid.subGridsType == GTCSubGridsTypeRow)
        {
            remainedMeasure = grid.gridRect.size.height - fixedMeasure;
        }
        else;

        NSInteger weightSubGridCount = weightSubGrids.count;
        if (weightSubGridCount > 0)
        {
            for (NSInteger i = 0; i < weightSubGridCount; i++)
            {
                id<GTCGridNode> sbvGrid = weightSubGrids[i];
                remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:-1 * remainedMeasure * sbvGrid.measure];

                NSInteger index = weightSubGridsIndexs[i].integerValue;
                if (hasTagIndex)
                {
                    NSInteger tagIndex = weightSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                }
                else
                {
                    pTagIndex = NULL;
                }

                [self gtcTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
            }
        }

        NSInteger fillSubGridsCount = fillSubGrids.count;
        if (fillSubGridsCount > 0)
        {
            NSInteger totalCount = fillSubGridsCount;
            for (NSInteger i = 0; i < fillSubGridsCount; i++)
            {
                id<GTCGridNode> sbvGrid = fillSubGrids[i];
                remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:_gtcCGFloatRound(remainedMeasure * (1.0/totalCount))];
                totalCount -= 1;

                NSInteger index = fillSubGridsIndexs[i].integerValue;

                if (hasTagIndex)
                {
                    NSInteger tagIndex = fillSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                }
                else
                {
                    pTagIndex = nil;
                }

                [self gtcTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
            }
        }
    }
    return fixedMeasure;
}


@end

