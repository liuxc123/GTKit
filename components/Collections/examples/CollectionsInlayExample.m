//
//  CollectionsInlayExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsInlayExample.h"

static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsInlayExample {
    NSArray *_colors;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _colors = @[ @"red", @"blue", @"green", @"black", @"yellow", @"purple" ];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];

    // Customize collection view settings.
    self.styler.cellStyle = GTCCollectionViewCellStyleCard;
    self.styler.allowsItemInlay = YES;
    self.styler.allowsMultipleItemInlays = YES;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = _colors[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    BOOL isInlaid = [self.styler isItemInlaidAtIndexPath:indexPath];
    if (isInlaid) {
        [self.styler removeInlayFromItemAtIndexPath:indexPath animated:YES];
    } else {
        [self.styler applyInlayToItemAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Cell Inlay Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
