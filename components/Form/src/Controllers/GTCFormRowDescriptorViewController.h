//
//  GTCFormRowDescriptorViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import <Foundation/Foundation.h>

@class GTCFormRowDescriptor;

@protocol GTCFormRowDescriptorViewController <NSObject>

@required
@property (nonatomic) GTCFormRowDescriptor * rowDescriptor;

@end
