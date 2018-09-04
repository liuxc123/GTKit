//
//  GTCCollectionViewStyler.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTCCollectionViewStyling.h"

/**
 The GTCCollectionViewStyler class provides a default implementation for a UICollectionView to set
 its style properties.
 */
@interface GTCCollectionViewStyler : NSObject <GTCCollectionViewStyling>

- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 Initializes and returns a newly allocated styler object with the specified collection view.

 Designated initializer.

 @param collectionView The controller's collection view.
 */
- (nonnull instancetype)initWithCollectionView:(nonnull UICollectionView *)collectionView
NS_DESIGNATED_INITIALIZER;

@end
