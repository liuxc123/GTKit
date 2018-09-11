//
//  GTCLayoutInner.h
//  Pods
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutDefine.h"
#import "GTCLayoutMath.h"
#import "GTCLayoutPositionInner.h"
#import "GTCLayoutSizeInner.h"
#import "GTCLayoutSizeClass.h"
#import "GTCBaseLayout.h"

//视图在布局中的评估测量值
@interface GTCFrame : NSObject

@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat leading;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat trailing;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, weak) UIView *sizeClass;

@property(nonatomic, assign, readonly) BOOL multiple; //是否设置了多个sizeclass

@property(nonatomic, strong) NSMutableDictionary *sizeClasses;

@property(nonatomic, assign) BOOL hasObserver;

-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end

@interface GTCBaseLayout()


//派生类重载这个函数进行布局
-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTCSizeClass)sizeClass sbs:(NSMutableArray*)sbs;

-(id)createSizeClassInstance;


//判断margin是否是相对margin
-(BOOL)gtcIsRelativePos:(CGFloat)margin;

-(GTCGravity)gtcGetSubviewVertGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc vertGravity:(GTCGravity)vertGravity;


-(void)gtcCalcVertGravity:(GTCGravity)vert
                      sbv:(UIView *)sbv
                    sbvsc:(UIView*)sbvsc
               paddingTop:(CGFloat)paddingTop
            paddingBottom:(CGFloat)paddingBottom
              baselinePos:(CGFloat)baselinePos
                 selfSize:(CGSize)selfSize
                    pRect:(CGRect*)pRect;

-(GTCGravity)gtcGetSubviewHorzGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc horzGravity:(GTCGravity)horzGravity;


-(void)gtcCalcHorzGravity:(GTCGravity)horz
                      sbv:(UIView *)sbv
                    sbvsc:(UIView*)sbvsc
           paddingLeading:(CGFloat)paddingLeading
          paddingTrailing:(CGFloat)paddingTrailing
                 selfSize:(CGSize)selfSize
                    pRect:(CGRect*)pRect;

-(void)gtcCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvFrame:(GTCFrame*)sbvFrame;

-(CGFloat)gtcHeightFromFlexedHeightView:(UIView*)sbv sbvsc:(UIView*)sbvsc inWidth:(CGFloat)width;

-(CGFloat)gtcValidMeasure:(GTCLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)gtcValidMargin:(GTCLayoutPosition*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)gtcIsNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)gtcGetLayoutSubviews;
-(NSMutableArray*)gtcGetLayoutSubviewsFrom:(NSArray*)sbsFrom;

//设置子视图的相对依赖的尺寸
-(void)gtcSetSubviewRelativeDimeSize:(GTCLayoutSize*)dime selfSize:(CGSize)selfSize lsc:(GTCBaseLayout*)lsc pRect:(CGRect*)pRect;

-(CGSize)gtcAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray*)sbs lsc:(GTCBaseLayout*)lsc;

- (void)gtcAdjustLayoutSelfSize:(CGSize *)pSelfSize lsc:(GTCBaseLayout*)lsc;

-(void)gtcAdjustSubviewsRTLPos:(NSArray*)sbs selfWidth:(CGFloat)selfWidth;

-(void)gtcAdjustSubviewsLayoutTransform:(NSArray*)sbs lsc:(GTCBaseLayout*)lsc selfWidth:(CGFloat)selfWidth selfHeight:(CGFloat)selfHeight;

-(GTCGravity)gtcConvertLeftRightGravityToLeadingTrailing:(GTCGravity)horzGravity;

//为支持iOS11的safeArea而进行的padding的转化
-(CGFloat)gtcLayoutTopPadding;
-(CGFloat)gtcLayoutBottomPadding;
-(CGFloat)gtcLayoutLeftPadding;
-(CGFloat)gtcLayoutRightPadding;
-(CGFloat)gtcLayoutLeadingPadding;
-(CGFloat)gtcLayoutTrailingPadding;

-(void)gtcAdjustSubviewWrapContentSet:(UIView*)sbv isEstimate:(BOOL)isEstimate sbvFrame:(GTCFrame*)sbvFrame sbvsc:(UIView*)sbvsc selfSize:(CGSize)selfSize sizeClass:(GTCSizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout;


-(void)gtcCalcSubViewRect:(UIView*)sbv
                    sbvsc:(UIView*)sbvsc
                 sbvFrame:(GTCFrame*)sbvFrame
                      lsc:(GTCBaseLayout*)lsc
              vertGravity:(GTCGravity)vertGravity
              horzGravity:(GTCGravity)horzGravity
               inSelfSize:(CGSize)selfSize
               paddingTop:(CGFloat)paddingTop
           paddingLeading:(CGFloat)paddingLeading
            paddingBottom:(CGFloat)paddingBottom
          paddingTrailing:(CGFloat)paddingTrailing
             pMaxWrapSize:(CGSize*)pMaxWrapSize;

-(UIFont*)gtcGetSubviewFont:(UIView*)sbv;

-(GTCSizeClass)gtcGetGlobalSizeClass;

//给父布局视图机会来更改子布局视图的边界线的显示的rect
-(void)gtcHookSublayout:(GTCBaseLayout*)sublayout borderlineRect:(CGRect*)pRect;

@end

@interface GTCViewSizeClass()

@property(nonatomic, strong,readonly)  GTCLayoutPosition *topPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *leadingPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *bottomPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *trailingPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *centerXPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *centerYPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutSize *widthSizeInner;
@property(nonatomic, strong,readonly)  GTCLayoutSize *heightSizeInner;

@property(nonatomic, strong,readonly)  GTCLayoutPosition *leftPosInner;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *rightPosInner;

@property(nonatomic, strong,readonly)  GTCLayoutPosition *baselinePosInner;

@property(class, nonatomic, assign) BOOL isRTL;

@end

@interface UIView(GTCLayoutExtInner)

@property(nonatomic, strong, readonly) GTCFrame *gtcFrame;

-(instancetype)gtcDefaultSizeClass;

-(instancetype)gtcBestSizeClass:(GTCSizeClass)sizeClass;

-(instancetype)gtcCurrentSizeClass;

-(instancetype)gtcCurrentSizeClassInner;

- (instancetype)gtcCurrentSizeClassFrom:(GTCFrame *)gtcFrame;

-(id)createSizeClassInstance;

@property(nonatomic, readonly)  GTCLayoutPosition *topPosInner;
@property(nonatomic, readonly)  GTCLayoutPosition *leadingPosInner;
@property(nonatomic, readonly)  GTCLayoutPosition *bottomPosInner;
@property(nonatomic, readonly)  GTCLayoutPosition *trailingPosInner;
@property(nonatomic, readonly)  GTCLayoutPosition *centerXPosInner;
@property(nonatomic, readonly)  GTCLayoutPosition *centerYPosInner;
@property(nonatomic, readonly)  GTCLayoutSize *widthSizeInner;
@property(nonatomic, readonly)  GTCLayoutSize *heightSizeInner;

@property(nonatomic, readonly)  GTCLayoutPosition *leftPosInner;
@property(nonatomic, readonly)  GTCLayoutPosition *rightPosInner;

@property(nonatomic, readonly)  GTCLayoutPosition *baselinePosInner;


@end

