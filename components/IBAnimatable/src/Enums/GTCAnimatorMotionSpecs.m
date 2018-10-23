//
//  GTCAnimatorMotionSpecs.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import "GTCAnimatorMotionSpecs.h"

@implementation GTCAnimatorMotionSpecs

+ (GTCAnimatorMotionSpec)slide:(GTCWay)way direction:(GTCDirection)direction
{
    return (GTCAnimatorMotionSpec){
        .way = way,
        .direction = direction
    };
}

+ (GTCAnimatorMotionSpec)squeeze:(GTCWay)way direction:(GTCDirection)direction
{
    return (GTCAnimatorMotionSpec){
        .way = way,
        .direction = direction
    };
}

+ (GTCAnimatorMotionSpec)slideFade:(GTCWay)way direction:(GTCDirection)direction
{
    return (GTCAnimatorMotionSpec){
        .way = way,
        .direction = direction
    };
}

+ (GTCAnimatorMotionSpec)squeezeFade:(GTCWay)way direction:(GTCDirection)direction
{
    return (GTCAnimatorMotionSpec){
        .way = way,
        .direction = direction
    };
}

+ (GTCAnimatorMotionSpec)fade:(GTCFadeWay)way
{
    return (GTCAnimatorMotionSpec){
        .fadeway = way
    };
}

+ (GTCAnimatorMotionSpec)zoom:(GTCWay)way
{
    return (GTCAnimatorMotionSpec){
        .way = way
    };
}

+ (GTCAnimatorMotionSpec)zoomInvert:(GTCWay)way
{
    return (GTCAnimatorMotionSpec){
        .way = way
    };
}

+ (GTCAnimatorMotionSpec)shake:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)pop:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)squash:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)flip:(GTCAxis)along
{
    return (GTCAnimatorMotionSpec){
        .along = along
    };
}

+ (GTCAnimatorMotionSpec)morph:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)flash:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)wobble:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}


+ (GTCAnimatorMotionSpec)swing:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)rotate:(GTCRotationDirection)direction repeatCount:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .rotationDirection = direction,
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)moveTo:(double)x y:(double)y
{
    return (GTCAnimatorMotionSpec){
        .x = x,
        .y = y
    };
}

+ (GTCAnimatorMotionSpec)moveBy:(double)x y:(double)y
{
    return (GTCAnimatorMotionSpec){
        .x = x,
        .y = y
    };
}

+ (GTCAnimatorMotionSpec)scale:(double)fromX fromY:(double)fromY toX:(double)toX toY:(double)toY
{
    return (GTCAnimatorMotionSpec){
        .fromX = fromX,
        .fromY = fromY,
        .toX = toX,
        .toY = toY
    };
}

+ (GTCAnimatorMotionSpec)spin:(NSInteger)repeatCount
{
    return (GTCAnimatorMotionSpec){
        .repeatCount = repeatCount
    };
}

+ (GTCAnimatorMotionSpec)none
{
    return (GTCAnimatorMotionSpec){
    };
}

@end
