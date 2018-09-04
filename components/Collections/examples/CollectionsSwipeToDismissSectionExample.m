//
//  CollectionsSwipeToDismissSectionExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsSwipeToDismissSectionExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 5;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsSwipeToDismissSectionExample {
    NSMutableArray <NSArray *>*_content;
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

    // Insert section of cells that cannot be removed.
    [_content insertObject:@[ @"This cell cannot be deleted.", @"This cell cannot be deleted." ]
                   atIndex:0];

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

- (BOOL)collectionViewAllowsSwipeToDismissSection:(UICollectionView *)collectionView {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canSwipeToDismissSection:(NSInteger)section {
    // In this example we are allowing all sections to be dismissed
    // except this first section.
    if (section == 0) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
    willDeleteSections:(NSIndexSet *)sections {
    // Remove these swiped sections from our data.
    [_content removeObjectsAtIndexes:sections];
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Swipe-To-Dismiss-Section Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
