//
//  GTCLayoutSize.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutSize.h"
#import "GTCLayoutSizeInner.h"
#import "GTCBaseLayout.h"
#import "GTCLayoutMath.h"

@implementation GTCLayoutSize
{
    id _dimeVal;
    CGFloat _addVal;
    CGFloat _multiVal;
    GTCLayoutSize *_lBoundVal;
    GTCLayoutSize *_uBoundVal;
}

+(CGFloat)wrap
{
    return -1;
}

+(CGFloat)fill
{
    return -2;
}

+(CGFloat)average
{
    return -3;
}


-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _active = YES;
        _view = nil;
        _dime = GTCGravityNone;
        _dimeVal = nil;
        _dimeValType = GTCLayoutValueTypeNil;
        _addVal = 0;
        _multiVal = 1;
        _lBoundVal = nil;
        _uBoundVal = nil;
    }

    return self;
}


- (GTCLayoutSize *(^)(id))equalTo
{
    return ^id(id val){
        return [self __equalTo:val];
    };
}

- (GTCLayoutSize *(^)(id))gtc_equalTo
{
    return ^id(id val){
        return [self __equalTo:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))add
{
    return ^id(CGFloat val){
        return [self __add:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))gtc_add
{
    return ^id(CGFloat val){
        return [self __add:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))multiply
{
    return ^id(CGFloat val){
        return [self __multiply:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))gtc_multiply
{
    return ^id(CGFloat val){
        return [self __multiply:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))min
{
    return ^id(CGFloat val){
        return [self __min:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))gtc_min
{
    return ^id(CGFloat val){
        return [self __min:val];
    };
}

- (GTCLayoutSize *(^)(id, CGFloat, CGFloat))lBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
    };
}

- (GTCLayoutSize *(^)(id, CGFloat, CGFloat))gtc_lBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
    };
}

- (GTCLayoutSize *(^)(CGFloat))max
{
    return ^id(CGFloat val){
        return [self __max:val];
    };
}

- (GTCLayoutSize *(^)(CGFloat))gtc_max
{
    return ^id(CGFloat val){
        return [self __max:val];
    };
}

- (GTCLayoutSize *(^)(id, CGFloat, CGFloat))uBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
    };
}

- (GTCLayoutSize *(^)(id, CGFloat, CGFloat))gtc_uBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
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


-(id)dimeVal
{
    if (self.isActive)
    {
        if (_dimeValType == GTCLayoutValueTypeLayoutDime && _dimeVal == nil)
            return self;

        return _dimeVal;
    }
    else
        return nil;

}

-(CGFloat)minVal
{
    return (self.isActive && _lBoundVal != nil) ?  _lBoundVal.dimeNumVal.doubleValue : -CGFLOAT_MAX;
}

-(CGFloat)maxVal
{
    return (self.isActive && _uBoundVal != nil) ?  _uBoundVal.dimeNumVal.doubleValue : CGFLOAT_MAX;
}

#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    GTCLayoutSize *ld = [[[self class] allocWithZone:zone] init];
    ld.view = self.view;
    ld->_active = _active;
    ld->_dime = _dime;
    ld->_addVal = _addVal;
    ld->_multiVal = _multiVal;
    ld->_dimeVal = _dimeVal;
    ld->_dimeValType = _dimeValType;
    if (_lBoundVal != nil)
    {
        ld->_lBoundVal = [[[self class] allocWithZone:zone] init];
        ld->_lBoundVal->_active = _active;
        [[[ld->_lBoundVal __equalTo:_lBoundVal.dimeVal] __add:_lBoundVal.addVal] __multiply:_lBoundVal.multiVal];

    }

    if (_uBoundVal != nil)
    {
        ld->_uBoundVal = [[[self class] allocWithZone:zone] init];
        ld->_uBoundVal->_active = _active;
        [[[ld->_uBoundVal __equalTo:_uBoundVal.dimeVal] __add:_uBoundVal.addVal] __multiply:_uBoundVal.multiVal];

    }


    return self;
}

#pragma mark -- Private Methods


-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;

    if (_dimeValType == GTCLayoutValueTypeNSNumber)
        return _dimeVal;
    return nil;
}

-(GTCLayoutSize*)dimeRelaVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    if (_dimeValType == GTCLayoutValueTypeLayoutDime)
        return _dimeVal;
    return nil;

}


-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    if (_dimeValType == GTCLayoutValueTypeArray)
        return _dimeVal;
    return nil;

}


-(GTCLayoutSize*)dimeSelfVal
{
    if (_dimeValType == GTCLayoutValueTypeLayoutDime && _dimeVal == nil && self.isActive)
        return self;

    return nil;
}


-(GTCLayoutSize*)lBoundVal
{
    if (_lBoundVal == nil)
    {
        _lBoundVal = [[GTCLayoutSize alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
    }

    return _lBoundVal;
}

-(GTCLayoutSize*)uBoundVal
{

    if (_uBoundVal == nil)
    {
        _uBoundVal = [[GTCLayoutSize alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

-(GTCLayoutSize*)lBoundValInner
{
    return _lBoundVal;
}

-(GTCLayoutSize*)uBoundValInner
{
    return _uBoundVal;
}


-(GTCLayoutSize*)__equalTo:(id)val
{

    if (![_dimeVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            _dimeValType = GTCLayoutValueTypeNSNumber;
        }
        else if ([val isMemberOfClass:[GTCLayoutSize class]])
        {
            _dimeValType = GTCLayoutValueTypeLayoutDime;

            //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
            //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
            if (val == self)
            {
                val = nil;
            }
        }
        else if ([val isKindOfClass:[UIView class]])
        {

            UIView *rview = (UIView*)val;
            _dimeValType = GTCLayoutValueTypeLayoutDime;

            switch (_dime) {
                case GTCGravityHorzFill:
                    val = rview.widthSize;
                    break;
                case GTCGravityVertFill:
                    val = rview.heightSize;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }

        }
        else if ([val isKindOfClass:[NSArray class]])
        {
            _dimeValType = GTCLayoutValueTypeArray;
        }
        else
        {
            _dimeValType = GTCLayoutValueTypeNil;
        }

        _dimeVal = val;
        [self setNeedsLayout];
    }
    else
    {
        //参考上面自己等于自己的特殊情况需要特殊处理。
        if (val == nil && _dimeVal == nil && _dimeValType == GTCLayoutValueTypeLayoutDime)
        {
            _dimeValType = GTCLayoutValueTypeNil;
            [self setNeedsLayout];
        }
    }

    return self;
}

//加
-(GTCLayoutSize*)__add:(CGFloat)val
{

    if (_addVal != val)
    {
        _addVal = val;
        [self setNeedsLayout];
    }

    return self;
}


//乘
-(GTCLayoutSize*)__multiply:(CGFloat)val
{

    if (_multiVal != val)
    {
        _multiVal = val;
        [self setNeedsLayout];
    }

    return self;

}


-(GTCLayoutSize*)__min:(CGFloat)val
{
    if (self.lBoundVal.dimeNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }

    return self;
}


-(GTCLayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = self.lBoundVal;

    [[[self.lBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedsLayout];

    return self;
}


-(GTCLayoutSize*)__max:(CGFloat)val
{
    if (self.uBoundVal.dimeNumVal.doubleValue != val)
    {
        [self.uBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }

    return self;
}

-(GTCLayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = self.uBoundVal;

    [[[self.uBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedsLayout];

    return self;
}



-(void)__clear
{
    _active = YES;
    _addVal = 0;
    _multiVal = 1;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _dimeVal = nil;
    _dimeValType = GTCLayoutValueTypeNil;

    [self setNeedsLayout];
}

-(CGFloat) measure
{
    return self.isActive ? _gtcCGFloatFma(self.dimeNumVal.doubleValue,  _multiVal,  _addVal) : 0;
}

-(CGFloat)measureWith:(CGFloat)size
{
    return self.isActive ?  _gtcCGFloatFma(size, _multiVal , _addVal) : size;
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


+(NSString*)dimestrFromDime:(GTCLayoutSize*)dimeobj showView:(BOOL)showView
{

    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    }

    NSString *dimeStr = @"";

    switch (dimeobj.dime) {
        case GTCGravityHorzFill:
            dimeStr = @"widthSize";
            break;
        case GTCGravityVertFill:
            dimeStr = @"heightSize";
            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@%@",viewstr,dimeStr];

}


#pragma mark -- Override Methods

-(NSString*)description
{
    NSString *dimeValStr = @"";
    switch (_dimeValType) {
        case GTCLayoutValueTypeNil:
            dimeValStr = @"nil";
            break;
        case GTCLayoutValueTypeNSNumber:
            dimeValStr = [_dimeVal description];
            break;
        case GTCLayoutValueTypeLayoutDime:
            dimeValStr = [GTCLayoutSize dimestrFromDime:_dimeVal showView:YES];
            break;
        case GTCLayoutValueTypeArray:
        {
            dimeValStr = @"[";
            for (NSObject *obj in _dimeVal)
            {
                if ([obj isMemberOfClass:[GTCLayoutSize class]])
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[GTCLayoutSize dimestrFromDime:(GTCLayoutSize*)obj showView:YES]];
                }
                else
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[obj description]];

                }

                if (obj != [_dimeVal lastObject])
                    dimeValStr = [dimeValStr stringByAppendingString:@", "];

            }

            dimeValStr = [dimeValStr stringByAppendingString:@"]"];

        }
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[GTCLayoutSize dimestrFromDime:self showView:NO], dimeValStr, _multiVal, _addVal, _uBoundVal.dimeNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.dimeNumVal.doubleValue , _lBoundVal.dimeNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.dimeNumVal.doubleValue];

}

@end

