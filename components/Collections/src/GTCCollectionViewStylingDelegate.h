//
//  GTCCollectionViewStylingDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import <UIKit/UIKit.h>

#import "GTCCollectionViewStyling.h"

@class GTCInkTouchController;
@class GTCInkView;

/** A delegate protocol which allows setting collection view cell styles. */
@protocol GTCCollectionViewStylingDelegate <NSObject>
@optional

#pragma mark - Styling

/**
 Asks the delegate for the cell height at the specified collection view index path. The style
 controller will make padding/insets adjustments to this value as needed depending on the cell
 style and editing mode.

 @param collectionView The collection view.
 @param indexPath The item's index path.
 @return The cell height at the specified index path.
 */
- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView
    cellHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Asks the delegate for the cell style at the specified collection view section index. All
 remaining sections to have their cells styled per the styler @c cellStyle property.

 @param collectionView The collection view.
 @param section The collection view section.
 @return The cell style to be used at the specified index.
 */
- (GTCCollectionViewCellStyle)collectionView:(nonnull UICollectionView *)collectionView
                         cellStyleForSection:(NSInteger)section;

/**
 Asks the delegate for the cell background color at the specified collection view index path.

 @param collectionView The collection view.
 @param indexPath The item's index path.
 @return The cell background color at the specified index path.
 */
- (nullable UIColor *)collectionView:(nonnull UICollectionView *)collectionView
      cellBackgroundColorAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Asks the delegate whether the specified item should hide its background image/shadowing.

 @param collectionView The collection view.
 @param indexPath The item's index path.
 @return If the item background should be hidden at the specified index path.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHideItemBackgroundAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Asks the delegate whether the specified header should hide its background image/shadowing.

 @param collectionView The collection view.
 @param section The collection view section.
 @return If the header background should be hidden at the specified section.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHideHeaderBackgroundForSection:(NSInteger)section;

/**
 Asks the delegate whether the specified footer should hide its background image/shadowing.

 @param collectionView The collection view.
 @param section The collection view section.
 @return If the footer background should be hidden at the specified section.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHideFooterBackgroundForSection:(NSInteger)section;

#pragma mark - Separator

/**
 Asks the delegate whether the specified item should hide its separator.

 @param collectionView The collection view.
 @param indexPath The item's index path.
 @return If the item separator should be hidden at the specified index path.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHideItemSeparatorAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Asks the delegate whether the specified header should hide its separator.

 @param collectionView The collection view.
 @param section The collection view section.
 @return If the header separator should be hidden at the specified section.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHideHeaderSeparatorForSection:(NSInteger)section;

/**
 Asks the delegate whether the specified footer should hide its separator.

 @param collectionView The collection view.
 @param section The collection view section.
 @return If the footer separator should be hidden at the specified section.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
shouldHideFooterSeparatorForSection:(NSInteger)section;

#pragma mark - Item inlaying

/**
 Allows the receiver to receive notification that items at the specified index paths did
 inlay their frame.

 @param collectionView The collection view.
 @param indexPaths An array of index paths.
 */
- (void)collectionView:(nonnull UICollectionView *)collectionView
didApplyInlayToItemAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths;

/**
 Allows the receiver to receive notification that items at the specified index paths did
 remove the inlay of their frames.

 @param collectionView The collection view.
 @param indexPaths An array of index paths.
 */
- (void)collectionView:(nonnull UICollectionView *)collectionView
didRemoveInlayFromItemAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths;

#pragma mark - Ink Touches

/**
 Asks the delegate whether the inkView for a specified index path should be hidden.

 @param collectionView The collection view.
 @param indexPath The collection view index path.
 @return If the ink view should be hidden at the specified index path.
 */
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
hidesInkViewAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Asks the delegate for the ink color at the specified index path.

 If nil, defaults to GTCInkView defaultInkColor.

 @param collectionView The collection view.
 @param indexPath The collection view index path.
 @return The ink color at the specified index path.
 */
- (nullable UIColor *)collectionView:(nonnull UICollectionView *)collectionView
                 inkColorAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Allows the receiver to set the ink view at the specified collection view index path.

 @param collectionView The collection view.
 @param inkTouchController The ink controller of the ink view.
 @param indexPath The collection view index path.
 @return The inkView to be used at the specified index path.
 */
- (nonnull GTCInkView *)collectionView:(nonnull UICollectionView *)collectionView
                    inkTouchController:(nonnull GTCInkTouchController *)inkTouchController
                    inkViewAtIndexPath:(nonnull NSIndexPath *)indexPath;
@end
