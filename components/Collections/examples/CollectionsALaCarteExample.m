//
//  CollectionsALaCarteExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTTypography.h"
#import "supplemental/CollectionsALaCarteExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 5;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";


#pragma mark - Custom Collection view

/** A custom collection view. */
@interface CustomCollectionView : UICollectionView
@end

/**
 This example demonstrates how a subclass can provide its own collection view and still receive the
 styling and editing capabilities of the GTCCollectionViewController class.
 */
@implementation CustomCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Our custom collection view settings.
        self.backgroundColor = [UIColor lightGrayColor];
        self.contentInset = UIEdgeInsetsMake(40, 20, 40, 20);
    }
    return self;
}

@end

@implementation CollectionsALaCarteExample {
    CustomCollectionView *_customCollectionView;
    NSMutableArray <NSMutableArray *>*_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Here we are setting a custom collection view.
    _customCollectionView = [[CustomCollectionView alloc] initWithFrame:self.collectionView.frame
                                                   collectionViewLayout:self.collectionViewLayout];
    self.collectionView = _customCollectionView;

#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        _customCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }
#endif

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

#pragma mark - <GTCCollectionViewEditingDelegate>

- (BOOL)collectionViewAllowsSwipeToDismissItem:(UICollectionView *)collectionView {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canSwipeToDismissItemAtIndexPath:(NSIndexPath *)indexPath {
    // In this example we are allowing all items to be dismissed.
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
    return @[ @"Collections", @"Collections À la carte" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
