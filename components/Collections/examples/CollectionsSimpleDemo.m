//
//  CollectionsSimpleDemo.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "GTTypography.h"
#import "supplemental/CollectionsSimpleDemo.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 5;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsSimpleDemo {
    NSMutableArray <NSMutableArray *>*_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Simple Demo";

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

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Simple Demo" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return YES;
}

+ (NSString *)catalogDescription {
    return @"Material Collections enables a native collection view controller to have Material "
    "design layout and styling. It also provides editing and extensive customization "
    "capabilities.";
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
