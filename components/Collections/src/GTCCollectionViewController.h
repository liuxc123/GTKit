//
//  GTCCollectionViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GTCCollectionViewEditingDelegate.h"
#import "GTCCollectionViewStylingDelegate.h"

@protocol GTCCollectionViewEditing;
@protocol GTCCollectionViewStyling;

/**
 Controller that implements a collection view that adheres to Material Design layout
 and animation styling.
 */
@interface GTCCollectionViewController : UICollectionViewController<
                                            /** Allows for editing notifications/permissions. */
                                            GTCCollectionViewEditingDelegate,

                                            /** Allows for styling updates. */
                                            GTCCollectionViewStylingDelegate,

                                            /** Adheres to flow layout. */
                                            UICollectionViewDelegateFlowLayout>

/** The collection view styler. */
@property(nonatomic, strong, readonly, nonnull) id<GTCCollectionViewStyling> styler;

/** The collection view editor. */
@property(nonatomic, strong, readonly, nonnull) id<GTCCollectionViewEditing> editor;

#pragma mark - Subclassing

/**
 The following methods require a call to super in their overriding implementations to allow
 this collection view controller to properly configure the collection view when in editing mode
 as well as ink during the highlight/unhighlight states.
 */

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (void)collectionView:(nonnull UICollectionView *)collectionView
didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (void)collectionView:(nonnull UICollectionView *)collectionView
didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (void)collectionView:(nonnull UICollectionView *)collectionView
didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (void)collectionView:(nonnull UICollectionView *)collectionView
didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (void)collectionViewWillBeginEditing:(nonnull UICollectionView *)collectionView NS_REQUIRES_SUPER;

- (void)collectionViewWillEndEditing:(nonnull UICollectionView *)collectionView NS_REQUIRES_SUPER;

/**
 * Exposes cell width calculation for subclasses to use when calculating dynamic cell height. Note
 * that this method is only exposed temporarily until self-sizing cells are supported.
 */
- (CGFloat)cellWidthAtSectionIndex:(NSInteger)section;


@end
