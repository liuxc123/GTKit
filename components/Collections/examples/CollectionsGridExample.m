//
//  CollectionsGridExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsGridExample.h"

static const NSInteger kSectionCount = 10;
static const NSInteger kSectionItemCount = 4;
static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsGridExample {
    NSMutableArray <NSMutableArray *>*_content;
    UIAlertController *_actionController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add button to update styles.
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Update Styles"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(presentActionController:)];

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
    self.styler.cellLayoutType = GTCCollectionViewCellLayoutTypeGrid;
    self.styler.gridPadding = 8;
    self.styler.gridColumnCount = 2;

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

#pragma mark - Update Styles

- (void)toggleCellLayoutType {
    // Toggles between list and grid layout.
    BOOL isListLayout = (self.styler.cellLayoutType == GTCCollectionViewCellLayoutTypeList);
    self.styler.cellLayoutType = isListLayout ? GTCCollectionViewCellLayoutTypeGrid : GTCCollectionViewCellLayoutTypeList;
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)toggleCellStyle {
    // Toggles between card and grouped styles.
    BOOL isCardStyle = (self.styler.cellStyle == GTCCollectionViewCellStyleCard);
    self.styler.cellStyle =
    isCardStyle ? GTCCollectionViewCellStyleGrouped : GTCCollectionViewCellStyleCard;
    [self.collectionView performBatchUpdates:nil completion:nil];
}

#pragma mark - Action Controller

- (void)presentActionController:(id)sender {
    _actionController =
    [UIAlertController alertControllerWithTitle:@"Update Styles"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];

    [_actionController addAction:[UIAlertAction actionWithTitle:@"Toggle List/Grid Layout"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self toggleCellLayoutType];
                                                        }]];

    [_actionController addAction:[UIAlertAction actionWithTitle:@"Toggle Card/Grouped Style"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self toggleCellStyle];
                                                        }]];

    [_actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction *action) {
                                                            [self dismissActionController];
                                                        }]];

    [self presentViewController:_actionController animated:YES completion:nil];
}

- (void)dismissActionController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <GTCCollectionViewEditingDelegate>

- (BOOL)collectionViewAllowsSwipeToDismissItem:(UICollectionView *)collectionView {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canSwipeToDismissItemAtIndexPath:(NSIndexPath *)indexPath {
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
    return @[ @"Collections", @"Grid Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}


@end
