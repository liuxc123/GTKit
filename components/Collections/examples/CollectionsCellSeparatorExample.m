//
//  CollectionsCellSeparatorExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "CollectionsCellSeparatorExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 3;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsCellSeparatorExample{
    NSMutableArray <NSMutableArray *>*_content;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];


    // Register header.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:UICollectionElementKindSectionHeader];

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

    // Customize separators.
    if (indexPath.section == 0) {
        cell.separatorInset = UIEdgeInsetsMake(0, 72, 0, 0);
    } else if (indexPath.section == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 72);
    } else if (indexPath.section == 2) {
        cell.shouldHideSeparator = YES;
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *supplementaryView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:kind
                                              forIndexPath:indexPath];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 3) {
            supplementaryView.textLabel.text = @"Header with separator";
        } else if (indexPath.section == 4) {
            supplementaryView.textLabel.text = @"Header without separator";
        }
    }

    return supplementaryView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4) {
        return CGSizeMake(collectionView.bounds.size.width, GTCCellDefaultOneLineHeight);
    }
    return CGSizeZero;
}

#pragma mark - <GTCCollectionViewStylingDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHideItemSeparatorAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 3;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHideHeaderSeparatorForSection:(NSInteger)section {
    return section == 4;
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Cell Separator Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}


@end
