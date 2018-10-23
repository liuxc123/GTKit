//
//  GTFormValidatorProtocol.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormRowDescriptor.h"

@class GTCFormValidationStatus;

@protocol GTCFormValidatorProtocol <NSObject>

@required

- (GTCFormValidationStatus *)isValid:(GTCFormRowDescriptor *)row;

@end
