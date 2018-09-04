//
//  GTCCollectionViewLayoutAttributes.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import <UIKit/UIKit.h>

/** Types of cell ordinal positions available within a collectionView. */
typedef NS_OPTIONS(NSUInteger, GTCCollectionViewOrdinalPosition) {
    /** Cell visually has top edge within section. */
    GTCCollectionViewOrdinalPositionVerticalTop = 1 << 0,

    /** Cell visually has no top/bottom edges within section. */
    GTCCollectionViewOrdinalPositionVerticalCenter = 1 << 1,

    /** Cell visually has bottom edge within section. */
    GTCCollectionViewOrdinalPositionVerticalBottom = 1 << 2,

    /**
     Cell visually has both bottom/top edges within section. Typically for a single or inlaid cell.
     */
    GTCCollectionViewOrdinalPositionVerticalTopBottom =
    (GTCCollectionViewOrdinalPositionVerticalTop |
     GTCCollectionViewOrdinalPositionVerticalBottom),

    /** Cell visually has left edge within section. */
    GTCCollectionViewOrdinalPositionHorizontalLeft = 1 << 10,

    /** Cell visually has no left/right edges within section. */
    GTCCollectionViewOrdinalPositionHorizontalCenter = 1 << 11,

    /** Cell visually has right edge within section. */
    GTCCollectionViewOrdinalPositionHorizontalRight = 1 << 12
};

/**
 The GTCCollectionViewLayoutAttributes class allows passing layout attributes to the cells and
 supplementary views.
 */
@interface GTCCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes <NSCopying>

#pragma mark - Cell Styling

/** A boolean value indicating whether the collectionView is being edited. Defaults to NO. */
@property(nonatomic, getter=isEditing) BOOL editing;

/**
 A boolean value indicating whether the collectionView cell should be displayed with reorder
 state mask. Defaults to NO.
 */
@property(nonatomic, assign) BOOL shouldShowReorderStateMask;

/**
 A boolean value indicating whether the collectionView cell should be displayed with selector
 state mask. Defaults to NO.
 */
@property(nonatomic, assign) BOOL shouldShowSelectorStateMask;

/**
 A Boolean value indicating whether the collection view cell should allow the grid background
 decoration view to be drawn at the specified index.
 */
@property(nonatomic, assign) BOOL shouldShowGridBackground;

/** The image for use as the cells background image. */
@property(nonatomic, strong, nullable) UIImage *backgroundImage;

/** The background image view edge insets. */
@property(nonatomic) UIEdgeInsets backgroundImageViewInsets;

/**
 A boolean value indicating whether the collectionView cell style is set to
 GTCCollectionViewCellLayoutTypeGrid.
 */
@property(nonatomic, assign) BOOL isGridLayout;

/** The ordinal position within the collectionView section. */
@property(nonatomic, assign) GTCCollectionViewOrdinalPosition sectionOrdinalPosition;

#pragma mark - Cell Separator

/** Separator color. Defaults to #E0E0E0. */
@property(nonatomic, strong, nullable) UIColor *separatorColor;

/** Separator inset. Defaults to UIEdgeInsetsZero. */
@property(nonatomic) UIEdgeInsets separatorInset;

/** Separator line height. Defaults to 1.0f */
@property(nonatomic) CGFloat separatorLineHeight;

/** Whether to hide the cell separators. Defaults to NO. */
@property(nonatomic) BOOL shouldHideSeparators;

#pragma mark - Cell Appearance Animation

/** Whether cells will animation on appearance. */
@property(nonatomic, assign) BOOL willAnimateCellsOnAppearance;

/**
 The cell appearance animation duration. Defaults to GTCCollectionViewAnimatedAppearanceDuration.
 */
@property(nonatomic, assign) NSTimeInterval animateCellsOnAppearanceDuration;

/** The cell delay used to stagger fade-in during appearance animation. Defaults to 0. */
@property(nonatomic, assign) NSTimeInterval animateCellsOnAppearanceDelay;

@end
