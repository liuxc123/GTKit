//
//  GTCPickerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import <UIKit/UIKit.h>

@interface GTCPickerView : UIPickerView
//
//@property (nonatomic, assign) NSInteger showTag;
//@property (nonatomic, strong) GTCToolBarView *toolBar;
//@property (nonatomic, strong) UIView *containerView;
//
//- (void)showGTCPickerViewWithDataArray:(NSArray<NSString *> *)array commitBlock:(void(^)(NSString *string))commitBlock cancelBlock:(void(^)(void))cancelBlock;
//
//- (void)showGTCPickerViewWithCustomDataArray:(NSArray<NSString *> *)array keyMapper:(NSString *)keyMapper commitBlock:(void(^)(id model))commitBlock cancelBlock:(void(^)(void))cancelBlock;

@end


@interface NSString (GTCPickerView)

@property (nonatomic, copy) NSString *gtc_key;
@property (nonatomic, assign) NSInteger gtc_int_key;

@end
