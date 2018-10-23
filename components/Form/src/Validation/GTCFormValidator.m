//
//  GTCFormValidator.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormValidationStatus.h"
#import "GTCFormRegexValidator.h"
#import "GTCFormValidator.h"

@implementation GTCFormValidator

- (GTCFormValidationStatus *)isValid:(GTCFormRowDescriptor *)row {
    return [GTCFormValidationStatus formValidationStatusWithMsg:nil status:YES rowDescriptor:row];
}

#pragma mark - Validators

+ (GTCFormValidator *)emailValidator {
    return [GTCFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+ (GTCFormValidator *)emailValidatorLong {
    return [GTCFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,11}"];
}

@end
