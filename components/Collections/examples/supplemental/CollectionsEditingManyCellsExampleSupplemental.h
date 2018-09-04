//
//  CollectionsEditingManyCellsExampleSupplemental.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import <UIKit/UIKit.h>

#import "GTCollections.h"

static NSString *const kCollectionsEditingManyCellsCellIdentifierItem = @"itemCellIdentifier";
static NSString *const kCollectionsEditingManyCellsHeaderReuseIdentifier = @"EditingExampleHeader";

@interface CollectionsEditingManyCellsExample : GTCCollectionViewController
@property (nonatomic, strong) NSMutableArray <NSMutableArray *>*content;
@end
