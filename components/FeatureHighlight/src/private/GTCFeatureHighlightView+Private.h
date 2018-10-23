//
//  GTCFeatureHighlightView+Private.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

#import "GTCFeatureHighlightView.h"

typedef void (^GTCFeatureHighlightInteractionBlock)(BOOL accepted);

@interface GTCFeatureHighlightView ()

@property(nonatomic, readonly) CGPoint highlightCenter;
@property(nonatomic, readonly) CGFloat highlightRadius;

@property(nonatomic, assign) CGPoint highlightPoint;
@property(nonatomic, strong) UIView *displayedView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *bodyLabel;
@property(nonatomic, copy) GTCFeatureHighlightInteractionBlock interactionBlock;

@end

@interface GTCFeatureHighlightView (Private) <UIGestureRecognizerDelegate>

- (void)layoutAppearing;
- (void)layoutDisappearing;
- (void)updateOuterHighlight;

- (void)animateDiscover:(NSTimeInterval)duration;
- (void)animateAccepted:(NSTimeInterval)duration;
- (void)animateRejected:(NSTimeInterval)duration;
- (void)animatePulse;

- (void)updateTitleFont;
- (void)updateBodyFont;

@end

