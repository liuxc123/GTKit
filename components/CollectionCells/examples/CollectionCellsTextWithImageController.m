//
//  CollectionCellsTextWithImageController.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "supplemental/CollectionCellsTextWithImageController.h"

static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";
static NSString *const kExampleText =
@"Pellentesque non quam ornare, porta urna sed, malesuada felis. Praesent at gravida felis, "
"non facilisis enim. Proin dapibus laoreet lorem, in viverra leo dapibus a.";

static const NSUInteger kRowCount = 22;

@implementation CollectionCellsTextWithImageController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return kRowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = kExampleText;

    if (indexPath.item % 3 == 2) {
        NSBundle *bundle = [NSBundle bundleForClass:[CollectionCellsTextWithImageController class]];
        UIImage *cellImage =
        [UIImage imageNamed:@"SixtyThreexSixtyThree" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.imageView.image = cellImage;
    } else if (indexPath.item % 3 == 1) {
        NSBundle *bundle = [NSBundle bundleForClass:[CollectionCellsTextWithImageController class]];
        UIImage *cellImage =
        [UIImage imageNamed:@"FortyxForty" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.imageView.image = cellImage;
    } else {
        cell.imageView.image = nil;
    }

    return cell;
}

#pragma mark - <GTCCollectionViewStylingDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
    cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    return GTCCellDefaultOneLineHeight;
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collection Cells", @"Cell Text with Image Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}
@end
