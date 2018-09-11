//
//  GTCLayoutDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import <Foundation/Foundation.h>
#include "GTCBorderline.h"

@class GTCBaseLayout;

/**绘制线条层委托实现类**/
#ifdef MAC_OS_X_VERSION_10_12
@interface GTCBorderlineLayerDelegate : NSObject<CALayerDelegate>
#else
@interface GTCBorderlineLayerDelegate : NSObject
#endif


@property(nonatomic, strong) GTCBorderline *topBorderline; /**顶部边界线*/
@property(nonatomic, strong) GTCBorderline *leadingBorderline; /**头部边界线*/
@property(nonatomic, strong) GTCBorderline *bottomBorderline;  /**底部边界线*/
@property(nonatomic, strong) GTCBorderline *trailingBorderline;  /**尾部边界线*/
@property(nonatomic, strong) GTCBorderline *leftBorderline;   /**左边边界线*/
@property(nonatomic, strong) GTCBorderline *rightBorderline;   /**左边边界线*/


@property(nonatomic ,strong) CAShapeLayer *topBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *leadingBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *trailingBorderlineLayer;


-(instancetype)initWithLayoutLayer:(CALayer*)layoutLayer;

-(void)setNeedsLayoutIn:(CGRect)rect withLayer:(CALayer*)layer;


@end

//触摸事件的委托代码基类。
@interface GTCTouchEventDelegate : NSObject

@property(nonatomic, weak)  GTCBaseLayout *layout;
@property(nonatomic, weak)  id target;
@property(nonatomic)  SEL action;

-(instancetype)initWithLayout:(GTCBaseLayout*)layout;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)setTarget:(id)target action:(SEL)action;
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


//subclass override this method
-(void)gtcSetTouchHighlighted;
-(void)gtcResetTouchHighlighted;
-(void)gtcResetTouchHighlighted2;
-(id)gtcActionSender;


@end

//布局视图的触摸委托代理。
@interface GTCLayoutTouchEventDelegate : GTCTouchEventDelegate

@property(nonatomic,strong)  UIColor *highlightedBackgroundColor;

@property(nonatomic,assign)  CGFloat highlightedOpacity;

@property(nonatomic,strong)  UIImage *highlightedBackgroundImage;

@end

