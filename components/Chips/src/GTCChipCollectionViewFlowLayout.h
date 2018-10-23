//
//  GTCChipCollectionViewFlowLayout.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

/*
 GTCChipCollectionViewFlowLayout is a collection view layout suitable for Chips.

 UICollectionViewFlowLayout is a justified alignment. GTCChipCollectionViewFlowLayout aligns cells
 to the leading edge of the collection view.

 Use exactly as you would a standard UICollectionViewLayout. Set minimumInteritemSpacing to control
 spacing between cells.

 @note This layout is incomplete! While this layout is sufficient for most use cases, if you are
 doing complex UICollectionView animations there may be cases where a method falls back to the
 default UICollectionViewFlowLayout behavior. If you are encountering that, please file a bug.
 */
@interface GTCChipCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
