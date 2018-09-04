//
//  CollectionsContainerExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "GTCollections.h"
#import "supplemental/CollectionsContainerExample.h"

static const NSInteger kSectionCount = 2;
static const NSInteger kSectionItemCount = 2;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsContainerExample{
    GTCCollectionViewController *_collectionsController;
    NSMutableArray <NSMutableArray *>*_content;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // Create gray view to contain collection view.
    UIView *container =
    [[UIView alloc] initWithFrame:CGRectMake(30, 200, self.view.bounds.size.width - 60,
                                             self.view.bounds.size.height - 200 - 30)];
    container.backgroundColor = [UIColor lightGrayColor];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:container];

    // Create collection view controller.
    _collectionsController = [[GTCCollectionViewController alloc] init];
    _collectionsController.collectionView.dataSource = self;
    [container addSubview:_collectionsController.view];
    [_collectionsController.view setFrame:container.bounds];

    // Register cell class.
    [_collectionsController.collectionView registerClass:[GTCCollectionViewTextCell class]
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
    _collectionsController.styler.cellStyle = GTCCollectionViewCellStyleCard;

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
    return @[ @"Collections", @"Collections in a Container" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}


@end
