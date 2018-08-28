//
//  PageControlButtonExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import <UIKit/UIKit.h>

#import "GTPageControl.h"

@interface PageControlButtonExample : UIViewController <UIScrollViewDelegate>

@end

@implementation PageControlButtonExample{
    UIScrollView *_scrollView;
    GTCPageControl *_pageControl;
    UIButton *_nextButton;
    NSArray *_pages;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat boundsWidth = CGRectGetWidth(self.view.bounds);
    CGFloat boundsHeight = CGRectGetHeight(self.view.bounds);

    NSArray *pageColors = @[
                            [UIColor colorWithWhite:0.9f alpha:1.0f],
                            [UIColor colorWithWhite:0.8f alpha:1.0f],
                            [UIColor colorWithWhite:0.7f alpha:1.0f],
                            [UIColor colorWithWhite:0.6f alpha:1.0f],
                            [UIColor colorWithWhite:0.5f alpha:1.0f]  ];

    // Scroll view configuration
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(boundsWidth * pageColors.count, boundsHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    NSMutableArray *pages = [NSMutableArray array];

    // Add pages to scrollView.
    for (NSUInteger i = 0; i < pageColors.count; i++) {
        CGRect pageFrame = CGRectOffset(self.view.bounds, i * boundsWidth, 0);
        UILabel *page = [[UILabel alloc] initWithFrame:pageFrame];
        page.text = [NSString stringWithFormat:@"Page %lu", (unsigned long)(i + 1)];
        page.font = [UIFont systemFontOfSize:50];
        page.textColor = [UIColor colorWithWhite:0 alpha:0.8f];
        page.textAlignment = NSTextAlignmentCenter;
        page.backgroundColor = pageColors[i];
        page.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_scrollView addSubview:page];
        [pages addObject:page];
    }
    _pages = [pages copy];

    // Page control configuration.
    _pageControl = [[GTCPageControl alloc] init];
    _pageControl.numberOfPages = pageColors.count;

    // We want the page control to span the bottom of the screen.
    CGSize pageControlSize = [_pageControl sizeThatFits:self.view.bounds.size];
    _pageControl.frame =
    CGRectMake(0, boundsHeight - pageControlSize.height, boundsWidth, pageControlSize.height);

    [_pageControl addTarget:self
                     action:@selector(didChangePage:)
           forControlEvents:UIControlEventValueChanged];
    _pageControl.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_pageControl];

    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"Next Page" forState:UIControlStateNormal];
    _nextButton.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_nextButton addTarget:self
                    action:@selector(didTapButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
}

#pragma mark - Frame changes

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSInteger pageBeforeFrameChange = _pageControl.currentPage;
    NSInteger pageCount = _pages.count;
    CGFloat boundsWidth = CGRectGetWidth(self.view.bounds);
    CGFloat boundsHeight = CGRectGetHeight(self.view.bounds);
    for (NSInteger i = 0; i < pageCount; i++) {
        UILabel *page = [_pages objectAtIndex:i];
        page.frame = CGRectOffset(self.view.bounds, i * boundsWidth, 0);
    }
    _scrollView.contentSize = CGSizeMake(boundsWidth * pageCount, boundsHeight);
    CGPoint offset = _scrollView.contentOffset;
    offset.x = pageBeforeFrameChange * boundsWidth;
    // This non-anmiated change of offset ensures we keep the same page
    [_scrollView setContentOffset:offset animated:NO];

    // We want the page control to span the bottom of the screen.
    CGRect standardizedFrame = CGRectStandardize(self.view.frame);
    [_pageControl sizeThatFits:standardizedFrame.size];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
    if (@available(iOS 11.0, *)) {
        // Accommodate insets for iPhone X.
        edgeInsets = self.view.safeAreaInsets;
    }
#endif
    CGFloat yOffset =
    CGRectGetHeight(self.view.frame) - CGRectGetHeight(_pageControl.frame) - edgeInsets.bottom;
    _pageControl.frame =
    CGRectMake(0, yOffset, CGRectGetWidth(self.view.frame), CGRectGetHeight(_pageControl.frame));

    [_nextButton sizeToFit];
    CGFloat buttonCenterX =
    boundsWidth - CGRectGetWidth(_nextButton.frame) / 2 - 16 - edgeInsets.right;
    _nextButton.center = CGPointMake(buttonCenterX, _pageControl.center.y);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pageControl scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pageControl scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [_pageControl scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - User events

- (void)didChangePage:(GTCPageControl *)sender {
    CGPoint offset = _scrollView.contentOffset;
    offset.x = sender.currentPage * _scrollView.bounds.size.width;
    [_scrollView setContentOffset:offset animated:YES];
}

- (void)didTapButton:(id)sender {
    NSUInteger nextPage = MIN(_pageControl.currentPage + 1, _pageControl.numberOfPages - 1);
    CGPoint offset = _scrollView.contentOffset;
    offset.x = nextPage * CGRectGetWidth(_scrollView.frame);
    [_scrollView setContentOffset:offset animated:YES];
    [_pageControl setCurrentPage:nextPage animated:YES];
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Page Control", @"Page Control with Next Button" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
