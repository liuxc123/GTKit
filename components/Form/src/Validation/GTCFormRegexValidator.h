//
//  GTCFormRegexValidator.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormValidatorProtocol.h"
#import "GTCFormValidationStatus.h"
#import "GTCFormValidator.h"

@interface GTCFormRegexValidator : GTCFormValidator

@property NSString *msg;
@property NSString *regex;

- (instancetype)initWithMsg:(NSString*)msg andRegexString:(NSString*)regex;
+ (GTCFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regex:(NSString *)regex;

@end
