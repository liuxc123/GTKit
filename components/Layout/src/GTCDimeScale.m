//
//  GTCDimeScale.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/6.
//

#import "GTCDimeScale.h"

#if TARGET_OS_IPHONE

extern CGFloat _gtcCGFloatRound(CGFloat);
extern CGPoint _gtcCGPointRound(CGPoint);
extern CGSize _gtcCGSizeRound(CGSize);
extern CGRect _gtcCGRectRound(CGRect);

@implementation GTCDimeScale

CGFloat _rate = 1;
CGFloat _wrate = 1;
CGFloat _hrate = 1;


+(void)setUITemplateSize:(CGSize)size
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    _wrate = screenSize.width / size.width;
    _hrate = screenSize.height / size.height;
    _rate = sqrt((screenSize.width * screenSize.width + screenSize.height * screenSize.height) / (size.width * size.width + size.height * size.height));
}

+(CGFloat)scale:(CGFloat)val
{
    return _gtcCGFloatRound(val * _rate);
}

+(CGFloat)scaleW:(CGFloat)val
{
    return _gtcCGFloatRound(val * _wrate);
}

+(CGFloat)scaleH:(CGFloat)val
{
    return _gtcCGFloatRound(val * _hrate);
}

+(CGFloat)roundNumber:(CGFloat)number
{
    return _gtcCGFloatRound(number);
}

+(CGPoint)roundPoint:(CGPoint)point
{
    return _gtcCGPointRound(point);
}

+(CGSize)roundSize:(CGSize)size
{
    return _gtcCGSizeRound(size);
}

+(CGRect)roundRect:(CGRect)rect
{
    return _gtcCGRectRound(rect);
}

@end

#endif
