//
//  CollectionsHeaderFooterExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "GTTypography.h"
#import "supplemental/CollectionsHeaderFooterExample.h"

static const NSInteger kSectionCount = 3;
static const NSInteger kSectionItemCount = 2;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsHeaderFooterExample {
    NSMutableArray <NSMutableArray *>*_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];

    // Register header.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:UICollectionElementKindSectionHeader];

    // Register footer.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:UICollectionElementKindSectionFooter];

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
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *supplementaryView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:kind
                                              forIndexPath:indexPath];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            supplementaryView.textLabel.text = @"Section with only header";
        } else {
            supplementaryView.textLabel.text = @"Section header";
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (indexPath.section == 1) {
            supplementaryView.textLabel.text = @"Section with only footer";
        } else {
            supplementaryView.textLabel.text = @"Section footer";
        }
    }

    return supplementaryView;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return CGSizeMake(collectionView.bounds.size.width, GTCCellDefaultOneLineHeight);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    if (section > 0) {
        return CGSizeMake(collectionView.bounds.size.width, GTCCellDefaultOneLineHeight);
    }
    return CGSizeZero;
}

#pragma mark - <GTCCollectionViewStylingDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHideFooterBackgroundForSection:(NSInteger)section {
    return (section == 2);
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Header / Footer Demo" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
