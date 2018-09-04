//
//  CollectionsInkExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "GTPalettes.h"
#import "supplemental/CollectionsInkExample.h"

static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsInkExample {
    NSArray *_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];

    // Populate content.
    _content = @[
                 @"Default ink color", @"Custom blue ink color", @"Custom red ink color",
                 @"Ink hidden on this cell"
                 ];

    // Customize collection view settings.
    self.styler.cellStyle = GTCCollectionViewCellStyleCard;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _content.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = _content[indexPath.item];
    return cell;
}

#pragma mark - <GTCCollectionViewStylingDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView
hidesInkViewAtIndexPath:(NSIndexPath *)indexPath {
    // In this example we are not showing ink at a single cell.
    if (indexPath.item == 3) {
        return YES;
    }
    return NO;
}

- (UIColor *)collectionView:(UICollectionView *)collectionView
        inkColorAtIndexPath:(NSIndexPath *)indexPath {
    // Update cell ink colors.
    if (indexPath.item == 1) {
        return [GTCPalette.lightBluePalette.tint500 colorWithAlphaComponent:0.2f];
    } else if (indexPath.item == 2) {
        return [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.2f];
    }
    return nil;
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Cell Ink Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
