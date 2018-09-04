//
//  CollectionsSwipeToDismissRowExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsSwipeToDismissRowExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 5;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsSwipeToDismissRowExample {
    NSMutableArray <NSMutableArray *>*_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];

    // Populate content.
    _content = [NSMutableArray array];
    for (NSInteger i = 0; i < kSectionCount; i++) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger j = 0; j < kSectionItemCount; j++) {
            NSString *itemString = [NSString stringWithFormat:@"Section-%ld Item-%ld", (long)i, (long)j];
            [items addObject:itemString];
        }
        [_content addObject:items];
    }

    // Insert cell that cannot be removed.
    [_content insertObject:[@[ @"This cell cannot be deleted." ] mutableCopy] atIndex:0];

    // Customize collection view settings.
    self.styler.cellStyle = GTCCollectionViewCellStyleCard;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_content count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [_content[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = _content[indexPath.section][indexPath.item];
    return cell;
}

#pragma mark - <GTCCollectionViewEditingDelegate>

- (BOOL)collectionViewAllowsSwipeToDismissItem:(UICollectionView *)collectionView {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canSwipeToDismissItemAtIndexPath:(NSIndexPath *)indexPath {
    // In this example we are allowing all items to be dismissed
    // except this first section.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
willDeleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    // Remove these swiped index paths from our data.
    for (NSIndexPath *indexPath in indexPaths) {
        [_content[indexPath.section] removeObjectAtIndex:indexPath.item];
    }
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Swipe-To-Dismiss-Row Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
