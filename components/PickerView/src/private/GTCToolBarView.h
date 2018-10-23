//
//  GTCToolBarView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import <UIKit/UIKit.h>

@interface GTCToolBarView : UIView

@property (nonatomic, strong) UILabel *cancelBar;
@property (nonatomic, strong) UILabel *commitBar;
@property (nonatomic, strong) UILabel *titleBar;
@property (nonatomic, strong) UILabel *subTitleBar;


@property (nonatomic, strong) NSString *cancelBarTitle;
@property (nonatomic, strong) UIColor *cancelBarTintColor;
@property (nonatomic, strong) NSString *commitBarTitle;
@property (nonatomic, strong) UIColor *commitBarTintColor;
@property (nonatomic, strong) NSString *titleBarTitle;
@property (nonatomic, strong) UIColor *titleBarTextColor;
@property (nonatomic, strong) NSString *subTitleBarTitle;
@property (nonatomic, strong) UIColor *subTitleBarTextColor;
@property (nonatomic, strong) void (^cancelBlock)(void);
@property (nonatomic, strong) void (^commitBlock)(void);

@end
