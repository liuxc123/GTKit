//
//  GTCLayoutPosition.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutPosition.h"
#import "GTCLayoutPositionInner.h"
#import "GTCBaseLayout.h"
#import "GTCLayoutMath.h"

@implementation GTCLayoutPosition
{
    id _posVal;
    CGFloat _offsetVal;
    GTCLayoutPosition *_lBoundVal;
    GTCLayoutPosition *_uBoundVal;
}

+ (CGFloat)gtc_safeAreaMargin
{
    //在2018年9月10号定义的一个数字，没有其他特殊意义。
    return -20100910.0;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _active = YES;
        _view = nil;
        _pos = GTCGravityNone;
        _posVal = nil;
        _posValType = GTCLayoutValueTypeNil;
        _offsetVal = 0;
        _lBoundVal = nil;
        _uBoundVal = nil;
    }

    return self;
}


- (GTCLayoutPosition *(^)(id))equalTo
{
    return ^id(id val){
        return [self __equalTo:val];
    };
}

- (GTCLayoutPosition *(^)(id))gtc_equalTo
{
    return ^id(id val){
        return [self __equalTo:val];
    };
}

- (GTCLayoutPosition *(^)(CGFloat))offset
{
    return ^id(CGFloat val){
        return [self __offset:val];
    };
}

- (GTCLayoutPosition *(^)(CGFloat))gtc_offset
{
    return ^id(CGFloat val){
        return [self __offset:val];
    };
}

- (GTCLayoutPosition *(^)(CGFloat))min
{
    return ^id(CGFloat val){
        return [self __min:val];
    };
}

- (GTCLayoutPosition *(^)(CGFloat))gtc_min
{
    return ^id(CGFloat val){
        return [self __min:val];
    };
}

- (GTCLayoutPosition *(^)(CGFloat))max
{
    return ^id(CGFloat val){
        return [self __max:val];
    };
}

- (GTCLayoutPosition *(^)(CGFloat))gtc_max
{
    return ^id(CGFloat val){
        return [self __max:val];
    };
}

- (GTCLayoutPosition *(^)(id, CGFloat))lBound
{
    return ^id(id posVal, CGFloat offset){
        return [self __lBound:posVal offsetVal:offset];
    };
}

- (GTCLayoutPosition *(^)(id, CGFloat))gtc_lBound
{
    return ^id(id posVal, CGFloat offset){
        return [self __lBound:posVal offsetVal:offset];
    };
}

- (GTCLayoutPosition *(^)(id, CGFloat))uBound
{
    return ^id(id posVal, CGFloat offset){
        return [self __uBound:posVal offsetVal:offset];
    };
}

- (GTCLayoutPosition *(^)(id, CGFloat))gtc_uBound
{
    return ^id(id posVal, CGFloat offset){
        return [self __uBound:posVal offsetVal:offset];
    };
}

- (void)clear
{
    [self __clear];
}

- (void)gtc_clear
{
    [self __clear];
}

-(void)setActive:(BOOL)active
{
    if (_active != active)
    {
        _active = active;
        _lBoundVal.active = active;
        _uBoundVal.active = active;
        [self setNeedsLayout];
    }
}

-(id)posVal
{
    return self.isActive ? _posVal : nil;
}

-(CGFloat)offsetVal
{
    return self.isActive? _offsetVal : 0;
}

-(CGFloat)minVal
{
    return self.isActive && _lBoundVal != nil ? _lBoundVal.posNumVal.doubleValue : -CGFLOAT_MAX;
}

-(CGFloat)maxVal
{
    return self.isActive && _uBoundVal != nil ?  _uBoundVal.posNumVal.doubleValue : CGFLOAT_MAX;
}


#pragma mark -- NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GTCLayoutPosition *lp = [[[self class] allocWithZone:zone] init];
    lp.view = self.view;
    lp->_active = _active;
    lp->_pos = _pos;
    lp->_posValType = _posValType;
    lp->_posVal = _posVal;
    lp->_offsetVal = _offsetVal;
    if (_lBoundVal != nil)
    {
        lp->_lBoundVal = [[[self class] allocWithZone:zone] init];
        lp->_lBoundVal->_active = _active;
        [[lp->_lBoundVal __equalTo:_lBoundVal.posVal] __offset:_lBoundVal.offsetVal];
    }
    if (_uBoundVal != nil)
    {
        lp->_uBoundVal = [[[self class] allocWithZone:zone] init];
        lp->_uBoundVal->_active = _active;
        [[lp->_uBoundVal __equalTo:_uBoundVal.posVal] __offset:_uBoundVal.offsetVal];
    }

    return lp;
}

#pragma mark -- Private Methods

-(NSNumber*)posNumVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    if (_posValType == GTCLayoutValueTypeNSNumber)
        return _posVal;
    else if (_posValType == GTCLayoutValueTypeUILayoutSupport)
    {
        //只有在11以后并且是设置了safearea缩进才忽略UILayoutSupport。
        //只有在11以后并且是设置了safearea缩进才忽略UILayoutSupport。
        UIView *superview = self.view.superview;
        if (superview != nil &&
            [UIDevice currentDevice].systemVersion.doubleValue >= 11 &&
            [superview isKindOfClass:[GTCBaseLayout class]])
        {
            UIRectEdge edge = ((GTCBaseLayout*)superview).insetsPaddingFromSafeArea;
            if ((_pos == GTCGravityVertTop && (edge & UIRectEdgeTop) == UIRectEdgeTop) ||
                (_pos == GTCGravityVertBottom && (edge & UIRectEdgeBottom) == UIRectEdgeBottom))
            {
                return @(0);
            }
        }

        return @([((id<UILayoutSupport>)_posVal) length]);
    }
    else if (_posValType == GTCLayoutValueTypeSafeArea)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

            UIView *superView = self.view.superview;
            /* UIEdgeInsets insets = superView.safeAreaInsets;
             UIScrollView *superScrollView = nil;
             if ([superView isKindOfClass:[UIScrollView class]])
             {
             superScrollView = (UIScrollView*)superView;

             }
             */

            switch (_pos) {
                case GTCGravityHorzLeading:
                    return  [GTCBaseLayout isRTL]? @(superView.safeAreaInsets.right) : @(superView.safeAreaInsets.left);
                    break;
                case GTCGravityHorzTrailing:
                    return  [GTCBaseLayout isRTL]? @(superView.safeAreaInsets.left) : @(superView.safeAreaInsets.right);
                    break;
                case GTCGravityVertTop:
                    return @(superView.safeAreaInsets.top);
                    break;
                case GTCGravityVertBottom:
                    return @(superView.safeAreaInsets.bottom);
                    break;
                default:
                    return @(0);
                    break;
            }
        }
#endif
        if (_pos == GTCGravityVertTop)
        {
            return @([self findContainerVC].topLayoutGuide.length);
        }
        else if (_pos == GTCGravityVertBottom)
        {
            return @([self findContainerVC].bottomLayoutGuide.length);
        }

        return @(0);

    }


    return nil;
}

-(UIViewController*)findContainerVC
{
    UIViewController *vc = nil;

    @try {

        UIView *v = self.view;
        while (v != nil)
        {
            vc = [v valueForKey:@"viewDelegate"];
            if (vc != nil)
                break;
            v = [v superview];
        }

    } @catch (NSException *exception) {

    }

    return vc;
}


-(GTCLayoutPosition *)posRelaVal
{
    if (_posVal == nil || !self.isActive)
        return nil;

    if (_posValType == GTCLayoutValueTypeLayoutPosition)
        return _posVal;

    return nil;

}

-(NSArray*)posArrVal
{
    if (_posVal == nil || !self.isActive)
        return nil;

    if (_posValType == GTCLayoutValueTypeArray)
        return _posVal;

    return nil;

}

-(GTCLayoutPosition *)lBoundVal
{
    if (_lBoundVal == nil)
    {
        _lBoundVal = [[GTCLayoutPosition alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

-(GTCLayoutPosition*)uBoundVal
{
    if (_uBoundVal == nil)
    {
        _uBoundVal = [[GTCLayoutPosition alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];
    }

    return _uBoundVal;
}

-(GTCLayoutPosition*)lBoundValInner
{
    return _lBoundVal;
}

-(GTCLayoutPosition*)uBoundValInner
{
    return _uBoundVal;
}

-(GTCLayoutPosition*)__equalTo:(id)val
{

    if (![_posVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            //特殊处理设置为safeAreaMargin边距的值。
            if ([val doubleValue] == [GTCLayoutPosition gtc_safeAreaMargin])
            {

                _posValType = GTCLayoutValueTypeSafeArea;
            }
            else
            {
                _posValType = GTCLayoutValueTypeNSNumber;
            }
        }
        else if ([val isKindOfClass:[GTCLayoutPosition class]])
            _posValType = GTCLayoutValueTypeLayoutPosition;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = GTCLayoutValueTypeArray;
        else if ([val conformsToProtocol:@protocol(UILayoutSupport)])
        {
            //这里只有上边和下边支持，其他不支持。。
            if (_pos != GTCGravityVertTop && _pos != GTCGravityVertBottom)
            {
                NSAssert(0, @"oops! only topPos or bottomPos can set to id<UILayoutSupport>");
            }

            _posValType = GTCLayoutValueTypeUILayoutSupport;
        }
        else if ([val isKindOfClass:[UIView class]])
        {
            UIView *rview = (UIView*)val;
            _posValType = GTCLayoutValueTypeLayoutPosition;

            switch (_pos) {
                case GTCGravityHorzLeading:
                    val = rview.leadingPos;
                    break;
                case GTCGravityHorzCenter:
                    val = rview.centerXPos;
                    break;
                case GTCGravityHorzTrailing:
                    val = rview.trailingPos;
                    break;
                case GTCGravityVertTop:
                    val = rview.topPos;
                    break;
                case GTCGravityVertCenter:
                    val = rview.centerYPos;
                    break;
                case GTCGravityVertBottom:
                    val = rview.bottomPos;
                    break;
                case GTCGravityVertBaseline:
                    val = rview.baselinePos;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }

        }
        else
            _posValType = GTCLayoutValueTypeNil;

        _posVal = val;
        [self setNeedsLayout];
    }

    return self;
}


-(GTCLayoutPosition*)__offset:(CGFloat)val
{

    if (_offsetVal != val)
    {
        _offsetVal = val;
        [self setNeedsLayout];
    }

    return self;
}

-(GTCLayoutPosition*)__min:(CGFloat)val
{

    if (self.lBoundVal.posNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];

        [self setNeedsLayout];
    }

    return self;
}

-(GTCLayoutPosition*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal
{

    [[self.lBoundVal __equalTo:posVal] __offset:offsetVal];

    [self setNeedsLayout];

    return self;
}


-(GTCLayoutPosition*)__max:(CGFloat)val
{

    if (self.uBoundVal.posNumVal.doubleValue != val)
    {
        [self.uBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }

    return self;
}

-(GTCLayoutPosition*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal
{

    [[self.uBoundVal __equalTo:posVal] __offset:offsetVal];

    [self setNeedsLayout];

    return self;
}

-(void)__clear
{
    _active = YES;
    _posVal = nil;
    _posValType = GTCLayoutValueTypeNil;
    _offsetVal = 0;
    _lBoundVal = nil;
    _uBoundVal = nil;
    [self setNeedsLayout];
}

-(CGFloat)absVal
{
    if (self.isActive)
    {
        CGFloat retVal = _offsetVal;

        if (self.posNumVal != nil)
            retVal +=self.posNumVal.doubleValue;

        if (_uBoundVal != nil)
            retVal = _gtcCGFloatMin(_uBoundVal.posNumVal.doubleValue, retVal);

        if (_lBoundVal != nil)
            retVal = _gtcCGFloatMax(_lBoundVal.posNumVal.doubleValue, retVal);

        return retVal;
    }
    else
        return 0;
}

-(BOOL)isRelativePos
{
    if (self.isActive)
    {
        CGFloat realPos = self.posNumVal.doubleValue;
        return realPos > 0 && realPos < 1;

    }
    else
        return NO;
}

-(BOOL)isSafeAreaPos
{
    return self.isActive && (_posValType == GTCLayoutValueTypeSafeArea || _posValType == GTCLayoutValueTypeUILayoutSupport);
}

-(CGFloat)realPosIn:(CGFloat)size
{
    if (self.isActive)
    {
        CGFloat realPos = self.posNumVal.doubleValue;
        if (realPos > 0 && realPos < 1)
            realPos *= size;

        realPos += _offsetVal;

        if (_uBoundVal != nil)
            realPos = _gtcCGFloatMin(_uBoundVal.posNumVal.doubleValue, realPos);

        if (_lBoundVal != nil)
            realPos = _gtcCGFloatMax(_lBoundVal.posNumVal.doubleValue, realPos);

        return realPos;
    }
    else
        return 0;

}

-(void)setNeedsLayout
{
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[GTCBaseLayout class]])
    {
        GTCBaseLayout* lb = (GTCBaseLayout*)_view.superview;
        if (!lb.isGTLayouting)
            [_view.superview setNeedsLayout];
    }

}

+ (NSString *)posstrFromPostion:(GTCLayoutPosition *)posobj showView:(BOOL)showView
{
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", posobj.view];
    }

    NSString *posStr = @"";

    switch (posobj.pos) {
        case GTCGravityHorzLeading:
            posStr = @"leadingPos";
            break;
        case GTCGravityHorzCenter:
            posStr = @"centerXPos";
            break;
        case GTCGravityHorzTrailing:
            posStr = @"trailingPos";
            break;
        case GTCGravityVertTop:
            posStr = @"topPos";
            break;
        case GTCGravityVertCenter:
            posStr = @"centerYPos";
            break;
        case GTCGravityVertBottom:
            posStr = @"bottomPos";
            break;
        case GTCGravityVertBaseline:
            posStr = @"baselinePos";
            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@%@",viewstr,posStr];
}

#pragma mark -- Override Method

- (NSString *)description
{
    NSString *posValStr = @"";
    switch (_posValType) {
        case GTCLayoutValueTypeNil:
            posValStr = @"nil";
            break;
        case GTCLayoutValueTypeNSNumber:
            posValStr = [_posVal description];
            break;
        case GTCLayoutValueTypeLayoutPosition:
            posValStr = [GTCLayoutPosition posstrFromPostion:_posVal showView:YES];
            break;
        case GTCLayoutValueTypeArray:

            for (NSObject *obj in _posVal)
            {
                if ([obj isKindOfClass:[GTCLayoutPosition class]])
                {
                    posValStr = [posValStr stringByAppendingString:[GTCLayoutPosition posstrFromPostion:(GTCLayoutPosition*)obj showView:YES]];
                }
                else
                {
                    posValStr = [posValStr stringByAppendingString:[obj description]];

                }

                if (obj != [_posVal lastObject])
                    posValStr = [posValStr stringByAppendingString:@", "];

            }
            posValStr = [posValStr stringByAppendingString:@"]"];

            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@=%@, Offset=%g, Max=%g, Min=%g",[GTCLayoutPosition posstrFromPostion:self showView:NO], posValStr, _offsetVal, _uBoundVal.posNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.posNumVal.doubleValue , _uBoundVal.posNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.posNumVal.doubleValue];
}

@end
