//
//  GTCCollectionViewEditing.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import <UIKit/UIKit.h>

@protocol GTCCollectionViewEditingDelegate;

/** The GTCCollectionViewEditing protocol defines the editing state for a UICollectionView. */
@protocol GTCCollectionViewEditing <NSObject>


/** The associated collection view. */
@property(nonatomic, readonly, weak, nullable) UICollectionView *collectionView;

/** The delegate will be informed of editing state changes. */
@property(nonatomic, weak, nullable) id<GTCCollectionViewEditingDelegate> delegate;

/** The index path of the cell being moved or reordered, if any. */
@property(nonatomic, readonly, strong, nullable) NSIndexPath *reorderingCellIndexPath;

/** The index path of the cell being dragged for dismissal, if any. */
@property(nonatomic, readonly, strong, nullable) NSIndexPath *dismissingCellIndexPath;

/** The index of the section being dragged for dismissal, or NSNotFound if none. */
@property(nonatomic, readonly, assign) NSInteger dismissingSection;

/**
 A Boolean value indicating whether the a visible cell within the collectionView is being
 edited.

 When set, all rows show or hide editing controls without animation. To animate the state change see
 @c setEditing:animated:. Setting the editing state of this class does not propagate to the parent
 view controller's editing state.
 */
@property(nonatomic, getter=isEditing) BOOL editing;

/**
 Set the editing state with optional animations.

 When set, row shows or hides editing controls with/without animation. Setting the editing
 state of this class does not propagate to the parent view controller's editing state.

 @param editing YES if editing; otherwise, NO.
 @param animated YES the transition will be animated; otherwise, NO.
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end
