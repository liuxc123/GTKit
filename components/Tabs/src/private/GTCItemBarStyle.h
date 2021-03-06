//
//  GTCItemBarStyle.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTInk.h"

@protocol GTCTabBarIndicatorTemplate;

/** Describes the visual style of individual items in an item bar. */
@interface GTCItemBarStyle : NSObject <NSCopying>

/** The default height of the bar. */
@property(nonatomic) CGFloat defaultHeight;

/** Determines if the selection indicator bar should be shown. */
@property(nonatomic) BOOL shouldDisplaySelectionIndicator;

/** Color used for the selection indicator bar which indicates the selected item. */
@property(nonatomic, strong, nullable) UIColor *selectionIndicatorColor;

/** Template defining the selection indicator's appearance. */
@property(nonatomic, nonnull) id<GTCTabBarIndicatorTemplate> selectionIndicatorTemplate;

/** The maximum width for individual items within the bar. If zero, items have no maximum width. */
@property(nonatomic) CGFloat maximumItemWidth;

#pragma mark - Item Style

/** Indicates if the title should be displayed. */
@property(nonatomic) BOOL shouldDisplayTitle;

/** Indicates if the image should be displayed. */
@property(nonatomic) BOOL shouldDisplayImage;

/** Indicates if a badge may be shown. */
@property(nonatomic) BOOL shouldDisplayBadge;

/** Indicates if the cell's components should grow slightly when selected. (Bottom navigation) */
@property(nonatomic) BOOL shouldGrowOnSelection;

/** Color of title text when not selected. Default is opaque white. */
@property(nonatomic, strong, nonnull) UIColor *titleColor;

/** Color of title text when selected. Default is opaque white. */
@property(nonatomic, strong, nonnull) UIColor *selectedTitleColor;

/** Tint color of image when not selected. Default is opaque white. */
@property(nonatomic, strong, nonnull) UIColor *imageTintColor;

/** Tint color of image when selected. Default is opaque white. */
@property(nonatomic, strong, nonnull) UIColor *selectedImageTintColor;

/** Font used for selected item titles. */
@property(nonatomic, strong, nonnull) UIFont *selectedTitleFont;

/** Font used for unselected item titles. */
@property(nonatomic, strong, nonnull) UIFont *unselectedTitleFont;

/** Style of ink animations on item interaction. */
@property(nonatomic) GTCInkStyle inkStyle;

/** Color of ink splashes. Default is 25% white. */
@property(nonatomic, strong, nonnull) UIColor *inkColor;

/** Padding in points between the title and image components, according to the MD spec. */
@property(nonatomic) CGFloat titleImagePadding;

/**
 The number of lines used for each item's title label. Material Design guidelines specifies 2 lines
 for text-only tabs at the top of the view. All other Tabs styles should use a single line of text.

 Default is 1.
 */
@property(nonatomic, assign) NSInteger textOnlyNumberOfLines;

/**
 Indicates if all tab titles should be uppercased for display. If NO, item titles will be
 displayed verbatim.

 Default is YES and is recommended whenever possible.
 */
@property(nonatomic) BOOL displaysUppercaseTitles;

@end

