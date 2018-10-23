//
//  BottomSheetDummyCollectionViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "BottomSheetDummyCollectionViewController.h"

@interface BottomSheetDummyCollectionViewController () <UICollectionViewDataSource>
@end

@interface DummyCollectionViewCell : UICollectionViewCell
@end

@implementation BottomSheetDummyCollectionViewController {
    NSInteger _numItems;
    UICollectionViewFlowLayout *_layout;
}

- (instancetype)initWithNumItems:(NSInteger)numItems {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    if (self = [super initWithCollectionViewLayout:layout]) {
        _layout = layout;

        _numItems = numItems;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[DummyCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([DummyCollectionViewCell class])];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat s = self.view.frame.size.width / 3;
    _layout.itemSize = CGSizeMake(s, s);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _numItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdent = NSStringFromClass([DummyCollectionViewCell class]);
    DummyCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdent forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:(indexPath.row % 2) * 0.2f + 0.8f alpha:1.0f];
    return cell;
}

@end

@implementation DummyCollectionViewCell
@end
