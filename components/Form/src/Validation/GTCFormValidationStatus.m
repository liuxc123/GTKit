//
//  GTCFormValidationStatus.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormValidationStatus.h"

@implementation GTCFormValidationStatus

- (instancetype)initWithMsg:(NSString*)msg andStatus:(BOOL)isValid {
    return [self initWithMsg:msg status:isValid rowDescriptor:nil];
}

- (instancetype)initWithMsg:(NSString *)msg status:(BOOL)isValid rowDescriptor:(GTCFormRowDescriptor *)row {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.isValid = isValid;
        self.rowDescriptor = row;
    }
    return self;
}

+ (GTCFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status {
    return [self formValidationStatusWithMsg:msg status:status rowDescriptor:nil];
}

+ (GTCFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status rowDescriptor:(GTCFormRowDescriptor *)row {
    return [[GTCFormValidationStatus alloc] initWithMsg:msg status:status rowDescriptor:row];
}

@end
