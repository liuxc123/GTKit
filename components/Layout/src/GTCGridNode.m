//
//  GTCGridNode.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/11.
//

#import "GTCGridNode.h"
#import "GTCLayoutDelegate.h"
#import "GTCBaseLayout.h"
#import "GTCGridLayout.h"

/////////////////////////////////////////////////////////////////////////////////////////////



/**
 为支持栅格触摸而建立的触摸委托派生类。
 */
@interface GTCGridNodeTouchEventDelegate : GTCTouchEventDelegate

@property(nonatomic, weak) id<GTCGridNode> grid;
@property(nonatomic, weak) CALayer *gridLayer;

@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, strong) id actionData;

-(instancetype)initWithLayout:(GTCBaseLayout*)layout grid:(id<GTCGridNode>)grid;

@end


@implementation GTCGridNodeTouchEventDelegate

-(instancetype)initWithLayout:(GTCBaseLayout*)layout grid:(id<GTCGridNode>)grid
{
    self = [super initWithLayout:layout];
    if (self != nil)
    {
        _grid = grid;
    }

    return self;
}


-(void)mySetTouchHighlighted
{
    //如果有高亮则建立一个高亮子层。
    if (self.layout.highlightedBackgroundColor != nil)
    {
        if (self.gridLayer == nil)
        {
            CALayer *layer = [[CALayer alloc] init];
            layer.zPosition = -1;
            [self.layout.layer addSublayer:layer];
            self.gridLayer = layer;
        }
        self.gridLayer.frame = self.grid.gridRect;
        self.gridLayer.backgroundColor = self.layout.highlightedBackgroundColor.CGColor;
    }
}

-(void)myResetTouchHighlighted
{
    //恢复高亮，删除子图层
    if (self.gridLayer != nil)
    {
        [self.gridLayer removeFromSuperlayer];
    }
    self.gridLayer = nil;
}

-(id)myActionSender
{
    return _grid;
}

-(void)dealloc
{
    [self myResetTouchHighlighted];
}


@end



typedef struct _GTCGridOptionalProperties1
{
    uint32_t subGridType:2;
    uint32_t gravity:16;
    uint32_t placeholder:1;
    uint32_t anchor:1;

}GTCGridOptionalProperties1;


/**
 为节省栅格的内存而构建的可选属性列表1:子栅格间距，栅格内边距，停靠方式。
 */
typedef struct  _GTCGridOptionalProperties2
{
    //格子内子栅格的间距
    CGFloat subviewSpace;
    //格子内视图的内边距。
    UIEdgeInsets padding;
    //格子内子视图的对齐停靠方式。
}GTCGridOptionalProperties2;


@interface GTCGridNode()

@property(nonatomic, assign) GTCGridOptionalProperties1 optionalProperties1;
@property(nonatomic, assign) GTCGridOptionalProperties2 *optionalProperties2;
@property(nonatomic, strong) GTCBorderlineLayerDelegate *borderlineLayerDelegate;
@property(nonatomic, strong) GTCGridNodeTouchEventDelegate *touchEventDelegate;


@end


@implementation GTCGridNode

-(instancetype)initWithMeasure:(CGFloat)measure superGrid:(id<GTCGridNode>)superGrid
{
    self = [self init];
    if (self != nil)
    {
        _measure = measure;
        _subGrids = nil;
        _gridRect = CGRectZero;
        _superGrid = superGrid;
        _optionalProperties2 = NULL;
        _borderlineLayerDelegate = nil;
        _touchEventDelegate = nil;
        memset(&_optionalProperties1, 0, sizeof(GTCGridOptionalProperties1));
    }

    return self;
}

-(GTCGridOptionalProperties2*)optionalProperties2
{
    if (_optionalProperties2 == NULL)
    {
        _optionalProperties2 = (GTCGridOptionalProperties2*)malloc(sizeof(GTCGridOptionalProperties2));
        memset(_optionalProperties2, 0, sizeof(GTCGridOptionalProperties2));
    }

    return _optionalProperties2;
}

-(void)dealloc
{
    if (_optionalProperties2 != NULL)
        free(_optionalProperties2);
    _optionalProperties2 = NULL;
}

#pragma mark -- GTCGridAction

-(NSInteger)tag
{
    return _touchEventDelegate.tag;
}

-(void)setTag:(NSInteger)tag
{

    if (_touchEventDelegate == nil && tag != 0)
    {
        _touchEventDelegate =  [[GTCGridNodeTouchEventDelegate alloc] initWithLayout:(GTCBaseLayout*)[self gridLayoutView] grid:self];
    }

    _touchEventDelegate.tag = tag;
}

-(id)actionData
{
    return _touchEventDelegate.actionData;
}

- (NSString *)action
{
    return NSStringFromSelector(_touchEventDelegate.action);
}

-(void)setActionData:(id)actionData
{
    if (_touchEventDelegate == nil && actionData != nil)
    {
        _touchEventDelegate =  [[GTCGridNodeTouchEventDelegate alloc] initWithLayout:(GTCBaseLayout*)[self gridLayoutView] grid:self];
    }

    _touchEventDelegate.actionData = actionData;
}


-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil && target != nil)
    {
        _touchEventDelegate = [[GTCGridNodeTouchEventDelegate alloc] initWithLayout:(GTCBaseLayout*)[self gridLayoutView] grid:self];
    }

    [_touchEventDelegate setTarget:target action:action];

    //  if (target == nil)
    //    _touchEventDelegate = nil;
}


- (NSDictionary *)gridDictionary
{
    return [GTCGridNode translateGridNode:self toGridDictionary:
            [NSMutableDictionary new]];
}

- (void)setGridDictionary:(NSDictionary *)gridDictionary
{
    [_subGrids removeAllObjects];
    self.subGridsType = GTCSubGridsTypeUnknown;
    if (gridDictionary == nil)
        return;

    [GTCGridNode translateGridDicionary:gridDictionary toGridNode:self];
}




#pragma mark -- GTCGrid

-(GTCSubGridsType)subGridsType
{
    return (GTCSubGridsType)_optionalProperties1.subGridType;
}

-(void)setSubGridsType:(GTCSubGridsType)subGridsType
{
    _optionalProperties1.subGridType = subGridsType;
}


-(GTCGravity)gravity
{
    return (GTCGravity)_optionalProperties1.gravity;
}

-(void)setGravity:(GTCGravity)gravity
{
    _optionalProperties1.gravity = gravity;
}


-(BOOL)placeholder
{
    return _optionalProperties1.placeholder == 1;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    _optionalProperties1.placeholder = placeholder ? 1 : 0;
}

-(BOOL)anchor
{
    return _optionalProperties1.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    _optionalProperties1.anchor = anchor ? 1 : 0;
}

-(GTCGravity)overlap
{
    return self.gravity;
}

-(void)setOverlap:(GTCGravity)overlap
{
    self.anchor = YES;
    self.measure = 0;
    self.gravity = overlap;
}



-(id<GTCGrid>)addRow:(CGFloat)measure
{
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTCSubGridsTypeCol)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }

    GTCGridNode *rowGrid = [[GTCGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = GTCSubGridsTypeRow;
    [self.subGrids addObject:rowGrid];
    return rowGrid;
}

-(id<GTCGrid>)addCol:(CGFloat)measure
{
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTCSubGridsTypeRow)
    {
        NSAssert(0, @"oops! 当前的子格子是行格子，不能再添加列格子。");
    }

    GTCGridNode *colGrid = [[GTCGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = GTCSubGridsTypeCol;
    [self.subGrids addObject:colGrid];
    return colGrid;
}

-(id<GTCGrid>)addRowGrid:(id<GTCGrid>)grid
{
    NSAssert(grid.superGrid == nil, @"oops!");

    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTCSubGridsTypeCol)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }

    self.subGridsType = GTCSubGridsTypeRow;
    [self.subGrids addObject:(id<GTCGridNode>)grid];
    ((GTCGridNode*)grid).superGrid = self;
    return grid;
}

-(id<GTCGrid>)addColGrid:(id<GTCGrid>)grid
{
    NSAssert(grid.superGrid == nil, @"oops!");

    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTCSubGridsTypeRow)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }

    self.subGridsType = GTCSubGridsTypeCol;
    [self.subGrids addObject:(id<GTCGridNode>)grid];
    ((GTCGridNode*)grid).superGrid = self;
    return grid;

}

-(id<GTCGrid>)addRowGrid:(id<GTCGrid>)grid measure:(CGFloat)measure
{
    id<GTCGridNode> gridNode =  (id<GTCGridNode>)[self addRowGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}

-(id<GTCGrid>)addColGrid:(id<GTCGrid>)grid measure:(CGFloat)measure
{
    id<GTCGridNode> gridNode =  (id<GTCGridNode>)[self addColGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}



-(id<GTCGrid>)cloneGrid
{
    GTCGridNode *grid = [[GTCGridNode alloc] initWithMeasure:self.measure superGrid:nil];
    //克隆各种属性。
    grid.subGridsType = self.subGridsType;
    grid.placeholder = self.placeholder;
    grid.anchor = self.anchor;
    grid.gravity = self.gravity;
    grid.tag = self.tag;
    grid.actionData = self.actionData;
    if (self->_optionalProperties2 != NULL)
    {
        grid.subviewSpace = self.subviewSpace;
        grid.padding = self.padding;
    }

    //拷贝分割线。
    if (self->_borderlineLayerDelegate != nil)
    {
        grid.topBorderline = self.topBorderline;
        grid.bottomBorderline = self.bottomBorderline;
        grid.leadingBorderline = self.leadingBorderline;
        grid.trailingBorderline = self.trailingBorderline;
    }

    //拷贝事件处理。
    if (self->_touchEventDelegate != nil)
    {
        [grid setTarget:self->_touchEventDelegate.target action:self->_touchEventDelegate.action];
    }

    //克隆子节点。
    if (self.subGridsType != GTCSubGridsTypeUnknown)
    {
        for (GTCGridNode *subGrid in self.subGrids)
        {
            GTCGridNode *newsubGrid = (GTCGridNode*)[subGrid cloneGrid];
            if (self.subGridsType == GTCSubGridsTypeRow)
                [grid addRowGrid:newsubGrid];
            else
                [grid addColGrid:newsubGrid];
        }
    }

    return grid;
}


-(void)removeFromSuperGrid
{
    [self.superGrid.subGrids removeObject:self];
    if (self.superGrid.subGrids.count == 0)
    {
        self.superGrid.subGridsType = GTCSubGridsTypeUnknown;
    }

    //如果可能销毁高亮层。
    [_touchEventDelegate myResetTouchHighlighted];
    _borderlineLayerDelegate = nil;
    self.superGrid = nil;
}

#pragma mark --  GTCGridNode

-(NSMutableArray<id<GTCGridNode>>*)subGrids
{
    if (_subGrids == nil)
    {
        _subGrids = [NSMutableArray new];
    }
    return _subGrids;
}

//格子内子栅格的间距
-(CGFloat)subviewSpace
{
    if (_optionalProperties2 == NULL)
        return 0;
    else
        return _optionalProperties2->subviewSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.optionalProperties2->subviewSpace = subviewSpace;
}

//格子内视图的内边距。
-(UIEdgeInsets)padding
{
    if (_optionalProperties2 == NULL)
        return UIEdgeInsetsZero;
    else
        return _optionalProperties2->padding;

}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.optionalProperties2->padding = padding;
}




-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<GTCGridNode>)superGrid withMeasure:(CGFloat)measure
{
    if (superGrid.subGridsType == GTCSubGridsTypeCol)
    {
        _gridRect.size.width = measure;
        _gridRect.size.height = superSize.height;
    }
    else
    {
        _gridRect.size.width = superSize.width;
        _gridRect.size.height = measure;

    }

    return measure;
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<GTCGridNode>)superGrid withOffset:(CGFloat)offset
{
    if (superGrid.subGridsType == GTCSubGridsTypeCol)
    {
        _gridRect.origin.x = offset;
        _gridRect.origin.y = superOrigin.y;
        return _gridRect.size.width;
    }
    else if (superGrid.subGridsType == GTCSubGridsTypeRow)
    {
        _gridRect.origin.x = superOrigin.x;
        _gridRect.origin.y = offset;

        return _gridRect.size.height;
    }
    else
    {
        return 0;
    }

}


-(UIView*)gridLayoutView
{
    return [[self superGrid] gridLayoutView];
}

-(SEL)gridAction
{
    return _touchEventDelegate.action;
}


-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer*)layer
{
    [_borderlineLayerDelegate setNeedsLayoutIn:rect withLayer:layer];
}

-(void)showBorderline:(BOOL)show
{
    _borderlineLayerDelegate.topBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.bottomBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.leadingBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.trailingBorderlineLayer.hidden = !show;

    //销毁高亮。。 按理来说不应该出现在这里的。。。。
    if (!show)
        [_touchEventDelegate myResetTouchHighlighted];

    for (GTCGridNode *subGrid in self.subGrids)
    {
        [subGrid showBorderline:show];
    }
}


-(GTCBorderline*)topBorderline
{
    return _borderlineLayerDelegate.topBorderline;
}

-(void)setTopBorderline:(GTCBorderline *)topBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }

    _borderlineLayerDelegate.topBorderline = topBorderline;
}


-(GTCBorderline*)bottomBorderline
{
    return _borderlineLayerDelegate.bottomBorderline;
}

-(void)setBottomBorderline:(GTCBorderline *)bottomBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }

    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}


-(GTCBorderline*)leftBorderline
{
    return _borderlineLayerDelegate.leftBorderline;
}

-(void)setLeftBorderline:(GTCBorderline *)leftBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
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
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }

    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}


-(GTCBorderline*)leadingBorderline
{
    return _borderlineLayerDelegate.leadingBorderline;
}

-(void)setLeadingBorderline:(GTCBorderline *)leadingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }

    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}



-(GTCBorderline*)trailingBorderline
{
    return _borderlineLayerDelegate.trailingBorderline;
}

-(void)setTrailingBorderline:(GTCBorderline *)trailingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTCBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }

    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}


-(id<GTCGridNode>)gridHitTest:(CGPoint)point
{

    //如果不在范围内点击则直接返回
    if (!CGRectContainsPoint(self.gridRect, point))
        return nil;


    //优先测试子视图。。然后再自己。。
    NSArray<id<GTCGridNode>> * subGrids = nil;
    if (self.subGridsType != GTCSubGridsTypeUnknown)
        subGrids = self.subGrids;


    for (id<GTCGridNode> sbvGrid in subGrids)
    {
        id<GTCGridNode> testGrid =  [sbvGrid gridHitTest:point];
        if (testGrid != nil)
            return testGrid;
    }

    if (_touchEventDelegate != nil)
        return self;

    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTCBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTCBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTCBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTCBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
}



////////////////////////////////////////////


+(void)translateGridDicionary:(NSDictionary *)gridDictionary toGridNode:(id<GTCGridNode>)gridNode
{
    id actionData = [gridDictionary objectForKey:kGTCGridActionData];
    [self createActionData:actionData gridNode:gridNode];

    NSNumber *tag = [gridDictionary objectForKey:kGTCGridTag];
    [self createTag:tag.integerValue gridNode:gridNode];

    NSString *action = [gridDictionary objectForKey:kGTCGridAction];
    [self createAction:action gridNode:gridNode];

    NSString *padding = [gridDictionary objectForKey:kGTCGridPadding];
    [self createPadding:padding gridNode:gridNode];

    NSNumber *space = [gridDictionary objectForKey:kGTCGridSpace];
    [self createSpace:space.doubleValue gridNode:gridNode];

    NSNumber *placeholder = [gridDictionary objectForKey:kGTCGridPlaceholder];
    [self createPlaceholder:placeholder.boolValue gridNode:gridNode];

    NSNumber *anchor = [gridDictionary objectForKey:kGTCGridAnchor];;
    [self createAnchor:anchor.boolValue gridNode:gridNode];

    NSString *overlap = [gridDictionary objectForKey:kGTCGridOverlap];
    [self createOverlap:overlap gridNode:gridNode];

    NSString *gravity = [gridDictionary objectForKey:kGTCGridGravity];
    [self createGravity:gravity gridNode:gridNode];

    NSDictionary *dictionary = [gridDictionary objectForKey:kGTCGridTopBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:0];

    dictionary = [gridDictionary objectForKey:kGTCGridLeftBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:1];

    dictionary = [gridDictionary objectForKey:kGTCGridBottomBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:2];

    dictionary = [gridDictionary objectForKey:kGTCGridRightBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:3];

    id tempCols = [gridDictionary objectForKey:kGTCGridCols];
    [self createCols:tempCols gridNode:gridNode];

    id tempRows = [gridDictionary objectForKey:kGTCGridRows];
    [self createRows:tempRows gridNode:gridNode];
}


/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.GTCLayoutSize.wrap 表示尺寸由子栅格包裹
 5.GTCLayoutSize.fill 表示占用栅格剩余的尺寸
 */
+(CGFloat)createLayoutSize:(id)gridSize
{
    if ([gridSize isKindOfClass:[NSNumber class]]) {
        return [gridSize doubleValue];
    }else if ([gridSize isKindOfClass:[NSString class]]){
        if ([gridSize isEqualToString:vGTCGridSizeFill]) {
            return GTCLayoutSize.fill;
        }else if ([gridSize isEqualToString:vGTCGridSizeWrap]){
            return GTCLayoutSize.wrap;
        }else if ([gridSize hasSuffix:@"%"]){

            if ([gridSize isEqualToString:@"100%"] ||
                [gridSize isEqualToString:@"-100%"])return GTCLayoutSize.fill;

            return [gridSize doubleValue] / 100.0;
        }
    }
    return GTCLayoutSize.fill;
}

//action-data 数据
+ (void)createActionData:(id)actionData gridNode:(id<GTCGridNode>)gridNode
{
    if (actionData) {
        gridNode.actionData = actionData;
    }
}

//tag:1
+ (void)createTag:(NSInteger)tag gridNode:(id<GTCGridNode>)gridNode
{
    if (tag != 0) {
        gridNode.tag = tag;
    }
}

//action
+ (void)createAction:(NSString *)action gridNode:(id<GTCGridNode>)gridNode
{
    if (action.length > 0) {
        GTCGridLayout *layout = (GTCGridLayout *)[gridNode gridLayoutView];
        SEL sel = NSSelectorFromString(action);
        if (layout.gridActionTarget != nil && sel != nil && [layout.gridActionTarget respondsToSelector:sel]) {
            [gridNode setTarget:layout.gridActionTarget action:sel];
        }
    }
}

//padding:"{10,10,10,10}"
+ (void)createPadding:(NSString *)padding gridNode:(id<GTCGridNode>)gridNode
{
    if (padding.length > 0){
        gridNode.padding = UIEdgeInsetsFromString(padding);
    }
}

//space:10.0
+ (void)createSpace:(CGFloat)space gridNode:(id<GTCGridNode>)gridNode
{
    if (space != 0.0){
        gridNode.subviewSpace = space;
    }
}

//palceholder:true/false
+ (void)createPlaceholder:(BOOL)placeholder gridNode:(id<GTCGridNode>)gridNode
{
    if (placeholder) {
        gridNode.placeholder = placeholder;
    }
}

//anchor:true/false
+ (void)createAnchor:(BOOL)anchor gridNode:(id<GTCGridNode>)gridNode
{
    if (anchor) {
        gridNode.anchor = anchor;
    }
}

//overlap:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)createOverlap:(NSString *)overlap gridNode:(id<GTCGridNode>)gridNode
{
    GTCGravity tempGravity = GTCGravityNone;
    NSArray *array = [overlap componentsSeparatedByString:@"|"];
    for (NSString *temp in array) {
        tempGravity |= [self returnGravity:temp];
    }
    if (tempGravity != GTCGravityNone){
        gridNode.overlap = tempGravity;
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)createGravity:(NSString *)gravity gridNode:(id<GTCGridNode>)gridNode
{
    GTCGravity tempGravity = GTCGravityNone;
    NSArray *array = [gravity componentsSeparatedByString:@"|"];
    for (NSString *temp in array) {
        tempGravity |= [self returnGravity:temp];
    }

    if (tempGravity != GTCGravityNone)
        gridNode.gravity = tempGravity;
}

+ (GTCGravity)returnGravity:(NSString *)gravity
{

    if ([gravity rangeOfString:vGTCGridGravityTop].location != NSNotFound) {
        return  GTCGravityVertTop;
    }else if ([gravity rangeOfString:vGTCGridGravityBottom].location != NSNotFound) {
        return GTCGravityVertBottom;
    }else if ([gravity rangeOfString:vGTCGridGravityLeft].location != NSNotFound) {
        return GTCGravityHorzLeft;
    }else if ([gravity rangeOfString:vGTCGridGravityRight].location != NSNotFound) {
        return GTCGravityHorzRight;
    }else if ([gravity rangeOfString:vGTCGridGravityLeading].location != NSNotFound) {
        return GTCGravityHorzLeading;
    }else if ([gravity rangeOfString:vGTCGridGravityTrailing].location != NSNotFound) {
        return GTCGravityHorzTrailing;
    }else if ([gravity rangeOfString:vGTCGridGravityCenterX].location != NSNotFound) {
        return GTCGravityHorzCenter;
    }else if ([gravity rangeOfString:vGTCGridGravityCenterY].location != NSNotFound) {
        return GTCGravityVertCenter;
    }else if ([gravity rangeOfString:vGTCGridGravityWidthFill].location != NSNotFound) {
        return GTCGravityHorzFill;
    }else if ([gravity rangeOfString:vGTCGridGravityHeightFill].location != NSNotFound) {
        return GTCGravityVertFill;
    }else{
        return GTCGravityNone;
    }
}


//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} borderline:{上,左,下,右}
+ (void)createBorderline:(NSDictionary *)dictionary gridNode:(id<GTCGridNode>)gridNode borderline:(NSInteger)borderline
{
    if (dictionary) {
        GTCBorderline *line = [GTCBorderline new];
        NSString *color = [dictionary objectForKey:kGTCGridBorderlineColor];
        if (color) {
            line.color = [UIColor gtcColorWithHexString:color];
        }
        line.thick  = [[dictionary objectForKey:kGTCGridBorderlineThick] doubleValue];
        line.headIndent = [[dictionary objectForKey:kGTCGridBorderlineHeadIndent] doubleValue];
        line.tailIndent = [[dictionary objectForKey:kGTCGridBorderlineTailIndent] doubleValue];
        line.offset = [[dictionary objectForKey:kGTCGridBorderlineOffset] doubleValue];
        line.dash = [[dictionary objectForKey:kGTCGridBorderlineDash] doubleValue];
        switch (borderline) {
            case 0: gridNode.topBorderline = line; break;
            case 1: gridNode.leftBorderline = line;break;
            case 2: gridNode.bottomBorderline = line;break;
            case 3: gridNode.rightBorderline = line;break;
            default:
                break;
        }
    }
}

//"cols":[{}]
+ (void)createCols:(NSArray<NSDictionary*>*)cols gridNode:(id<GTCGridNode>)gridNode
{
    for (NSDictionary *dic in cols) {
        NSString *gridSize = [dic objectForKey:kGTCGridSize];
        CGFloat measure = [self createLayoutSize:gridSize];
        GTCGridNode *temp = (GTCGridNode*)[gridNode addCol:measure];
        [self translateGridDicionary:dic toGridNode:temp];
    }
}

//"rows":[{}]
+ (void)createRows:(id)rows gridNode:(id<GTCGrid>)gridNode
{
    for (NSDictionary *dic in rows) {
        NSString *gridSize = [dic objectForKey:kGTCGridSize];
        CGFloat measure = [self createLayoutSize:gridSize];
        GTCGridNode *temp = (GTCGridNode*)[gridNode addRow:measure];
        [self translateGridDicionary:dic toGridNode:temp];
    }
}


#pragma mark 节点转换字典

/**
 节点转换字典

 @param gridNode 节点
 @return 字典
 */
+ (NSDictionary *)translateGridNode:(id<GTCGridNode>)gridNode toGridDictionary:(NSMutableDictionary *)gridDictionary
{
    if (gridNode == nil) return  nil;

    [self returnLayoutSizeWithGridNode:gridNode result:gridDictionary];

    [self returnActionDataWithGridNode:gridNode result:gridDictionary];

    [self returnTagWithGridNode:gridNode result:gridDictionary];

    [self returnActionWithGridNode:gridNode result:gridDictionary];

    [self returnPaddingWithGridNode:gridNode result:gridDictionary];

    [self returnSpaceWithGridNode:gridNode result:gridDictionary];

    [self returnPlaceholderWithGridNode:gridNode result:gridDictionary];

    [self returnAnchorWithGridNode:gridNode result:gridDictionary];

    [self returnOverlapWithGridNode:gridNode result:gridDictionary];

    [self returnGravityWithGridNode:gridNode result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:0 result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:1 result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:2 result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:3 result:gridDictionary];

    [self returnArrayColsRowsGridNode:gridNode result:gridDictionary];

    return gridDictionary;
}


/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.GTCLayoutSize.wrap 表示尺寸由子栅格包裹
 5.GTCLayoutSize.fill 表示占用栅格剩余的尺寸
 */
+ (void)returnLayoutSizeWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    id value = nil;
    if (gridNode.measure == GTCLayoutSize.wrap) {
        value  = vGTCGridSizeWrap;
    }else if (gridNode.measure == GTCLayoutSize.fill) {
        value  = vGTCGridSizeFill;
    }else{
        if (gridNode.measure > 0 && gridNode.measure < 1) {
            value = [NSString stringWithFormat:@"%@%%",(@(gridNode.measure * 100)).stringValue];
        }else if (gridNode.measure > -1 && gridNode.measure < 0) {
            value = [NSString stringWithFormat:@"%@%%",(@(gridNode.measure * 100)).stringValue];
        }else{
            value = [NSNumber numberWithDouble:gridNode.measure];
        }
    }
    [result setObject:value forKey:kGTCGridSize];
}

//action-data 数据
+ (void)returnActionDataWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.actionData) {
        [result setObject:gridNode.actionData forKey:kGTCGridActionData];
    }
}

//tag:1
+ (void)returnTagWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.tag != 0) {
        [result setObject:[NSNumber numberWithInteger:gridNode.tag] forKey:kGTCGridTag];
    }
}

//action
+ (void)returnActionWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    SEL action = gridNode.gridAction;
    if (action) {
        [result setObject:NSStringFromSelector(action) forKey:kGTCGridAction];
    }
}

//padding:"{10,10,10,10}"
+ (void)returnPaddingWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    NSString *temp = NSStringFromUIEdgeInsets(gridNode.padding);
    if (temp && ![temp isEqualToString:@"{0, 0, 0, 0}"]) {
        [result setObject:temp forKey:kGTCGridPadding];
    }
}



//space:10.0
+ (void)returnSpaceWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.subviewSpace != 0.0) {
        [result setObject:[NSNumber numberWithDouble:gridNode.subviewSpace] forKey:kGTCGridSpace];
    }
}

//palceholder:true/false
+ (void)returnPlaceholderWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.placeholder) {
        [result setObject:[NSNumber numberWithBool:gridNode.placeholder] forKey:kGTCGridPlaceholder];
    }
}

//anchor:true/false
+ (void)returnAnchorWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.anchor) {
        [result setObject:[NSNumber numberWithBool:gridNode.anchor] forKey:kGTCGridAnchor];
    }
}

//overlap:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)returnOverlapWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    GTCGravity gravity = gridNode.overlap;
    if (gravity != GTCGravityNone)
    {
        static NSDictionary *data = nil;
        if (data == nil)
        {
            data = @{
                     [NSNumber numberWithUnsignedShort:GTCGravityVertTop]:vGTCGridGravityTop,
                     [NSNumber numberWithUnsignedShort:GTCGravityVertBottom]:vGTCGridGravityBottom,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzLeft]:vGTCGridGravityLeft,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzRight]:vGTCGridGravityRight,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzLeading]:vGTCGridGravityLeading,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzTrailing]:vGTCGridGravityTrailing,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzCenter]:vGTCGridGravityCenterX,
                     [NSNumber numberWithUnsignedShort:GTCGravityVertCenter]:vGTCGridGravityCenterY,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzFill]:vGTCGridGravityWidthFill,
                     [NSNumber numberWithUnsignedShort:GTCGravityVertFill]:vGTCGridGravityHeightFill
                     };
        }

        NSMutableArray *gravitystrs = [NSMutableArray new];
        GTCGravity horzGravity = gravity & GTCGravityVertMask;
        NSString *horzstr = data[@(horzGravity)];
        if (horzstr != nil)
            [gravitystrs addObject:horzstr];

        GTCGravity vertGravity = gravity & GTCGravityHorzMask;
        NSString *vertstr = data[@(vertGravity)];
        if (vertstr != nil)
            [gravitystrs addObject:vertstr];

        NSString *temp = [gravitystrs componentsJoinedByString:@"|"];
        if (temp.length) {
            [result setObject:temp forKey:kGTCGridOverlap];
        }
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)returnGravityWithGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    GTCGravity gravity = gridNode.gravity;
    if (gravity != GTCGravityNone)
    {
        static NSDictionary *data = nil;
        if (data == nil)
        {
            data = @{
                     [NSNumber numberWithUnsignedShort:GTCGravityVertTop]:vGTCGridGravityTop,
                     [NSNumber numberWithUnsignedShort:GTCGravityVertBottom]:vGTCGridGravityBottom,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzLeft]:vGTCGridGravityLeft,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzRight]:vGTCGridGravityRight,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzLeading]:vGTCGridGravityLeading,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzTrailing]:vGTCGridGravityTrailing,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzCenter]:vGTCGridGravityCenterX,
                     [NSNumber numberWithUnsignedShort:GTCGravityVertCenter]:vGTCGridGravityCenterY,
                     [NSNumber numberWithUnsignedShort:GTCGravityHorzFill]:vGTCGridGravityWidthFill,
                     [NSNumber numberWithUnsignedShort:GTCGravityVertFill]:vGTCGridGravityHeightFill
                     };
        }

        NSMutableArray *gravitystrs = [NSMutableArray new];
        GTCGravity horzGravity = gravity & GTCGravityVertMask;
        NSString *horzstr = data[@(horzGravity)];
        if (horzstr != nil)
            [gravitystrs addObject:horzstr];

        GTCGravity vertGravity = gravity & GTCGravityHorzMask;
        NSString *vertstr = data[@(vertGravity)];
        if (vertstr != nil)
            [gravitystrs addObject:vertstr];

        NSString *temp = [gravitystrs componentsJoinedByString:@"|"];
        if (temp.length) {
            [result setObject:temp forKey:kGTCGridGravity];
        }
    }
}



//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} borderline:{上,左,下,右}
+ (void)returnBorderlineWithGridNode:(id<GTCGridNode>)gridNode borderline:(NSInteger)borderline result:(NSMutableDictionary *)result
{
    NSString *key = nil;
    GTCBorderline *line = nil;
    switch (borderline) {
        case 0: key = kGTCGridTopBorderline;line = gridNode.topBorderline; break;
        case 1: key = kGTCGridLeftBorderline;line = gridNode.leftBorderline;break;
        case 2: key = kGTCGridBottomBorderline;line = gridNode.bottomBorderline;break;
        case 3: key = kGTCGridRightBorderline;line = gridNode.rightBorderline;break;
        default:
            break;
    }
    if (line) {
        NSMutableDictionary *dictionary =  [NSMutableDictionary new];
        if (line.color) {
            [dictionary setObject:[line.color gtcHexString] forKey:kGTCGridBorderlineColor];
        }
        if (line.thick != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.thick] forKey:kGTCGridBorderlineThick];
        }
        if (line.headIndent != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.headIndent] forKey:kGTCGridBorderlineHeadIndent];
        }
        if (line.tailIndent != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.tailIndent] forKey:kGTCGridBorderlineTailIndent];
        }
        if (line.offset != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.offset] forKey:kGTCGridBorderlineOffset];
        }
        if (line.dash != 0){
            [dictionary setObject:[NSNumber numberWithDouble:line.offset] forKey:kGTCGridBorderlineDash];
        }
        [result setObject:dictionary forKey:key];
    }
}

//"cols":[{}] "rows":[{}]
+ (void)returnArrayColsRowsGridNode:(id<GTCGridNode>)gridNode result:(NSMutableDictionary *)result
{
    GTCSubGridsType subGridsType = gridNode.subGridsType;
    if (subGridsType != GTCSubGridsTypeUnknown) {
        NSMutableArray<NSDictionary *> *temp = [NSMutableArray<NSDictionary *> arrayWithCapacity:gridNode.subGrids.count];
        NSString *key = nil;
        switch (subGridsType) {
            case GTCSubGridsTypeCol:
            {
                key = kGTCGridCols;
                break;
            }
            case GTCSubGridsTypeRow:
            {
                key = kGTCGridRows;
                break;
            }
            default:
                break;
        }
        for (id<GTCGridNode> node  in gridNode.subGrids) {
            [temp addObject:[self translateGridNode:node toGridDictionary:[NSMutableDictionary new]]];
        }

        if (key) {
            [result setObject:temp forKey:key];
        }

    }
}



@end


@implementation UIColor (GTCGrid)

static NSDictionary*  gtcDefaultColors()
{
    static NSDictionary *colors = nil;
    if (colors == nil)
    {
        colors = @{
                   @"black":UIColor.blackColor,
                   @"darkgray":UIColor.darkGrayColor,
                   @"lightgray":UIColor.lightGrayColor,
                   @"white":UIColor.whiteColor,
                   @"gray":UIColor.grayColor,
                   @"red":UIColor.redColor,
                   @"green":UIColor.greenColor,
                   @"cyan":UIColor.cyanColor,
                   @"yellow":UIColor.yellowColor,
                   @"magenta":UIColor.magentaColor,
                   @"orange":UIColor.orangeColor,
                   @"purple":UIColor.purpleColor,
                   @"brown":UIColor.brownColor,
                   @"clear":UIColor.clearColor
                   };
    }

    return colors;
}


+ (UIColor *)gtcColorWithHexString:(NSString *)hexString
{
    if (hexString.length == 0)
        return nil;

    //判断是否以#开头,如果不是则直接读取具体的颜色值。
    if ([hexString characterAtIndex:0] != '#')
    {
        return [gtcDefaultColors() objectForKey:hexString.lowercaseString];
    }

    if (hexString.length != 7 && hexString.length != 9)
        return nil;

    NSScanner *scanner = [NSScanner scannerWithString:[hexString substringFromIndex:1]];
    unsigned int val = 0;
    [scanner scanHexInt:&val];

    unsigned char blue  = val & 0xFF;
    unsigned char green = (val >> 8) & 0xFF;
    unsigned char red = (val >> 16) & 0xFF;
    unsigned char alpha = hexString.length == 7 ? 0xFF : (val >> 24) & 0xFF;

    return [[UIColor alloc ] initWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}


- (NSString *)gtcHexString {

    CGFloat red = 0, green = 0, blue = 0, alpha = 1;

    if (![self getRed:&red green:&green blue:&blue alpha:&alpha])
        return nil;

    if (alpha != 1)
    {
        return [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255), (int)(alpha * 255)];
    }
    else
    {
        return [NSString stringWithFormat:@"#%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
    }
}

@end
