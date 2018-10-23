//
//  GTCFormOptionsViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//
#import "GTCFormRowDescriptorViewController.h"
#import "GTCFormRowDescriptor.h"

@interface GTCFormOptionsViewController : UITableViewController <GTCFormRowDescriptorViewController>

- (instancetype)initWithStyle:(UITableViewStyle)style;


- (instancetype)initWithStyle:(UITableViewStyle)style
           titleHeaderSection:(NSString *)titleHeaderSection
           titleFooterSection:(NSString *)titleFooterSection;

@end
