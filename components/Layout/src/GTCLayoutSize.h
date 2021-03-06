//
//  GTCLayoutSize.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import "GTCLayoutDefine.h"

/**
 *视图的布局尺寸类，用来设置视图在布局视图中宽度和高度的尺寸值。布局尺寸类是对尺寸的一个抽象，一个尺寸不一定描述为一个具体的数值，也有可能描述为和另外一个尺寸相等也就是依赖另外一个尺寸，同时一个尺寸可能也会有最大和最小值的限制等等。因此用GTCLayoutSize类来描述这种尺寸的抽象概念。

 @code
 一个尺寸对象的最终尺寸值 = min(max(sizeVal * multiVal + addVal, lBound.sizeVal * lBound.multiVal + lBound.addVal), uBound.sizeVal * uBound.multiVal + uBound.addVal)
 其中:
 sizeVal是通过equalTo方法设置的值。
 multiVal是通过multiply方法设置的值。
 addVal是通过add方法设置的值。
 lBound.sizeVal,lBound.multiVal,lBound.addVal是通过lBound方法设置的值。他表示尺寸的最小边界值。
 uBound.sizeVal,uBound.multiVal,uBound.addVal是通过uBound方法设置的值。他表示尺寸的最大边界值。
 @endcode
 */
@interface GTCLayoutSize : NSObject <NSCopying>

/**特殊的尺寸，表示尺寸由子视图决定或者由内容决定。目前只用在表格布局GTCTableLayout和栅格布局GTCGridLayout中。*/
@property(class, nonatomic, assign,readonly) CGFloat wrap;


/**特殊的尺寸，表示尺寸会填充满父视图的剩余空间。目前只用在表格布局GTCTableLayout和栅格布局GTCGridLayout中。*/
@property(class, nonatomic, assign,readonly) CGFloat fill;

/**特殊的尺寸，表示尺寸会均分父视图的剩余空间。目前只用在表格布局GTCTableLayout */
@property(class, nonatomic, assign,readonly) CGFloat average;


/**
 设置尺寸的具体值，这个具体值可以设置为NSNumber, GTCLayoutSize以及NSArray<GTCLayoutSize*>数组,UIView和nil值。

 1. 设置为NSNumber值表示指定具体的宽度或者高度数值

 2. 设置为GTCLayoutSize值表示宽度和高度与设置的对象有依赖关系, 甚至可以依赖对象本身

 3. 设置为NSArray<GTCLayoutSize*>数组的概念就是所有数组里面的子视图的尺寸平分父视图的尺寸。只有相对布局里面的子视图才支持这种设置。

 4. 设置为UIView的概念就是尺寸依赖于指定视图的相对应的尺寸。

 5. 设置为nil时则清除设置的具体值。
 */
-(GTCLayoutSize* (^)(id val))equalTo;

-(GTCLayoutSize* (^)(id val))gtc_equalTo;

/**
 *设置尺寸增加值，默认值是0。如果设置为负数则表示减少值
 */
-(GTCLayoutSize* (^)(CGFloat val))add;

-(GTCLayoutSize* (^)(CGFloat val))gtc_add;


/**
 * 设置尺寸的放大缩小倍数，默认值是1。
 */
-(GTCLayoutSize* (^)(CGFloat val))multiply;

-(GTCLayoutSize* (^)(CGFloat val))gtc_multiply;


/**
 *设置尺寸的最小边界数值。min方法是lBound方法的简化版本。比如：A.min(10) <==>  A.lBound(@10, 0, 1)
 */
-(GTCLayoutSize* (^)(CGFloat val))min;

-(GTCLayoutSize* (^)(CGFloat val))gtc_min;


/**
 设置尺寸的最小边界值，如果尺寸对象没有设置最小边界值，那么最小边界默认就是无穷小-CGFLOAT_MAX。lBound方法除了能设置为数值外，还可以设置为GTCLayoutSize值，并且还可以指定增量值和倍数值。

 1. 比如我们有一个UILabel的宽度是由内容决定的，但是最小的宽度大于等于父视图的宽度，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).lBound(superview.widthSize, 0, 1);
 @endcode

 2. 比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度大于等于父视图宽度的1/2，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).lBound(superview.widthSize, 0, 0.5);
 @endcode

 3. 比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度大于等于父视图的宽度-30，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).lBound(superview.widthSize, -30, 1);
 @endcode

 4. 比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度不能低于100，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).lBound(@100, 0, 1);
 @endcode

 sizeVal 指定边界的值。可设置的类型有NSNumber和GTCLayoutSize类型，前者表示最小限制不能小于某个常量值，而后者表示最小限制不能小于另外一个尺寸对象所表示的尺寸值。

 addVal 指定边界值的增量值，如果没有增量请设置为0。

 multiVal 指定边界值的倍数值，如果没有倍数请设置为1。
 */
-(GTCLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound;

-(GTCLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))gtc_lBound;


/**
 *设置尺寸的最大边界数值。max方法是uBound方法的简化版本。比如：A.max(10) <==>  A.uBound(@10, 0, 1)
 */
-(GTCLayoutSize* (^)(CGFloat val))max;

-(GTCLayoutSize* (^)(CGFloat val))gtc_max;


/**
 设置尺寸的最大边界值，如果尺寸对象没有设置最大边界值，那么最大边界默认就是无穷大CGFLOAT_MAX。uBound方法除了能设置为数值外，还可以设置为GTCLayoutSize值和nil值，并且还可以指定增量值和倍数值。

 1. 比如我们有一个UILabel的宽度是由内容决定的，但是最大的宽度小于等于父视图的宽度，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).uBound(superview.widthSize, 0, 1);
 @endcode

 2. 比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度小于等于父视图宽度的1/2，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).uBound(superview.widthSize, 0, 0.5);
 @endcode

 3. 比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度小于等于父视图的宽度-30，则设置为：

 @code
 A.widthSize.equalTo(A.widthSize).uBound(superview.widthSize, -30, 1);
 @endcode

 4. 比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度小于等于100，则设置为：
 @code
 A.widthSize.equalTo(A.widthSize).uBound(@100, 0, 1);
 @endcode
 sizeVal 指定边界的值。可设置的类型有NSNumber和GTCLayoutSize类型，前者表示最大限制不能超过某个常量值，而后者表示最大限制不能超过另外一个尺寸对象所表示的尺寸值。

 addVal 指定边界值的增量值，如果没有增量请设置为0。

 multiVal 指定边界值的倍数值，如果没有倍数请设置为1。
 */
-(GTCLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound;

-(GTCLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))gtc_uBound;


/**
 *清除所有设置的约束值，这样尺寸对象将不会再生效了。
 */
-(void)clear;

-(void)gtc_clear;


/**
 *设置布局尺寸是否是活动的,默认是YES表示活动的，如果设置为NO则表示这个布局尺寸对象设置的约束值将不会起作用。
 *active设置为YES和clear的相同点是尺寸对象设置的约束值都不会生效了，区别是前者不会清除所有设置的约束，而后者则会清除所有设置的约束。
 */
@property(nonatomic, assign, getter=isActive) BOOL active;


//上面方法设置的属性的获取。
@property(nonatomic, strong, readonly) id dimeVal;
@property(nonatomic, assign, readonly) CGFloat addVal;
@property(nonatomic, assign, readonly) CGFloat multiVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;


@end
