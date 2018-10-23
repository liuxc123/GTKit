//
//  GTDialogConfig.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GTCActionType) {
    /** 默认 */
    GTCActionTypeDefault,
    /** 取消 */
    GTCActionTypeCancel,
    /** 销毁 */
    GTCActionTypeDestructive
};

typedef NS_OPTIONS(NSInteger, GTCActionBorderPosition) {
    /** Action边框位置 上 */
    GTCActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    GTCActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    GTCActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    GTCActionBorderPositionRight    = 1 << 3
};

typedef NS_ENUM(NSInteger, GTCItemType) {
    /** 标题 */
    GTCItemTypeTitle,
    /** 内容 */
    GTCItemTypeContent,
    /** 输入框 */
    GTCItemTypeTextField,
    /** 自定义视图 */
    GTCItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, GTCCustomViewPositionType) {
    /** 居中 */
    GTCCustomViewPositionTypeCenter,
    /** 靠左 */
    GTCCustomViewPositionTypeLeft,
    /** 靠右 */
    GTCCustomViewPositionTypeRight
};


@interface GTDialogConfig : NSObject

@end

@interface GTDialogAction : NSObject

/** action类型 */
@property (nonatomic , assign ) GTCActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic , strong ) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic , strong ) UIImage *backgroundHighlightImage;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) GTCActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^clickHandler)(void);

/** action更新 */
- (void)update;

@end
