//
//  CollectionsCellColorExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "supplemental/CollectionsCellColorExample.h"

static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsCellColorExample{
    NSMutableArray <NSArray *>*_content;
    NSArray *_cellBackgroundColors;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];

    // Array of cell background colors.
    _cellBackgroundColors = @[
                              [UIColor colorWithWhite:0 alpha:0.2f],
                              [UIColor colorWithRed:(CGFloat)0x39 / (CGFloat)255
                                              green:(CGFloat)0xA4 / (CGFloat)255
                                               blue:(CGFloat)0xDD / (CGFloat)255
                                              alpha:1],
                              [UIColor whiteColor]
                              ];

    // Populate content.
    _content = [NSMutableArray array];
    [_content addObject:@[
                          @"[UIColor colorWithWhite:0 alpha:0.2f]", @"Custom Blue Color", @"Default White Color"
                          ]];

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

#pragma mark - <GTCCollectionViewStylingDelegate>

- (UIColor *)collectionView:(UICollectionView *)collectionView cellBackgroundColorAtIndexPath:(NSIndexPath *)indexPath {
    return _cellBackgroundColors[indexPath.item];
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Cell Color Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
