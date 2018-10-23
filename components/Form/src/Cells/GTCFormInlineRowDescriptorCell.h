//
//  GTCFormInlineRowDescriptorCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormDescriptorCell.h"

@protocol GTCFormInlineRowDescriptorCell <GTCFormDescriptorCell>

@property (nonatomic, weak) GTCFormRowDescriptor * inlineRowDescriptor;

@end
