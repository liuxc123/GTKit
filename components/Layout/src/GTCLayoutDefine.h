//
//  GTCLayoutDefine.h
//  Pods
//
//  Created by liuxc on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *布局视图方向的枚举类型定义。用来指定布局内子视图的整体排列布局方向。
 */
typedef NS_ENUM(NSInteger, GTCOrientation) {
    /**垂直方向，布局视图内所有子视图整体从上到下排列布局*/
    GTCOrientationVert = 0,
    /**水平方向，布局视图内所有子视图整体从左到右排列布局*/
    GTCOrientationHorz = 1,
};


/**
 *视图的可见性枚举类型定义。用来指定视图是否在布局中可见，他是对hidden属性的扩展设置。
 */
typedef NS_ENUM(NSUInteger, GTCVisibility) {

    /**视图可见，等价于hidden = false*/
    GTCVisibilityVisible,
    /**视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域*/
    GTCVisibilityInvisible,
    /**视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域*/
    GTCVisibilityGone

};



/**
 *布局视图内所有子视图的停靠方向和填充拉伸属性以及对齐方式的枚举类型定义。
 所谓停靠方向就是指子视图停靠在布局视图中水平方向和垂直方向的位置。水平方向一共有左、水平中心、右、窗口水平中心四个位置，垂直方向一共有上、垂直中心、下、窗口垂直中心四个位置。
 所谓填充拉伸属性就是指子视图的尺寸填充或者子视图的间距拉伸满整个布局视图。一共有水平宽度、垂直高度两种尺寸填充，水平间距、垂直间距两种间距拉伸。
 所谓对齐方式就是指多个子视图之间的对齐位置。水平方向一共有左、水平居中、右、左右两端对齐四种对齐方式，垂直方向一共有上、垂直居中、下、向下两端对齐四种方式。
 在线性布局、流式布局、浮动布局中有一个gravity属性用来表示布局内所有子视图的停靠方向和填充拉伸属性；在流式布局中有一个arrangedGravity属性用来表示布局内每排子视图的对齐方式。
 */
typedef NS_ENUM(NSInteger, GTCGravity) {

    /**默认值，不停靠、不填充、不对齐。*/
    GTCGravityNone = 0,

    //水平方向
    /**左边停靠或者左对齐*/
    GTCGravityHorzLeft = 1,
    /**水平中心停靠或者水平居中对齐*/
    GTCGravityHorzCenter = 2,
    /**右边停靠或者右对齐*/
    GTCGravityHorzRight = 4,
    /**窗口水平中心停靠，表示在屏幕窗口的水平中心停靠*/
    GTCGravityHorzWindowCenter = 8,
    /**水平间距拉伸*/
    GTCGravityHorzBetween = 16,
    /**头部对齐,对于阿拉伯国家来说是和Right等价的,对于非阿拉伯国家则是和Left等价的*/
    GTCGravityHorzLeading = 32,
    /**尾部对齐,对于阿拉伯国家来说是和Left等价的,对于非阿拉伯国家则是和Right等价的*/
    GTCGravityHorzTrailing = 64,
    /**水平宽度填充*/
    GTCGravityHorzFill = GTCGravityHorzLeft | GTCGravityHorzCenter | GTCGravityHorzRight,
    /**水平掩码，用来获取水平方向的枚举值*/
    GTCGravityHorzMask = 0xFF00,

    //垂直方向
    /**上边停靠或者上对齐*/
    GTCGravityVertTop = 1 << 8,
    /**垂直中心停靠或者垂直居中对齐*/
    GTCGravityVertCenter = 2 << 8,
    /**下边停靠或者下边对齐*/
    GTCGravityVertBottom = 4 << 8,
    /**窗口垂直中心停靠，表示在屏幕窗口的垂直中心停靠*/
    GTCGravityVertWindowCenter = 8 << 8,
    /**垂直间距拉伸*/
    GTCGravityVertBetween = 16 << 8,
    /**基线对齐,只支持水平线性布局，指定基线对齐必须要指定出一个基线标准的子视图*/
    GTCGravityVertBaseline = 32 << 8,
    /**垂直高度填充*/
    GTCGravityVertFill = GTCGravityVertTop | GTCGravityVertCenter | GTCGravityVertBottom,
    /**垂直掩码，用来获取垂直方向的枚举值*/
    GTCGravityVertMask = 0x00FF,

    /**整体居中*/
    GTCGravityCenter = GTCGravityHorzCenter | GTCGravityVertCenter,

    /**全部填充*/
    GTCGravityFill = GTCGravityHorzFill | GTCGravityVertFill,

    /**全部拉伸*/
    GTCGravityBetween = GTCGravityHorzBetween | GTCGravityVertBetween,
};


/**
 *设置当将布局视图嵌入到UIScrollView以及其派生类时对UIScrollView的contentSize的调整设置模式的枚举类型定义。
 *当将一个布局视图作为子视图添加到UIScrollView或者其派生类时(UITableView,UICollectionView除外)系统会自动调整和计算并设置其中的contentSize值。您可以使用布局视图的属性adjustScrollViewContentSizeMode来进行设置定义的枚举值。
 */
typedef NS_ENUM(NSInteger, GTCAdjustScrollViewContentSizeMode) {
    /**自动调整，在添加到UIScrollView之前(UITableView, UICollectionView除外)。如果值被设置Auto则在添加到父视图后自动会变为YES。*/
    GTCAdjustScrollViewContentSizeModeAuto = 0,
    /**不调整，任何加入到UIScrollView中的布局视图在尺寸变化时都不会调整和设置contentSize的值。*/
    GTCAdjustScrollViewContentSizeModeNo = 1,
    /**会调整，任何加入到UIScrollView中的布局视图在尺寸变化时都会调整和设置contentSize的值。*/
    GTCAdjustScrollViewContentSizeModeYes = 2,

};


/**
 *用来设置当线性布局中的子视图的尺寸大于线性布局的尺寸时的子视图的压缩策略和压缩内容枚举类型定义。请参考线性布局的shrinkType属性的定义。
 */
typedef NS_ENUM(NSInteger, GTCSubviewsShrinkType) {
    /**不压缩。*/
    GTCSubviewsShrinkNone = 0,
    /**平均压缩。*/
    GTCSubviewsShrinkAverage = 1,
    /**比例压缩。*/
    GTCSubviewsShrinkWeight = 2,
    /**自动压缩。这个属性只有在水平线性布局里面并且只有2个子视图的宽度等于自身时才有用。这个属性主要用来实现左右两个子视图根据自身内容来进行缩放，以便实现最佳的宽度空间利用。*/
    GTCSubviewsShrinkAuto = 4,

    //上面部分是压缩的策略，下面部分指定压缩的内容，因此一个shrinkType的指定时上面部分和下面部分的 | 操作。比如让间距平均压缩：GTCSubviewsShrinkAverage | GTCSubviewsShrinkSpace

    /**只压缩尺寸，因为这里是0所以这部分可以不设置，为默认。*/
    GTCSubviewsShrinkSize =   0 << 4,
    /**只压缩间距。*/
    GTCSubviewsShrinkSpace =  1 << 4,
    /**压缩尺寸和间距。暂时不支持！！！*/
    GTCSubviewsShrinkSizeAndSpace = 2 << 4

};



/*
 SizeClass的尺寸定义,用于定义苹果设备的各种屏幕的尺寸，对于任意一种设备来说某个纬度的尺寸都可以描述为：Any任意，Compact压缩，Regular常规
 三种形式，比如下面就列出了苹果各种设备的SizeClass定义：

 iPhone4S,iPhone5/5s,iPhone6
 竖屏：(w:Compact h:Regular)
 横屏：(w:Compact h:Compact)
 iPhone6 Plus
 竖屏：(w:Compact h:Regular)
 横屏：(w:Regular h:Compact)
 iPad
 竖屏：(w:Regular h:Regular)
 横屏：(w:Regular h:Regular)
 Apple Watch
 竖屏：(w:Compact h:Compact)
 横屏：(w:Compact h:Compact)

 我们可以专门为某种设备的SizeClass来设置具体的各种子视图和布局的约束，但是为了兼容多种设备，我们提出了SizeClass的继承关系,其中的继承关系如下：

 w:Compact h:Compact 继承 (w:Any h:Compact , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Compact 继承 (w:Any h:Compact , w:Regular h:Any , w:Any h:Any)
 w:Compact h:Regular 继承 (w:Any h:Regular , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Regular 继承 (w:Any h:Regular , w:Regular h:Any , w:Any h:Any)


 也就是说设备当前是：w:Compact h:Compact 则会找出某个视图是否定义了这个SizeClass的界面约束布局，如果没有则找w:Any h:Compact。如果找到了
 则使用，否则继续往上找，直到w:Any h:Any这种尺寸，因为默认所有视图和布局视图的约束设置都是基于w:Any h:Any的。所以总是会找到对应的视图定义的约束的。

 在上述的定义中我们发现了2个问题，一个就是没有一个明确来指定横屏和竖屏这种屏幕的情况；另外一个是iPad设备的宽度和高度都是regular，而无法区分横屏和竖屏。因此这里对
 GTCSizeClass新增加了两个定义：竖屏GTCSizeClass_Portrait和横屏GTCSizeClass_Landscape。我们可以用这两个SizeClass来定义全局横屏以及某类设备的横屏和竖屏

 在默认情况下现有的布局以及子视图的约束设置都是基于w:Any h:Any的,如果我们要为某种SizeClass设置约束则可以调用视图的扩展方法：

 -(instancetype)fetchLayoutSizeClass:(GTCSizeClass)sizeClass;
 -(instancetype)fetchLayoutSizeClass:(GTCSizeClass)sizeClass copyFrom:(GTCSizeClass)srcSizeClass;


 这两个方法需要传递一个宽度的GTCSizeClass定义和高度的GTCSizeClass定义，并通过 | 运算符来组合。 比如：

 1.想设置所有iPhone设备的横屏的约束
 UIView *lsc = [某视图 fetchLayoutSizeClass:GTCSizeClass_wAny|GTCSizeClass_hCompact];

 2.想设置所有iPad设备的横屏的约束
 UIView *lsc = [某视图 fetchLayoutSizeClass: GTCSizeClass_wRegular | GTCSizeClass_hRegular | GTCSizeClass_Landscape];

 3.想设置iphone6plus下的横屏的约束
 UIView *lsc = [某视图 fetchLayoutSizeClass:GTCSizeClass_wRegular|GTCSizeClass_hCompact];

 4.想设置ipad下的约束
 UIView *lsc = [某视图 fetchLayoutSizeClass:GTCSizeClass_wRegular | GTCSizeClass_hRegular];

 5.想设置所有设备下的约束，也是默认的视图的约束
 UIView *lsc = [某视图 fetchLayoutSizeClass:GTCSizeClass_wAny | GTCSizeClass_hAny];

 6.所有设备的竖屏约束：
 UIView *lsc = [某视图 fetchLayoutSizeClass:GTCSizeClass_Portrait];

 7.所有设备的横屏约束：
 UIView *lsc = [某视图 fetchLayoutSizeClass:GTCSizeClass_Landscape];



 fetchLayoutSizeClass虽然返回的是一个instancetype,但实际得到了一个GTCLayoutSizeClass对象或者其派生类，而GTCLayoutSizeClass类中又定义了跟UIView一样相同的布局方法，因此虽然是返回视图对象，并设置各种约束，但实际上是设置GTCLayoutSizeClass对象的各种约束。

 */
typedef NS_ENUM(NSInteger, GTCSizeClass) {
    GTCSizeClasswAny = 0,       //宽度任意尺寸
    GTCSizeClasswCompact = 1,   //宽度压缩尺寸,这个属性在iOS8以下不支持
    GTCSizeClasswRegular = 2,   //宽度常规尺寸,这个属性在iOS8以下不支持

    GTCSizeClasshAny = 0,            //高度任意尺寸
    GTCSizeClasshCompact = 1 << 2,   //高度压缩尺寸,这个属性在iOS8以下不支持
    GTCSizeClasshRegular = 2 << 2,   //高度常规尺寸,这个属性在iOS8以下不支持

    GTCSizeClassAny = 0x0,     //所有设备，等价于GTCSizeClasswAny|GTCSizeClasshAny
    GTCSizeClassPortrait = 0x40,  //竖屏
    GTCSizeClassLandscape = 0x80,  //横屏,注意横屏和竖屏不支持 | 运算操作，只能指定一个。
};


//内部使用
typedef NS_ENUM(NSInteger, GTCLayoutValueType) {
    GTCLayoutValueTypeNil,
    GTCLayoutValueTypeNSNumber,
    GTCLayoutValueTypeLayoutDime,
    GTCLayoutValueTypeLayoutPosition,
    GTCLayoutValueTypeArray,
    GTCLayoutValueTypeUILayoutSupport,
    GTCLayoutValueTypeSafeArea,
};

