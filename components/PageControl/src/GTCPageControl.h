//
//  GTCPageControl.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/27.
//

#import <UIKit/UIKit.h>

/**
 A Material page control.

 This control is designed to be a drop-in replacement for UIPageControl, but adhering to the
 Material Design specifications for animation and layout.

 The UIControlEventValueChanged control event is sent when the user changes the current page.

 ### UIScrollViewDelegate

 In order for the Page Control to respond correctly to scroll events set the scrollView.delegate to
 your pageControl:

 scrollView.delegate = pageControl;

 or forward the UIScrollViewDelegate methods:

 @c scrollViewDidScroll:
 @c scrollViewDidEndDecelerating:
 @c scrollViewDidEndScrollingAnimation:

 */
@interface GTCPageControl : UIControl <UIScrollViewDelegate>

#pragma mark Managing the page

/**
 The number of page indicators in the control.

 Negative values are clamped to 0.

 The default value is 0.
 */
@property(nonatomic) NSInteger numberOfPages;

/**
 The current page indicator of the control.

 See setCurrentPage:animated: for animated version.

 Values outside the possible range are clamped within [0, numberOfPages-1].

 The default value is 0.
 */
@property(nonatomic) NSInteger currentPage;

/**
 Sets the current page indicator of the control.

 @param currentPage Index of the desired page indicator. Values outside the possible range are
 clamped within [0, numberOfPages-1].
 @param animated    YES the change will be animated; otherwise, NO.
 */
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

/**
 A Boolean value that controls whether the page control is hidden when there is only one page.

 The default value is NO.
 */
@property(nonatomic) BOOL hidesForSinglePage;

#pragma mark Configuring the page colors

/** The color of the non-current page indicators. */
@property(nonatomic, strong, nullable) UIColor *pageIndicatorTintColor UI_APPEARANCE_SELECTOR;

/** The color of the current page indicator. */
@property(nonatomic, strong, nullable)
UIColor *currentPageIndicatorTintColor UI_APPEARANCE_SELECTOR;

#pragma mark Configuring the page behavior

/**
 A Boolean value that controls when the current page is displayed.

 If enabled, user interactions that cause the current page to change will not be visually
 reflected until -updateCurrentPageDisplay is called.

 The default value is NO.
 */
@property(nonatomic) BOOL defersCurrentPageDisplay;

/**
 Updates the page indicator to the current page.

 This method is ignored if defersCurrentPageDisplay is NO.
 */
- (void)updateCurrentPageDisplay;

#pragma mark Resizing the control

/**
 Returns the size required to accommodate the given number of pages.

 @param pageCount The number of pages for which an estimated size should be returned.
 */
+ (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

#pragma mark UIScrollView interface

/** The owner must call this to inform the control that scrolling has occurred. */
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView;

/** The owner must call this when the scrollView has ended its deleration. */
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView;

/** The owner must call this when the scrollView has ended its scrolling animation. */
- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView;

@end
