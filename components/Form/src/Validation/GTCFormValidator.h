//
//  GTCFormValidator.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormValidatorProtocol.h"

@interface GTCFormValidator : NSObject <GTCFormValidatorProtocol>

+ (GTCFormValidator *)emailValidator;

+ (GTCFormValidator *)emailValidatorLong;

@end
