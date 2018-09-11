//
//  GTCLayoutSizeInner.h
//  Pods
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutSize.h"

//尺寸对象内部定义
@interface GTCLayoutSize()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) GTCGravity dime;
@property(nonatomic, assign) GTCLayoutValueType dimeValType;

@property(nonatomic, readonly, strong) NSNumber *dimeNumVal;
@property(nonatomic, readonly, strong) GTCLayoutSize *dimeRelaVal;
@property(nonatomic, readonly, strong) NSArray *dimeArrVal;
@property(nonatomic, readonly, strong) GTCLayoutSize *dimeSelfVal;

@property(nonatomic, readonly, strong) GTCLayoutSize *lBoundVal;
@property(nonatomic, readonly, strong) GTCLayoutSize *uBoundVal;

@property(nonatomic, readonly, strong) GTCLayoutSize *lBoundValInner;
@property(nonatomic, readonly, strong) GTCLayoutSize *uBoundValInner;



-(GTCLayoutSize*)__equalTo:(id)val;
-(GTCLayoutSize*)__add:(CGFloat)val;
-(GTCLayoutSize*)__multiply:(CGFloat)val;
-(GTCLayoutSize*)__min:(CGFloat)val;
-(GTCLayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(GTCLayoutSize*)__max:(CGFloat)val;
-(GTCLayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(void)__clear;


//只有为数值时才有意义。
@property(nonatomic, readonly, assign) CGFloat measure;


-(CGFloat)measureWith:(CGFloat)size;

@end
