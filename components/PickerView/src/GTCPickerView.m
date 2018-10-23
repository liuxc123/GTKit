//
//  GTCPickerView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCPickerView.h"
#import <objc/runtime.h>

@interface GTCPickerView() <UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, strong) NSMutableDictionary *recordDic;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, copy) NSString *keyMapper; //自定义解析Key

@end

@implementation GTCPickerView

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableDictionary *)recordDic {
    if (!_recordDic) {
        _recordDic = [NSMutableDictionary dictionary];
    }
    return _recordDic;
}



@end


@implementation NSString (GTCPickerView)

@dynamic gtc_key, gtc_int_key;

- (void)setGtc_key:(NSString *)gtc_key {
    objc_setAssociatedObject(self, @selector(gtc_key), gtc_key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)gtc_key {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGtc_int_key:(NSInteger)gtc_int_key {
    objc_setAssociatedObject(self, @selector(gtc_int_key), @(gtc_int_key), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)gtc_int_key {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
