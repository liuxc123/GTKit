//
//  GTCSheetContainerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>
#import "GTCBottomSheetState.h"

@protocol GTCSheetContainerViewDelegate;

@interface GTCSheetContainerView : UIView

@property(nonatomic, weak, nullable) id<GTCSheetContainerViewDelegate> delegate;
@property(nonatomic, readonly) GTCSheetState sheetState;
@property(nonatomic) CGFloat preferredSheetHeight;

- (nonnull instancetype)initWithFrame:(CGRect)frame
                          contentView:(nonnull UIView *)contentView
                           scrollView:(nullable UIScrollView *)scrollView NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder NS_UNAVAILABLE;

@end

@protocol GTCSheetContainerViewDelegate <NSObject>

- (void)sheetContainerViewDidHide:(nonnull GTCSheetContainerView *)containerView;
- (void)sheetContainerViewWillChangeState:(nonnull GTCSheetContainerView *)containerView
                               sheetState:(GTCSheetState)sheetState;

@end
