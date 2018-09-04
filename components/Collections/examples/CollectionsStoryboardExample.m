//
//  CollectionsStoryboardExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsStoryboardExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 5;
static NSString *const kReusableIdentifierItem = @"customCell";

@interface CollectionStoryboardExampleCell : UICollectionViewCell
@property(nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation CollectionsStoryboardExample {
    NSMutableArray <NSMutableArray *>*_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Storyboard Demo";

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
    CollectionStoryboardExampleCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.label.text = _content[indexPath.section][indexPath.item];

    return cell;
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Storyboard Example" ];
}

+ (NSString *)catalogStoryboardName {
    return @"CollectionsStoryboardExample";
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end

@implementation CollectionStoryboardExampleCell
@end
