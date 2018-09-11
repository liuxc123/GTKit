//
//  GTCMaker.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/7.
//

#import "GTCMaker.h"

#if TARGET_OS_IPHONE

#import "GTCLayoutPosition.h"
#import "GTCLayoutSize.h"
#import "GTCLayoutPositionInner.h"
#import "GTCLayoutSizeInner.h"

@implementation GTCMaker
{
    NSArray *_myViews;
    NSMutableArray *_keys;
    BOOL  _clear;
}

-(id)initWithView:(NSArray *)v
{
    self = [self init];
    if (self != nil)
    {
        _myViews = v;
        _keys = [[NSMutableArray alloc] init];
        _clear = NO;
    }

    return self;
}

-(GTCMaker*)addMethod:(NSString*)method
{
    if (_clear)
        [_keys removeAllObjects];
    _clear = NO;

    [_keys addObject:method];
    return self;
}



-(GTCMaker*)top
{
    return [self addMethod:@"topPos"];
}

-(GTCMaker*)left
{
    return [self addMethod:@"leftPos"];
}

-(GTCMaker*)bottom
{
    return [self addMethod:@"bottomPos"];
}

-(GTCMaker*)right
{
    return [self addMethod:@"rightPos"];
}

-(GTCMaker*)margin
{
    [self top];
    [self left];
    [self right];
    return [self bottom];
}

-(GTCMaker*)leading
{
    return [self addMethod:@"leadingPos"];

}

-(GTCMaker*)trailing
{
    return [self addMethod:@"trailingPos"];

}


-(GTCMaker*)height
{
    return [self addMethod:@"heightSize"];
}

-(GTCMaker*)width
{
    return [self addMethod:@"widthSize"];
}

-(GTCMaker*)useFrame
{
    return [self addMethod:@"useFrame"];
}

-(GTCMaker*)noLayout
{
    return [self addMethod:@"noLayout"];

}


-(GTCMaker*)wrapContentHeight
{
    return [self addMethod:@"wrapContentHeight"];
}

-(GTCMaker*)wrapContentWidth
{
    return [self addMethod:@"wrapContentWidth"];
}

-(GTCMaker*)reverseLayout
{
    return [self addMethod:@"reverseLayout"];
}



-(GTCMaker*)weight
{
    return [self addMethod:@"weight"];

}

-(GTCMaker*)reverseFloat
{
    return [self addMethod:@"reverseFloat"];
}

-(GTCMaker*)clearFloat
{
    return [self addMethod:@"clearFloat"];
}

-(GTCMaker*)noBoundaryLimit
{
    return [self addMethod:@"noBoundaryLimit"];
}

-(GTCMaker*)topPadding
{

    return [self addMethod:@"topPadding"];

}

-(GTCMaker*)leftPadding
{
    return [self addMethod:@"leftPadding"];

}

-(GTCMaker*)bottomPadding
{

    return [self addMethod:@"bottomPadding"];

}

-(GTCMaker*)rightPadding
{
    return [self addMethod:@"rightPadding"];

}

-(GTCMaker*)leadingPadding
{

    return [self addMethod:@"leadingPadding"];

}

-(GTCMaker*)trailingPadding
{
    return [self addMethod:@"trailingPadding"];

}


-(GTCMaker*)padding
{
    [self addMethod:@"topPadding"];
    [self addMethod:@"leftPadding"];
    [self addMethod:@"bottomPadding"];
    return [self addMethod:@"rightPadding"];
}

-(GTCMaker*)zeroPadding
{
    return [self addMethod:@"zeroPadding"];
}

-(GTCMaker*)orientation
{
    return [self addMethod:@"orientation"];

}

-(GTCMaker*)gravity
{
    return [self addMethod:@"gravity"];

}


-(GTCMaker*)centerX
{
    return [self addMethod:@"centerXPos"];
}

-(GTCMaker*)centerY
{
    return [self addMethod:@"centerYPos"];
}

-(GTCMaker*)center
{
    [self addMethod:@"centerXPos"];
    return [self addMethod:@"centerYPos"];
}
-(GTCMaker*)baseline
{
    return [self addMethod:@"baselinePos"];
}


-(GTCMaker*)visibility
{
    return [self addMethod:@"myVisibility"];
}

-(GTCMaker*)alignment
{
    return [self addMethod:@"myAlignment"];
}



-(GTCMaker*)sizeToFit
{
    for (UIView *myView in _myViews)
    {
        [myView sizeToFit];
    }

    return self;
}



-(GTCMaker*)space
{
    return [self addMethod:@"subviewSpace"];

}

-(GTCMaker*)shrinkType
{
    return [self addMethod:@"shrinkType"];

}


-(GTCMaker*)arrangedCount
{
    return [self addMethod:@"arrangedCount"];
}

-(GTCMaker*)autoArrange
{
    return [self addMethod:@"autoArrange"];
}

-(GTCMaker*)arrangedGravity
{
    return [self addMethod:@"arrangedGravity"];

}

-(GTCMaker*)vertSpace
{
    return [self addMethod:@"subviewVSpace"];

}

-(GTCMaker*)horzSpace
{
    return [self addMethod:@"subviewHSpace"];

}

-(GTCMaker*)pagedCount
{
    return [self addMethod:@"pagedCount"];

}




-(GTCMaker* (^)(id val))equalTo
{
    _clear = YES;
    return ^id(id val) {

        for (NSString *key in self->_keys)
        {

            for (UIView * myView in self->_myViews)
            {
                if ([val isKindOfClass:[NSNumber class]])
                {
                    id oldVal = [myView valueForKey:key];
                    if ([oldVal isKindOfClass:[GTCLayoutPosition class]])
                    {
                        [((GTCLayoutPosition*)oldVal) __equalTo:val];
                    }
                    else if ([oldVal isKindOfClass:[GTCLayoutSize class]])
                    {
                        [((GTCLayoutSize*)oldVal) __equalTo:val];
                    }
                    else
                        [myView setValue:val forKey:key];
                }
                else if ([val isKindOfClass:[GTCLayoutPosition class]])
                {
                    [((GTCLayoutPosition*)[myView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[GTCLayoutSize class]])
                {
                    [((GTCLayoutSize*)[myView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[NSArray class]])
                {
                    [((GTCLayoutSize*)[myView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[UIView class]])
                {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[GTCLayoutPosition class]])
                    {
                        [((GTCLayoutPosition*)[myView valueForKey:key]) __equalTo:oldVal];
                    }
                    else if ([oldVal isKindOfClass:[GTCLayoutSize class]])
                    {
                        [((GTCLayoutSize*)[myView valueForKey:key]) __equalTo:oldVal];

                    }
                    else
                    {
                        [myView setValue:oldVal forKey:key];
                    }
                }
            }

        }

        return self;
    };
}

-(GTCMaker* (^)(CGFloat val))offset
{
    _clear = YES;

    return ^id(CGFloat val) {

        for (NSString *key in self->_keys)
        {
            for (UIView *myView in self->_myViews)
            {

                [((GTCLayoutPosition*)[myView valueForKey:key]) __offset:val];
            }
        }

        return self;
    };
}

-(GTCMaker* (^)(CGFloat val))multiply
{
    _clear = YES;
    return ^id(CGFloat val) {

        for (NSString *key in self->_keys)
        {
            for (UIView *myView in self->_myViews)
            {

                [((GTCLayoutSize*)[myView valueForKey:key]) __multiply:val];
            }
        }
        return self;
    };

}

-(GTCMaker* (^)(CGFloat val))add
{
    _clear = YES;
    return ^id(CGFloat val) {

        for (NSString *key in self->_keys)
        {

            for (UIView *myView in self->_myViews)
            {

                [((GTCLayoutSize*)[myView valueForKey:key]) __add:val];
            }
        }
        return self;
    };

}

-(GTCMaker* (^)(id val))min
{
    _clear = YES;
    return ^id(id val) {

        for (NSString *key in self->_keys)
        {

            for (UIView *myView in self->_myViews)
            {


                id val2 = val;
                if ([val isKindOfClass:[UIView class]])
                    val2 = [val valueForKey:key];

                id oldVal = [myView valueForKey:key];
                if ([oldVal isKindOfClass:[GTCLayoutPosition class]])
                {
                    [((GTCLayoutPosition*)oldVal) __lBound:val2 offsetVal:0];
                }
                else if ([oldVal isKindOfClass:[GTCLayoutSize class]])
                {
                    [((GTCLayoutSize*)oldVal) __lBound:val2 addVal:0 multiVal:1];
                }
                else
                    ;
            }
        }
        return self;
    };

}

-(GTCMaker* (^)(id val))max
{
    _clear = YES;
    return ^id(id val) {

        for (NSString *key in self->_keys)
        {
            for (UIView *myView in self->_myViews)
            {
                id val2 = val;
                if ([val isKindOfClass:[UIView class]])
                    val2 = [val valueForKey:key];

                id oldVal = [myView valueForKey:key];
                if ([oldVal isKindOfClass:[GTCLayoutPosition class]])
                {
                    [((GTCLayoutPosition*)oldVal) __uBound:val2 offsetVal:0];
                }
                else if ([oldVal isKindOfClass:[GTCLayoutSize class]])
                {
                    [((GTCLayoutSize*)oldVal) __uBound:val2 addVal:0 multiVal:1];
                }
                else
                    ;
            }
        }
        return self;
    };

}


@end

@implementation UIView (GTCMakerExt)

-(void)makeLayout:(void(^)(GTCMaker *make))layoutMaker
{
   GTCMaker *gtcMaker = [[GTCMaker alloc] initWithView:@[self]];
    layoutMaker(gtcMaker);
}

-(void)allSubviewMakeLayout:(void(^)(GTCMaker *make))layoutMaker
{
    GTCMaker *gtcMaker = [[GTCMaker alloc] initWithView:self.subviews];
    layoutMaker(gtcMaker);
}

@end

#endif
