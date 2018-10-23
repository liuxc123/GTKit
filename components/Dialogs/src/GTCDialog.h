//
//  GTCDialog.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTCDialog : NSObject

@end

#pragma mark - ===================配置模型===================

/** ✨通用设置 样式 */

@interface GTCDialogConfigModel : NSObject

/** 设置 标题  */
@property (nonatomic, copy, readwrite) NSString *title;

/** 设置 内容  */
@property (nonatomic, copy, readwrite) NSString *content;

/** 设置 自定义视图 */
@property (nonatomic, copy, readwrite) UIView *customView;

@end
