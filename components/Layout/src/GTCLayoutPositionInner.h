//
//  GTCLayoutPositionInner.h
//  Pods
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutPosition.h"

//布局位置内部定义
@interface GTCLayoutPosition()


@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) GTCGravity pos;
@property(nonatomic, assign) GTCLayoutValueType posValType;

@property(nonatomic, readonly, strong) NSNumber *posNumVal;
@property(nonatomic, readonly, strong) GTCLayoutPosition *posRelaVal;
@property(nonatomic, readonly, strong) NSArray *posArrVal;

@property(nonatomic, readonly, strong) GTCLayoutPosition *lBoundVal;
@property(nonatomic, readonly, strong) GTCLayoutPosition *uBoundVal;

@property(nonatomic, readonly, strong) GTCLayoutPosition *lBoundValInner;
@property(nonatomic, readonly, strong) GTCLayoutPosition *uBoundValInner;



-(GTCLayoutPosition*)__equalTo:(id)val;
-(GTCLayoutPosition*)__offset:(CGFloat)val;
-(GTCLayoutPosition*)__min:(CGFloat)val;
-(GTCLayoutPosition*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(GTCLayoutPosition*)__max:(CGFloat)val;
-(GTCLayoutPosition*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(void)__clear;



// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property(nonatomic,readonly, assign) CGFloat absVal;

//获取真实的位置值
-(CGFloat)realPosIn:(CGFloat)size;

-(BOOL)isRelativePos;

-(BOOL)isSafeAreaPos;


@end
