//
//  GTCMaker.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/7.
//

#import "GTCLayoutDefine.h"

#if TARGET_OS_IPHONE

/**
 *专门为布局设置的简化操作类，以便在统一的地方进行布局设置,MyLayout提供了类似masonry的布局设置语法。
 */
@interface GTCMaker : NSObject

-(GTCMaker*)top;
-(GTCMaker*)left;
-(GTCMaker*)bottom;
-(GTCMaker*)right;
-(GTCMaker*)margin;

-(GTCMaker*)leading;
-(GTCMaker*)trailing;


-(GTCMaker*)wrapContentHeight;
-(GTCMaker*)wrapContentWidth;

-(GTCMaker*)height;
-(GTCMaker*)width;
-(GTCMaker*)useFrame;
-(GTCMaker*)noLayout;

-(GTCMaker*)centerX;
-(GTCMaker*)centerY;
-(GTCMaker*)center;
-(GTCMaker*)baseline;

-(GTCMaker*)visibility;
-(GTCMaker*)alignment;

-(GTCMaker*)sizeToFit;


//布局独有
-(GTCMaker*)topPadding;
-(GTCMaker*)leftPadding;
-(GTCMaker*)bottomPadding;
-(GTCMaker*)rightPadding;
-(GTCMaker*)leadingPadding;
-(GTCMaker*)trailingPadding;
-(GTCMaker*)padding;
-(GTCMaker*)zeroPadding;
-(GTCMaker*)reverseLayout;
-(GTCMaker*)vertSpace;
-(GTCMaker*)horzSpace;
-(GTCMaker*)space;



//线性布局和流式布局独有
-(GTCMaker*)orientation;
-(GTCMaker*)gravity;

//线性布局独有
-(GTCMaker*)shrinkType;

//流式布局独有
-(GTCMaker*)arrangedCount;
-(GTCMaker*)autoArrange;
-(GTCMaker*)arrangedGravity;
-(GTCMaker*)pagedCount;


//线性布局和浮动布局和流式布局子视图独有
-(GTCMaker*)weight;

//浮动布局子视图独有
-(GTCMaker*)reverseFloat;
-(GTCMaker*)clearFloat;


//浮动布局独有。
-(GTCMaker*)noBoundaryLimit;

//赋值操支持NSNumber,UIView,MyLayoutPos,MyLayoutSize, NSArray[MyLayoutSize]
-(GTCMaker* (^)(id val))equalTo;
-(GTCMaker* (^)(id val))min;
-(GTCMaker* (^)(id val))max;

-(GTCMaker* (^)(CGFloat val))offset;
-(GTCMaker* (^)(CGFloat val))multiply;
-(GTCMaker* (^)(CGFloat val))add;




@end


@interface UIView(GTCMakerExt)

//对视图进行统一的布局，方便操作，请参考DEMO1中的使用方法。
-(void)makeLayout:(void(^)(GTCMaker *make))layoutMaker;

//布局内所有子视图的布局构造，会影响到有所的子视图。
-(void)allSubviewMakeLayout:(void(^)(GTCMaker *make))layoutMaker;


@end

#endif

