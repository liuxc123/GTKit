//
//  GTCFormBaseCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "GTCFormDescriptorCell.h"
#import "GTCFormViewController.h"

@class GTCFormViewController;
@class GTCFormRowDescriptor;

@interface GTCFormBaseCell : UITableViewCell <GTCFormDescriptorCell>

@property (nonatomic, weak) GTCFormRowDescriptor * rowDescriptor;

@property (nonatomic, strong) NSIndexPath *indexPath;

-(GTCFormViewController *)formViewController;

@end

@protocol GTCFormReturnKeyProtocol

@property UIReturnKeyType returnKeyType;
@property UIReturnKeyType nextReturnKeyType;

@end
