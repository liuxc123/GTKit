//
//  GTCFormValidationStatus.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>

#import "GTCFormRowDescriptor.h"

@interface GTCFormValidationStatus : NSObject

@property NSString *msg;
@property BOOL isValid;
@property (nonatomic, weak) GTCFormRowDescriptor *rowDescriptor;


//-(instancetype)initWithMsg:(NSString*)msg andStatus:(BOOL)isValid;
-(instancetype)initWithMsg:(NSString*)msg status:(BOOL)isValid rowDescriptor:(GTCFormRowDescriptor *)row;

//+(GTCFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status;
+(GTCFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status rowDescriptor:(GTCFormRowDescriptor *)row;


@end
