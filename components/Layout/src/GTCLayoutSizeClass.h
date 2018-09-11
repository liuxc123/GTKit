//
//  GTCLayoutSizeClass.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutDefine.h"
#import "GTCLayoutPosition.h"
#import "GTCLayoutSize.h"
#import "GTCGrid.h"

@class GTCBaseLayout;

/*
 布局的尺寸类型类，这个类的功能用来支持类似于iOS的Size Class机制用来实现各种屏幕下的视图的约束。
 GTCLayoutSizeClass类中定义的各种属性跟视图和布局的各种扩展属性是一致的。

 我们所有的视图的默认的约束设置都是基于GTCSizeClasswAny|GTCSizeClasshAny这种SizeClass的。

 需要注意的是因为GTCLayoutSizeClass是基于苹果SizeClass实现的，因此如果是iOS7的系统则只能支持GTCSizeClasswAny|GTCSizeClasshAny这种
 SizeClass，以及GTCSizeClassPortrait或者GTCSizeClassLandscape 也就是设置布局默认的约束。而iOS8以上的系统则能支持所有的SizeClass.

 */
@interface GTCViewSizeClass : NSObject <NSCopying>

@property(nonatomic, weak) UIView *view;

//所有视图通用
@property(nonatomic, strong)  GTCLayoutPosition *topPos;
@property(nonatomic, strong)  GTCLayoutPosition *leadingPos;
@property(nonatomic, strong)  GTCLayoutPosition *bottomPos;
@property(nonatomic, strong)  GTCLayoutPosition *trailingPos;
@property(nonatomic, strong)  GTCLayoutPosition *centerXPos;
@property(nonatomic, strong)  GTCLayoutPosition *centerYPos;


@property(nonatomic, strong,readonly)  GTCLayoutPosition *leftPos;
@property(nonatomic, strong,readonly)  GTCLayoutPosition *rightPos;

@property(nonatomic, strong)  GTCLayoutPosition *baselinePos;


@property(nonatomic, assign) CGFloat gtc_top;
@property(nonatomic, assign) CGFloat gtc_leading;
@property(nonatomic, assign) CGFloat gtc_bottom;
@property(nonatomic, assign) CGFloat gtc_trailing;
@property(nonatomic, assign) CGFloat gtc_centerX;
@property(nonatomic, assign) CGFloat gtc_centerY;
@property(nonatomic, assign) CGPoint gtc_center;


@property(nonatomic, assign) CGFloat gtc_left;
@property(nonatomic, assign) CGFloat gtc_right;



@property(nonatomic, assign) CGFloat gtc_margin;
@property(nonatomic, assign) CGFloat gtc_horzMargin;
@property(nonatomic, assign) CGFloat gtc_vertMargin;


@property(nonatomic, strong)  GTCLayoutSize *widthSize;
@property(nonatomic, strong)  GTCLayoutSize *heightSize;

@property(nonatomic, assign) CGFloat gtc_width;
@property(nonatomic, assign) CGFloat gtc_height;
@property(nonatomic, assign) CGSize  gtc_size;


@property(nonatomic, assign) BOOL wrapContentWidth;
@property(nonatomic, assign) BOOL wrapContentHeight;

@property(nonatomic, assign) BOOL wrapContentSize;

@property(nonatomic, assign) BOOL useFrame;
@property(nonatomic, assign) BOOL noLayout;

@property(nonatomic, assign) GTCVisibility gtc_visibility;
@property(nonatomic, assign) GTCGravity gtc_alignment;

@property(nonatomic, copy) void (^viewLayoutCompleteBlock)(GTCBaseLayout* layout, UIView *v);

//线性布局和浮动布局子视图专用
@property(nonatomic, assign) CGFloat weight;

//浮动布局子视图专用
@property(nonatomic,assign,getter=isReverseFloat) BOOL reverseFloat;
@property(nonatomic,assign) BOOL clearFloat;

@end





@interface GTCLayoutViewSizeClass : GTCViewSizeClass

@property(nonatomic, assign) BOOL zeroPadding;

@property(nonatomic, assign) BOOL reverseLayout;
@property(nonatomic, assign) CGAffineTransform layoutTransform;  //布局变换。

@property(nonatomic, assign) GTCGravity gravity;

@property(nonatomic, assign) BOOL insetLandscapeFringePadding;

@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leadingPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat trailingPadding;
@property(nonatomic, assign) UIEdgeInsets padding;


@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat rightPadding;



@property(nonatomic, assign) UIRectEdge insetsPaddingFromSafeArea;



@property(nonatomic ,assign) CGFloat subviewVSpace;
@property(nonatomic, assign) CGFloat subviewHSpace;
@property(nonatomic, assign) CGFloat subviewSpace;


@end



@interface GTCSequentLayoutViewSizeClass : GTCLayoutViewSizeClass

@property(nonatomic,assign) GTCOrientation orientation;


@end



@interface GTCLinearLayoutViewSizeClass : GTCSequentLayoutViewSizeClass

@property(nonatomic, assign) GTCSubviewsShrinkType shrinkType;

@end

@interface GTCTableLayoutViewSizeClass : GTCLinearLayoutViewSizeClass

@end


@interface GTCFlowLayoutViewSizeClass : GTCSequentLayoutViewSizeClass

@property(nonatomic,assign) GTCGravity arrangedGravity;
@property(nonatomic,assign) BOOL autoArrange;

@property(nonatomic,assign) NSInteger arrangedCount;
@property(nonatomic, assign) NSInteger pagedCount;

@property(nonatomic, assign) CGFloat subviewSize;
@property(nonatomic, assign) CGFloat minSpace;
@property(nonatomic, assign) CGFloat maxSpace;



@end


@interface GTCFloatLayoutViewSizeClass : GTCSequentLayoutViewSizeClass

@property(nonatomic, assign) CGFloat subviewSize;
@property(nonatomic, assign) CGFloat minSpace;
@property(nonatomic, assign) CGFloat maxSpace;
@property(nonatomic,assign) BOOL noBoundaryLimit;

@end


@interface GTCRelativeLayoutViewSizeClass : GTCLayoutViewSizeClass


@end


@interface GTCFrameLayoutViewSizeClass : GTCLayoutViewSizeClass


@end

@interface GTCPathLayoutViewSizeClass  : GTCLayoutViewSizeClass


@end


@interface GTCGridLayoutViewSizeClass : GTCLayoutViewSizeClass<GTCGrid>

@end

