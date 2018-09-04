//
//  GTCCollectionViewFlowLayout.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTCCollectionViewFlowLayout.h"

#import "GTCCollectionViewController.h"
#import "GTCCollectionViewEditingDelegate.h"
#import "GTCCollectionViewStyling.h"
#import "GTCollectionLayoutAttributes.h"
#import "private/GTCCollectionGridBackgroundView.h"
#import "private/GTCCollectionInfoBarView.h"
#import "private/GTCCollectionViewEditor.h"

#include <tgmath.h>

/** The grid background decoration view kind. */
NSString *const kCollectionGridDecorationView = @"GTCCollectionGridDecorationView";

static const NSInteger kSupplementaryViewZIndex = 99;

@implementation GTCCollectionViewFlowLayout{
    NSMutableArray<NSIndexPath *> *_deletedIndexPaths;
    NSMutableArray<NSIndexPath *> *_insertedIndexPaths;
    NSMutableIndexSet *_deletedSections;
    NSMutableIndexSet *_insertedSections;
    NSMutableIndexSet *_headerSections;
    NSMutableIndexSet *_footerSections;
    NSMutableDictionary *_decorationViewAttributeCache;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self commonGTCCollectionViewFlowLayoutInit];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        // TODO(#): Use values from decoder, don't overwrite in commonInit
        [self commonGTCCollectionViewFlowLayoutInit];
    }
    return self;
}

- (void)commonGTCCollectionViewFlowLayoutInit {
    // Defaults.
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsZero;

    // Register decoration view for grid background.
    _decorationViewAttributeCache = [NSMutableDictionary dictionary];
    [self registerClass:[GTCCollectionGridBackgroundView class]
forDecorationViewOfKind:kCollectionGridDecorationView];
}

- (id<GTCCollectionViewEditing>)editor {
    if ([self.collectionView.delegate isKindOfClass:[GTCCollectionViewController class]]) {
        GTCCollectionViewController *controller =
        (GTCCollectionViewController *)self.collectionView.delegate;
        return controller.editor;
    }
    return nil;
}

- (id<GTCCollectionViewStyling>)styler {
    if ([self.collectionView.delegate isKindOfClass:[GTCCollectionViewController class]]) {
        GTCCollectionViewController *controller =
        (GTCCollectionViewController *)self.collectionView.delegate;
        return controller.styler;
    }
    return nil;
}

#pragma mark - UICollectionViewLayout (SubclassingHooks)

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:
(CGRect)rect {
    // If performing appearance animation, increase bounds height in order to retrieve additional
    // offscreen attributes needed during animation.
    rect = [self boundsForAppearanceAnimationWithInitialBounds:rect];
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attributes =
    [[NSMutableArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect]
                                copyItems:YES];

    // Store index path sections of any headers/footers within these attributes.
    [self storeSupplementaryViewsWithAttributes:attributes];

    // Set layout attributes.
    for (GTCCollectionViewLayoutAttributes *attr in attributes) {
        [self updateAttribute:attr];
    }

    // Add info bar header/footer supplementary view if necessary.
    [self addInfoBarAttributesIfNecessary:attributes];

    // Begin cell appearance animation if necessary.
    [self beginCellAppearanceAnimationIfNecessary:attributes];

    // Add a grid background decoration view for each section if necessary.
    [self addDecorationViewIfNecessary:attributes];

    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (!CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size) ||
        self.editor.isEditing) {
        // Invalidate the layout to force cells to respect the new collection view bounds. Doing here
        // removes necessity to implement methods -willRotateToInterfaceOrientation:duration: and/or
        // -viewWillTransitionToSize:withTransitionCoordinator: on the collection view controller.
        [self invalidateLayout];
        return YES;
    }
    return NO;
}

- (void)invalidateLayout {
    [super invalidateLayout];

    // Clear decoration attribute cache.
    [_decorationViewAttributeCache removeAllObjects];
}

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

+ (Class)layoutAttributesClass {
    return [GTCCollectionViewLayoutAttributes class];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr =
    [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    return [self updateAttribute:(GTCCollectionViewLayoutAttributes *)attr];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:
(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ||
        [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // Update section headers/Footers attributes.
        attr = [[super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath] copy];
        if (!attr) {
            attr =
            [GTCCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind
                                                                            withIndexPath:indexPath];
        }
        [self updateAttribute:(GTCCollectionViewLayoutAttributes *)attr];

    } else {
        // Update editing info bar attributes.
        attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind
                                                                              withIndexPath:indexPath];

        // Force the info bar supplementary views to stay fixed to their respective positions
        // at top/bottom of the collectionView bounds.
        CGFloat offsetY = 0;
        CGRect currentBounds = self.collectionView.bounds;
        attr.zIndex = kSupplementaryViewZIndex;

        if ([kind isEqualToString:GTCCollectionInfoBarKindHeader]) {
            attr.size = CGSizeMake(CGRectGetWidth(currentBounds), GTCCollectionInfoBarHeaderHeight);
            // Allow header to move upwards with scroll, but prevent from moving downwards with scroll.
            CGFloat insetTop = self.collectionView.contentInset.top;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
            if (@available(iOS 11.0, *)) {
                insetTop = self.collectionView.adjustedContentInset.top;
            }
#endif
            CGFloat boundsY = currentBounds.origin.y;
            CGFloat maxOffsetY = MAX(boundsY + insetTop, 0);
            offsetY = boundsY + (attr.size.height / 2) + insetTop - maxOffsetY;
        } else if ([kind isEqualToString:GTCCollectionInfoBarKindFooter]) {
            CGFloat height = GTCCollectionInfoBarFooterHeight;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
            if (@available(iOS 11.0, *)) {
                height += self.collectionView.safeAreaInsets.bottom;
            }
#endif
            attr.size = CGSizeMake(CGRectGetWidth(currentBounds), height);
            offsetY = currentBounds.origin.y + currentBounds.size.height - (attr.size.height / 2);
        }
        attr.center = CGPointMake(CGRectGetMidX(currentBounds), offsetY);
    }
    return attr;
}

- (UICollectionViewLayoutAttributes *)
layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
atIndexPath:(NSIndexPath *)indexPath {
    // Check cache for decoration view attributes, and add to cache if they don't exist.
    GTCCollectionViewLayoutAttributes *decorationAttr =
    [_decorationViewAttributeCache objectForKey:indexPath];
    if (!decorationAttr) {
        decorationAttr =
        [GTCCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                     withIndexPath:indexPath];
        [_decorationViewAttributeCache setObject:decorationAttr forKey:indexPath];
    }

    // Determine section frame by summing all of its item frames.
    CGRect sectionFrame = CGRectNull;
    for (NSInteger i = 0; i < [self numberOfItemsInSection:indexPath.section]; ++i) {
        indexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
        UICollectionViewLayoutAttributes *attribute =
        [self layoutAttributesForItemAtIndexPath:indexPath];
        if (!CGRectIsNull(attribute.frame)) {
            sectionFrame = CGRectUnion(sectionFrame, attribute.frame);
        }
    }
    if (!CGRectIsNull(sectionFrame)) {
        decorationAttr.frame = sectionFrame;
    }

    decorationAttr.zIndex = -1;
    return decorationAttr;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(__unused CGPoint)proposedContentOffset {
    // Return current contentOffset to prevent any layout animations from jumping to new offset.
    return [super targetContentOffsetForProposedContentOffset:self.collectionView.contentOffset];
}

#pragma mark - UICollectionViewLayout (UIUpdateSupportHooks)

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    _deletedIndexPaths = [NSMutableArray array];
    _insertedIndexPaths = [NSMutableArray array];
    _deletedSections = [NSMutableIndexSet indexSet];
    _insertedSections = [NSMutableIndexSet indexSet];

    for (UICollectionViewUpdateItem *item in updateItems) {
        if (item.updateAction == UICollectionUpdateActionDelete) {
            // Store deleted sections or indexPaths.
            if (item.indexPathBeforeUpdate.item == NSNotFound) {
                [_deletedSections addIndex:item.indexPathBeforeUpdate.section];
            } else {
                [_deletedIndexPaths addObject:item.indexPathBeforeUpdate];
            }

        } else if (item.updateAction == UICollectionUpdateActionInsert) {
            // Store inserted sections or indexPaths.
            if (item.indexPathAfterUpdate.item == NSNotFound) {
                [_insertedSections addIndex:item.indexPathAfterUpdate.section];
            } else {
                [_insertedIndexPaths addObject:item.indexPathAfterUpdate];
            }
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    _deletedIndexPaths = nil;
    _insertedIndexPaths = nil;
    _deletedSections = nil;
    _insertedSections = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:
(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr =
    [[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath] copy];
    // Adding new section or item.
    if ([_insertedSections containsIndex:itemIndexPath.section] ||
        [_insertedIndexPaths containsObject:itemIndexPath]) {
        attr.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(attr.bounds) / 2);
    } else {
        attr.alpha = 1;
    }
    return attr;
}

- (UICollectionViewLayoutAttributes *)
initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind
atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attr =
    [[super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind
                                                              atIndexPath:elementIndexPath] copy];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] ||
        [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        // Adding new section header or footer.
        if ([_insertedSections containsIndex:elementIndexPath.section]) {
            attr.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(attr.bounds) / 2);
        } else {
            attr.alpha = 1;
        }
    }
    return attr;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:
(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr =
    [[super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath] copy];
    // Deleting section or item.
    if ([_deletedSections containsIndex:itemIndexPath.section] ||
        [_deletedIndexPaths containsObject:itemIndexPath]) {
        attr.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(attr.bounds) / 2);
    } else {
        attr.alpha = 1;
    }
    return attr;
}

- (UICollectionViewLayoutAttributes *)
finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind
atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attr = [[super
                                               finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind
                                               atIndexPath:elementIndexPath] copy];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] ||
        [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        // Deleting section header or footer.
        if ([_deletedSections containsIndex:elementIndexPath.section]) {
            attr.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(attr.bounds) / 2);
        } else {
            attr.alpha = 1;
        }
    }
    return attr;
}

#pragma mark - Header/Footer Caching

- (void)storeSupplementaryViewsWithAttributes:
(NSArray<__kindof UICollectionViewLayoutAttributes *> *)attributes {
    _headerSections = [NSMutableIndexSet indexSet];
    _footerSections = [NSMutableIndexSet indexSet];

    // Store index path sections for headers/footers.
    for (GTCCollectionViewLayoutAttributes *attr in attributes) {
        if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [_headerSections addIndex:attr.indexPath.section];
        } else if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            [_footerSections addIndex:attr.indexPath.section];
        }
    }
}

#pragma mark - Private

- (GTCCollectionViewLayoutAttributes *)updateAttribute:(GTCCollectionViewLayoutAttributes *)attr {
    if (attr.representedElementCategory == UICollectionElementCategoryCell) {
        attr.editing = self.editor.isEditing;
    }
    attr.isGridLayout = NO;
    if (self.styler.cellLayoutType == GTCCollectionViewCellLayoutTypeList) {
        attr.sectionOrdinalPosition = [self ordinalPositionForListElementWithAttribute:attr];
    } else if (self.styler.cellLayoutType == GTCCollectionViewCellLayoutTypeGrid) {
        attr.sectionOrdinalPosition = [self ordinalPositionForGridElementWithAttribute:attr];
        attr.isGridLayout = YES;
    }

    [self updateCellStateMaskWithAttribute:attr];

    if (attr.representedElementCategory == UICollectionElementCategorySupplementaryView) {
        attr = [self updateSupplementaryViewAttribute:attr];
    }

    // Set cell background.
    attr.backgroundImage = [self.styler backgroundImageForCellLayoutAttributes:attr];
    attr.backgroundImageViewInsets =
    [self.styler backgroundImageViewOutsetsForCellWithAttribute:attr];

    // Set separator styling.
    attr.separatorColor = self.styler.separatorColor;
    attr.separatorInset = self.styler.separatorInset;
    attr.separatorLineHeight = self.styler.separatorLineHeight;
    attr.shouldHideSeparators = [self.styler shouldHideSeparatorForCellLayoutAttributes:attr];

    // Set inlay and hidden state if necessary.
    [self inlayAttributeIfNecessary:attr];
    [self hideAttributeIfNecessary:attr];

    return attr;
}

- (GTCCollectionViewLayoutAttributes *)updateSupplementaryViewAttribute:
(GTCCollectionViewLayoutAttributes *)attr {
    // In vertical scrolling, supplementary views only respect their height and ignore their width
    // value. The opposite is true for horizontal scrolling. Therefore we must manually set insets
    // on both the backgroundView and contentView in order to match the insets of the collection
    // view rows.
    CGRect insetFrame = attr.frame;
    if (!CGRectIsEmpty(insetFrame)) {
        UIEdgeInsets insets;

        // Retrieve the insets from the Flow Layout delegate to maintain consistency with the CVC
        if ([self.collectionView.delegate
             respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            id<UICollectionViewDelegateFlowLayout> flowLayoutDelegate =
            (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
            insets = [flowLayoutDelegate collectionView:self.collectionView
                                                 layout:self.collectionView.collectionViewLayout
                                 insetForSectionAtIndex:attr.indexPath.section];
        } else {
            insets = [self insetsAtSectionIndex:attr.indexPath.section];
        }

        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            insetFrame = CGRectInset(insetFrame, insets.left / 2 + insets.right / 2, 0);
            if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                insetFrame.origin.y += insets.top;
            } else if ([attr.representedElementKind
                        isEqualToString:UICollectionElementKindSectionFooter]) {
                insetFrame.origin.y -= insets.bottom;
            }
            attr.frame = insetFrame;
        }
    }
    return attr;
}

- (UIEdgeInsets)insetsAtSectionIndex:(NSInteger)section {
    // Determine insets based on cell style.
    CGFloat inset = (CGFloat)floor(GTCCollectionViewCellStyleCardSectionInset);
    UIEdgeInsets insets = UIEdgeInsetsZero;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    BOOL isTop = (section == 0);
    BOOL isBottom = (section == numberOfSections - 1);
    GTCCollectionViewCellStyle cellStyle = [self.styler cellStyleAtSectionIndex:section];
    BOOL isCardStyle = cellStyle == GTCCollectionViewCellStyleCard;
    BOOL isGroupedStyle = cellStyle == GTCCollectionViewCellStyleGrouped;
    // Set left/right insets.
    if (isCardStyle) {
        insets.left = inset;
        insets.right = inset;
    }
    // Set top/bottom insets.
    if (isCardStyle || isGroupedStyle) {
        insets.top = (CGFloat)floor((isTop) ? inset : inset / 2.0f);
        insets.bottom = (CGFloat)floor((isBottom) ? inset : inset / 2.0f);
    }
    return insets;
}

- (GTCCollectionViewOrdinalPosition)ordinalPositionForListElementWithAttribute:
(GTCCollectionViewLayoutAttributes *)attr {
    // Returns the ordinal position of cells and supplementary views within a list layout. This is
    // used to determine the layout attributes applied to their styling.
    GTCCollectionViewOrdinalPosition position = 0;
    NSIndexPath *indexPath = attr.indexPath;
    NSInteger numberOfItemsInSection = [self numberOfItemsInSection:indexPath.section];
    BOOL isTop = NO;
    BOOL isBottom = NO;
    BOOL hasSectionHeader = [_headerSections containsIndex:indexPath.section];
    BOOL hasSectionFooter = [_footerSections containsIndex:indexPath.section];
    BOOL hasSectionItems = [self numberOfItemsInSection:indexPath.section] > 0;

    BOOL hidesHeaderBackground = NO;
    if ([self.styler.delegate
         respondsToSelector:@selector(collectionView:shouldHideHeaderBackgroundForSection:)]) {
        hidesHeaderBackground = [self.styler.delegate collectionView:self.styler.collectionView
                                shouldHideHeaderBackgroundForSection:indexPath.section];
    }

    BOOL hidesFooterBackground = NO;
    if ([self.styler.delegate
         respondsToSelector:@selector(collectionView:shouldHideFooterBackgroundForSection:)]) {
        hidesFooterBackground = [self.styler.delegate collectionView:self.styler.collectionView
                                shouldHideFooterBackgroundForSection:indexPath.section];
    }

    if (attr.representedElementCategory == UICollectionElementCategoryCell) {
        isTop = (indexPath.item == 0) && (!hasSectionHeader || hidesHeaderBackground);
        isBottom = (indexPath.item == numberOfItemsInSection - 1) &&
        (!hasSectionFooter || hidesFooterBackground);
    } else if (attr.representedElementCategory == UICollectionElementCategorySupplementaryView) {
        NSString *kind = attr.representedElementKind;
        BOOL isElementHeader = ([kind isEqualToString:UICollectionElementKindSectionHeader]);
        BOOL isElementFooter = ([kind isEqualToString:UICollectionElementKindSectionFooter]);
        isTop = (isElementFooter && !hasSectionItems && !hasSectionHeader) || isElementHeader;
        isBottom = (isElementHeader && !hasSectionItems && !hasSectionFooter) || isElementFooter;
    }

    if (attr.editing || [self.styler isItemInlaidAtIndexPath:attr.indexPath]) {
        isTop = YES;
        isBottom = YES;
    }

    if (!isTop && !isBottom) {
        position |= GTCCollectionViewOrdinalPositionVerticalCenter;
    } else {
        position |= isTop ? GTCCollectionViewOrdinalPositionVerticalTop : position;
        position |= isBottom ? GTCCollectionViewOrdinalPositionVerticalBottom : position;
    }
    return position;
}

- (GTCCollectionViewOrdinalPosition)ordinalPositionForGridElementWithAttribute:
(GTCCollectionViewLayoutAttributes *)attr {
    // Returns the ordinal position of cells and supplementary views within a grid layout. This is
    // used to determine the layout attributes applied to their styling.
    GTCCollectionViewOrdinalPosition position = 0;
    NSIndexPath *indexPath = attr.indexPath;
    NSInteger numberOfItemsInSection = [self numberOfItemsInSection:indexPath.section];
    NSInteger gridColumnCount = self.styler.gridColumnCount;
    NSInteger maxRowIndex = (NSInteger)(floor(numberOfItemsInSection / gridColumnCount) - 1);
    NSInteger maxColumnIndex = gridColumnCount - 1;
    NSInteger ordinalRow = (NSInteger)(floor(indexPath.item / gridColumnCount));
    NSInteger ordinalColumn = (NSInteger)(floor(indexPath.item % gridColumnCount));

    // Set vertical ordinal position.
    if (ordinalRow > 0 && ordinalRow < maxRowIndex) {
        position = position | GTCCollectionViewOrdinalPositionVerticalCenter;
    } else {
        position =
        (ordinalRow == 0) ? position | GTCCollectionViewOrdinalPositionVerticalTop : position;
        position = (ordinalRow == maxRowIndex)
        ? position | GTCCollectionViewOrdinalPositionVerticalBottom
        : position;
    }

    // Set horizontal ordinal position.
    if (ordinalColumn > 0 && ordinalColumn < maxColumnIndex) {
        position = position | GTCCollectionViewOrdinalPositionHorizontalCenter;
    } else {
        position =
        (ordinalColumn == 0) ? position | GTCCollectionViewOrdinalPositionHorizontalLeft : position;
        position = (ordinalColumn == maxColumnIndex)
        ? position | GTCCollectionViewOrdinalPositionHorizontalRight
        : position;
    }
    return position;
}

- (void)updateCellStateMaskWithAttribute:(GTCCollectionViewLayoutAttributes *)attr {
    attr.shouldShowSelectorStateMask = NO;
    attr.shouldShowReorderStateMask = NO;

    // Determine proper state to show cell if editing.
    if (attr.editing) {
        if ([self.collectionView.dataSource
             conformsToProtocol:@protocol(GTCCollectionViewEditingDelegate)]) {
            id<GTCCollectionViewEditingDelegate> editingDelegate =
            (id<GTCCollectionViewEditingDelegate>)self.collectionView.dataSource;

            // Check if delegate can select during editing.
            if ([editingDelegate respondsToSelector:@selector
                 (collectionView:canSelectItemDuringEditingAtIndexPath:)]) {
                attr.shouldShowSelectorStateMask = [editingDelegate collectionView:self.collectionView
                                             canSelectItemDuringEditingAtIndexPath:attr.indexPath];
            }

            // Check if delegate can reorder.
            if ([editingDelegate respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
                attr.shouldShowReorderStateMask = [editingDelegate collectionView:self.collectionView
                                                           canMoveItemAtIndexPath:attr.indexPath];
            }
        }
    }
}

- (void)inlayAttributeIfNecessary:(GTCCollectionViewLayoutAttributes *)attr {
    // Inlay this attribute if necessary.
    CGFloat inset = GTCCollectionViewCellStyleCardSectionInset;
    UIEdgeInsets inlayInsets = UIEdgeInsetsZero;
    NSInteger item = attr.indexPath.item;
    NSArray<NSIndexPath *> *inlaidIndexPaths = [self.styler indexPathsForInlaidItems];

    // Update ordinal position for index paths adjacent to inlaid index path.
    for (NSIndexPath *inlaidIndexPath in inlaidIndexPaths) {
        if (inlaidIndexPath.section == attr.indexPath.section) {
            NSInteger numberOfItemsInSection = [self numberOfItemsInSection:inlaidIndexPath.section];
            if (attr.representedElementCategory == UICollectionElementCategoryCell) {
                if (item == inlaidIndexPath.item) {
                    // Get previous and next index paths to the inlaid index path.
                    BOOL prevAttrIsInlaid = NO;
                    BOOL nextAttrIsInlaid = NO;
                    BOOL hasSectionHeader = [_headerSections containsIndex:inlaidIndexPath.section];
                    BOOL hasSectionFooter = [_footerSections containsIndex:inlaidIndexPath.section];

                    if (inlaidIndexPath.item > 0 || hasSectionHeader) {
                        NSIndexPath *prevIndexPath = [NSIndexPath indexPathForItem:(inlaidIndexPath.item - 1)
                                                                         inSection:inlaidIndexPath.section];
                        prevAttrIsInlaid = [self.styler isItemInlaidAtIndexPath:prevIndexPath];
                        inlayInsets.top = prevAttrIsInlaid ? inset / 2 : inset;
                    }

                    if (inlaidIndexPath.item < numberOfItemsInSection - 1 || hasSectionFooter) {
                        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:(inlaidIndexPath.item + 1)
                                                                         inSection:inlaidIndexPath.section];
                        nextAttrIsInlaid = [self.styler isItemInlaidAtIndexPath:nextIndexPath];
                        inlayInsets.bottom = nextAttrIsInlaid ? inset / 2 : inset;
                    }

                    // Is attribute to be inlaid.
                    attr.frame = UIEdgeInsetsInsetRect(attr.frame, inlayInsets);
                    attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalTopBottom;
                } else if (item == inlaidIndexPath.item - 1) {
                    // Is previous to inlaid attribute.
                    if (attr.sectionOrdinalPosition & GTCCollectionViewOrdinalPositionVerticalTop) {
                        attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalTopBottom;
                    } else if (attr.sectionOrdinalPosition & GTCCollectionViewOrdinalPositionVerticalCenter) {
                        attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalBottom;
                    }
                } else if (item == inlaidIndexPath.item + 1) {
                    // Is next to inlaid attribute.
                    if (attr.sectionOrdinalPosition & GTCCollectionViewOrdinalPositionVerticalCenter) {
                        attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalTop;
                    } else if (attr.sectionOrdinalPosition & GTCCollectionViewOrdinalPositionVerticalBottom) {
                        attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalBottom;
                    }
                }

            } else if (attr.representedElementCategory == UICollectionElementCategorySupplementaryView) {
                // If header/footer attribute, update if adjacent to inlaid index path.
                NSString *kind = attr.representedElementKind;
                BOOL isElementHeader = ([kind isEqualToString:UICollectionElementKindSectionHeader]);
                BOOL isElementFooter = ([kind isEqualToString:UICollectionElementKindSectionFooter]);
                if (isElementHeader && inlaidIndexPath.item == 0) {
                    attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalTopBottom;
                } else if (isElementFooter && inlaidIndexPath.item == numberOfItemsInSection - 1) {
                    attr.sectionOrdinalPosition = GTCCollectionViewOrdinalPositionVerticalTopBottom;
                }
            }
        }
    }
}

- (void)hideAttributeIfNecessary:(GTCCollectionViewLayoutAttributes *)attr {
    if (self.editor) {
        // Hide the attribute if the editor is either currently handling a cell item or section swipe
        // for dismissal, or is reordering a cell item.
        BOOL isCell = attr.representedElementCategory == UICollectionElementCategoryCell;
        if (attr.indexPath.section == self.editor.dismissingSection ||
            ([attr.indexPath isEqual:self.editor.dismissingCellIndexPath] && isCell) ||
            ([attr.indexPath isEqual:self.editor.reorderingCellIndexPath] && isCell)) {
            attr.hidden = YES;
        }
    }
}

- (void)addInfoBarAttributesIfNecessary:
(NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *)attributes {
    if (self.editor.isEditing && [attributes count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];

        // Add header info bar if editing.
        [attributes
         addObject:[self layoutAttributesForSupplementaryViewOfKind:GTCCollectionInfoBarKindHeader
                                                        atIndexPath:indexPath]];

        // Add footer info bar if editing and item(s) are selected.
        NSInteger selectedItemCount = [self.collectionView.indexPathsForSelectedItems count];
        if (selectedItemCount > 0) {
            [attributes
             addObject:[self layoutAttributesForSupplementaryViewOfKind:GTCCollectionInfoBarKindFooter
                                                            atIndexPath:indexPath]];
        }
    }
}

- (void)addDecorationViewIfNecessary:
(NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *)attributes {
    // If necessary, adds a decoration view to a section drawn below its items. This will only happen
    // for a grid layout when it is either A) grouped-style or B) card-style with zero padding. When
    // this happens, the background for those items will not be drawn, and instead this decoration
    // view will extend to the bounds of the sum of its respective section item frames. Shadowing and
    // border will be applied to this decoration view as per the styler settings.
    if (self.styler.cellLayoutType == GTCCollectionViewCellLayoutTypeGrid) {
        NSMutableSet *sectionSet = [NSMutableSet set];
        BOOL shouldShowGridBackground = NO;
        NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *decorationAttributes =
        [NSMutableArray array];
        for (GTCCollectionViewLayoutAttributes *attr in attributes) {
            NSInteger section = attr.indexPath.section;

            // Only add one decoration view per section.
            if (![sectionSet containsObject:@(section)]) {
                NSIndexPath *decorationIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                GTCCollectionViewLayoutAttributes *decorationAttr =
                (GTCCollectionViewLayoutAttributes *)[self
                                                      layoutAttributesForDecorationViewOfKind:kCollectionGridDecorationView
                                                      atIndexPath:decorationIndexPath];
                shouldShowGridBackground = [self shouldShowGridBackgroundWithAttribute:decorationAttr];
                decorationAttr.shouldShowGridBackground = shouldShowGridBackground;
                decorationAttr.backgroundImage =
                shouldShowGridBackground
                ? [self.styler backgroundImageForCellLayoutAttributes:decorationAttr]
                : nil;
                [decorationAttributes addObject:decorationAttr];
                [sectionSet addObject:@(section)];
            }
            if (shouldShowGridBackground) {
                attr.backgroundImage = nil;
            }
        }
        [attributes addObjectsFromArray:decorationAttributes];
    }
}

- (BOOL)shouldShowGridBackgroundWithAttribute:(__unused GTCCollectionViewLayoutAttributes *)attr {
    // Determine whether to show grid background.
    if (self.styler.cellLayoutType == GTCCollectionViewCellLayoutTypeGrid) {
        if (self.styler.cellStyle == GTCCollectionViewCellStyleGrouped ||
            (self.styler.cellStyle == GTCCollectionViewCellStyleCard && self.styler.gridPadding == 0)) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.collectionView numberOfItemsInSection:section];
}

#pragma mark - Cell Appearance Animation

- (CGRect)boundsForAppearanceAnimationWithInitialBounds:(CGRect)initialBounds {
    // Increase initial bounds by 25% allowing offscreen attributes to be included in the
    // appearance animation.
    if (self.styler.shouldAnimateCellsOnAppearance && self.styler.willAnimateCellsOnAppearance) {
        CGRect newBounds = initialBounds;
        newBounds.size.height += (newBounds.size.height / 4);
        return newBounds;
    }
    return initialBounds;
}

- (void)beginCellAppearanceAnimationIfNecessary:
(NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *)attributes {
    // Here we want to assign a delay to each attribute such that the animation will fade-in from the
    // top downwards in a staggered manner. However, the array of attributes we receive here are not
    // in the correct order and must be sorted and re-ordered to properly assign these delays.
    //
    // First we will sort the array of attributes by index path to ensure proper ordering. Secondly
    // we will manipulate the array to bring any headers before their first respective cell items.
    //
    // When completed, we will end up with an array of attributes in the form of
    // header -> item -> footer ... repeated for each section. Now we can use this ordered array
    // to assign delays based on their proper ordinal position from top down.
    __block NSInteger attributeCount = attributes.count;
    NSTimeInterval duration = self.styler.animateCellsOnAppearanceDuration;
    if (self.styler.shouldAnimateCellsOnAppearance && attributeCount > 0) {
        // First sort by index path.
        NSArray<__kindof UICollectionViewLayoutAttributes *> *sortedByIndexPath = [attributes
                                                                                   sortedArrayUsingComparator:^NSComparisonResult(GTCCollectionViewLayoutAttributes *attr1,
                                                                                                                                  GTCCollectionViewLayoutAttributes *attr2) {
                                                                                       return [attr1.indexPath compare:attr2.indexPath];
                                                                                   }];

        // Next create new array containing attributes in the form of header -> item -> footer.
        NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *sortedAttributes =
        [NSMutableArray array];
        [sortedByIndexPath enumerateObjectsUsingBlock:^(GTCCollectionViewLayoutAttributes *attr,
                                                        __unused NSUInteger idx, __unused BOOL *stop) {
            if (sortedAttributes.count > 0) {
                // Check if current attribute is a header and previous attribute is an item. If so,
                // insert the current header attribute before the cell.
                GTCCollectionViewLayoutAttributes *prevAttr =
                [sortedAttributes objectAtIndex:sortedAttributes.count - 1];
                BOOL prevAttrIsItem =
                prevAttr.representedElementCategory == UICollectionElementCategoryCell;
                BOOL attrIsHeader =
                [attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader];
                if (attrIsHeader && prevAttrIsItem) {
                    [sortedAttributes insertObject:attr atIndex:sortedAttributes.count - 1];
                    return;
                }
                if ([attr.representedElementKind isEqualToString:GTCCollectionInfoBarKindHeader] ||
                    [attr.representedElementKind isEqualToString:GTCCollectionInfoBarKindFooter]) {
                    // Reduce the attributeCount here to reflect only attributes that can be animated.
                    attributeCount--;
                    return;
                }
            }
            [sortedAttributes addObject:attr];
        }];

        // Now assign delays and add padding to frame Y coordinate which gets removed during animation.
        [sortedAttributes enumerateObjectsUsingBlock:^(GTCCollectionViewLayoutAttributes *attr,
                                                       NSUInteger idx, __unused BOOL *stop) {
            // If the element is an info bar header, then don't do anything.
            attr.willAnimateCellsOnAppearance = self.styler.willAnimateCellsOnAppearance;
            attr.animateCellsOnAppearanceDuration = self.styler.animateCellsOnAppearanceDuration;
            attr.animateCellsOnAppearanceDelay =
            (attributeCount > 0) ? ((CGFloat)idx / attributeCount) * duration : 0;

            if (self.styler.willAnimateCellsOnAppearance) {
                CGRect frame = attr.frame;
                frame.origin.y += self.styler.animateCellsOnAppearancePadding;
                attr.frame = frame;
            }
        }];

        // Call asynchronously to allow the current layout cycle to complete before issuing animations.
        if (self.styler.willAnimateCellsOnAppearance) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.styler beginCellAppearanceAnimation];
            });
        }
    }
}


@end
