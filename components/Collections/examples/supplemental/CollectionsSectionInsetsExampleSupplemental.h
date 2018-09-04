//
//  CollectionsSectionInsetsExampleSupplemental.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import <UIKit/UIKit.h>

#import "GTCollections.h"

static const NSInteger kSectionCount = 5;
static const NSInteger kSectionItemCount = 3;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@interface CollectionsSectionInsetsExample : GTCCollectionViewController
@property(nonatomic, readonly, copy) NSMutableArray <NSMutableArray *>*content;
@property(nonatomic, readonly, copy) NSMutableDictionary *sectionUsesCustomInsets;
@end
