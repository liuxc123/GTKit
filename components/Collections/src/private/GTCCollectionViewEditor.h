//
//  GTCCollectionViewEditor.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTCCollectionViewEditing.h"

/**
 The GTCCollectionViewEditingManager class provides an implementation for a UICollectionView to
 set its editing properties.
 */
@interface GTCCollectionViewEditor : NSObject <GTCCollectionViewEditing>

/**
 Initialize the controller with a collection view.

 Designated initializer.

 @param collectionView The controller's collection view.
 */
- (nonnull instancetype)initWithCollectionView:(nullable UICollectionView *)collectionView
NS_DESIGNATED_INITIALIZER;

/** Use initWithCollectionView: instead. */
- (nonnull instancetype)init NS_UNAVAILABLE;

/** Use initWithCollectionView: instead. */
- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;

@end
