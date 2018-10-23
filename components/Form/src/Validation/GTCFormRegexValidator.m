//
//  GTCFormRegexValidator.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormRegexValidator.h"

@implementation GTCFormRegexValidator

- (instancetype)initWithMsg:(NSString *)msg andRegexString:(NSString *)regex {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.regex = regex;
    }

    return self;
}

- (GTCFormValidationStatus *)isValid: (GTCFormRowDescriptor *)row {
    if (row != nil && row.value != nil) {
        // we only validate if there is a value
        // assumption: required validation is already triggered
        // if this field is optional, we only validate if there is a value
        id value = row.value;
        if ([value isKindOfClass:[NSNumber class]]){
            value = [value stringValue];
        }
        if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
            BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex] evaluateWithObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            return [GTCFormValidationStatus formValidationStatusWithMsg:self.msg status:isValid rowDescriptor:row];
        }
    }
    return nil;
};

+ (GTCFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regex:(NSString *)regex {
    return [[GTCFormRegexValidator alloc] initWithMsg:msg andRegexString:regex];
}

@end
