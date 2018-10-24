//
//  UIView+GTCEmptyView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import "UIView+GTCEmptyView.h"
#import <objc/runtime.h>
#import "GTCEmptyView.h"
#import "GTCLoadingView.h"

#pragma mark - ------------------ UIView ------------------

@implementation UIView (GTCEmptyView)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

#pragma mark - Setter/Getter
- (void)setGtc_emptyView:(GTCEmptyView *)gtc_emptyView
{
    if (gtc_emptyView != self.gtc_emptyView) {

        objc_setAssociatedObject(self, @selector(gtc_emptyView), gtc_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[GTCEmptyView class]]) {
                [view removeFromSuperview];
            }
        }
        self.gtc_emptyView.hidden = YES;
        [self addSubview:self.gtc_emptyView];
    }
}

- (GTCEmptyView *)gtc_emptyView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGtc_loadingView:(GTCLoadingView *)gtc_loadingView
{
    if (gtc_loadingView != self.gtc_loadingView) {

        objc_setAssociatedObject(self, @selector(gtc_loadingView), gtc_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[GTCLoadingView class]]) {
                [view removeFromSuperview];
            }
        }
        self.gtc_loadingView.hidden = YES;
        [self addSubview:self.gtc_loadingView];
    }
}

- (GTCLoadingView *)gtc_loadingView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGtc_isLoading:(BOOL)gtc_isLoading
{
    NSNumber *number = [NSNumber numberWithBool:gtc_isLoading];
    objc_setAssociatedObject(self, @selector(gtc_isLoading), number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)gtc_isLoading
{
    BOOL obj = ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
    return obj ? obj : NO;
}

#pragma mark - Private Method (UITableView、UICollectionView有效)
- (NSInteger)totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;

        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;

        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (void)getDataAndSet{
    //没有设置emptyView的，直接返回
    if (!self.gtc_emptyView) {
        return;
    }

    if ([self totalDataCount] == 0) {
        [self show];
    }else{
        [self hide];
    }
}

- (void)show{

    //当不自动显隐时，内部自动调用show方法时也不要去显示，要显示的话只有手动去调用 gtc_showEmptyView
    if (!self.gtc_emptyView.autoShowEmptyView || self.gtc_isLoading) {
        [self gtc_hideEmptyView];
        [self gtc_hideLoadingView];
        return;
    }

    [self gtc_showEmptyView];
}
- (void)hide{

    if (!self.gtc_emptyView.autoShowEmptyView || self.gtc_isLoading) {
        [self gtc_hideEmptyView];
        [self gtc_hideLoadingView];
        return;
    }

    [self gtc_hideEmptyView];
}

#pragma mark - Public Method
- (void)gtc_showEmptyView{

    [self.gtc_emptyView.superview layoutSubviews];

    self.gtc_emptyView.hidden = NO;

    //让 emptyBGView 始终保持在最上层
    [self bringSubviewToFront:self.gtc_emptyView];
}
- (void)gtc_hideEmptyView{
    self.gtc_emptyView.hidden = YES;
}

- (void)gtc_showLoadingView {
    [self.gtc_loadingView.superview layoutSubviews];

    self.gtc_loadingView.hidden = NO;

    //让 loadingView 始终保持在最上层
    [self bringSubviewToFront:self.gtc_loadingView];
}

- (void)gtc_hideLoadingView{
    self.gtc_loadingView.hidden = YES;
}


- (void)gtc_startLoading{
    self.gtc_isLoading = YES;
    self.gtc_emptyView.hidden = YES;
    [self gtc_showLoadingView];
}
- (void)gtc_endLoading{
    self.gtc_isLoading = NO;
    [self gtc_hideLoadingView];
    self.gtc_emptyView.hidden = [self totalDataCount];
}

@end

#pragma mark - ------------------ UITableView ------------------
@implementation UITableView (GTCEmptyView)
+ (void)load{

    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(gtc_reloadData)];

    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:withRowAnimation:) method2:@selector(gtc_insertSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:withRowAnimation:) method2:@selector(gtc_deleteSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:withRowAnimation:) method2:@selector(gtc_reloadSections:withRowAnimation:)];

    ///row
    [self exchangeInstanceMethod1:@selector(insertRowsAtIndexPaths:withRowAnimation:) method2:@selector(gtc_insertRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteRowsAtIndexPaths:withRowAnimation:) method2:@selector(gtc_deleteRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadRowsAtIndexPaths:withRowAnimation:) method2:@selector(gtc_reloadRowsAtIndexPaths:withRowAnimation:)];
}

- (void)gtc_reloadData{
    [self gtc_reloadData];
    [self getDataAndSet];
}
///section
- (void)gtc_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self gtc_insertSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gtc_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self gtc_deleteSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gtc_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self gtc_reloadSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}

///row
- (void)gtc_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self gtc_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gtc_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self gtc_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gtc_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self gtc_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}
@end

#pragma mark - ------------------ UICollectionView ------------------

@implementation UICollectionView (GTCEmptyView)

+ (void)load{

    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(gtc_reloadData)];

    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:) method2:@selector(gtc_insertSections:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:) method2:@selector(gtc_deleteSections:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:) method2:@selector(gtc_reloadSections:)];

    ///item
    [self exchangeInstanceMethod1:@selector(insertItemsAtIndexPaths:) method2:@selector(gtc_insertItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(deleteItemsAtIndexPaths:) method2:@selector(gtc_deleteItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(reloadItemsAtIndexPaths:) method2:@selector(gtc_reloadItemsAtIndexPaths:)];

}
- (void)gtc_reloadData{
    [self gtc_reloadData];
    [self getDataAndSet];
}
///section
- (void)gtc_insertSections:(NSIndexSet *)sections{
    [self gtc_insertSections:sections];
    [self getDataAndSet];
}
- (void)gtc_deleteSections:(NSIndexSet *)sections{
    [self gtc_deleteSections:sections];
    [self getDataAndSet];
}
- (void)gtc_reloadSections:(NSIndexSet *)sections{
    [self gtc_reloadSections:sections];
    [self getDataAndSet];
}

///item
- (void)gtc_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self gtc_insertItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
- (void)gtc_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self gtc_deleteItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
- (void)gtc_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self gtc_reloadItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
@end
