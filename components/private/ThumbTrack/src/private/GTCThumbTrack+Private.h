//
//  GTCThumbTrack+Private.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCThumbTrack.h"
#import "GTCNumericValueLabel.h"
#import "GTInk.h"

// Credit to the Beacon Tools iOS team for the idea for this implementations
@interface GTCDiscreteDotView : UIView

@property(nonatomic, assign) NSUInteger numDiscreteDots;

/** The color of dots within the @c activeDotsSegment bounds. Defaults to black. */
@property(nonatomic, strong, nonnull) UIColor *activeDotColor;

/** The color of dots outside the @c activeDotsSegment bounds. Defaults to black. */
@property(nonatomic, strong, nonnull) UIColor *inactiveDotColor;

/**
 The segment of the track that uses @c activeDotColor. The horizontal dimension should be bound
 to [0..1]. The vertical dimension is ignored.

 @note Only the @c origin.x and @c size.width are used to determine whether a dot is in the active
 segment.
 */
@property(nonatomic, assign) CGRect activeDotsSegment;

@end

@interface GTCThumbTrack (Private)

@property(nonatomic, nonnull, readonly) GTCNumericValueLabel *numericValueLabel;
@property(nonatomic, nonnull, readonly) GTCInkTouchController *touchController;
@property(nonatomic, nonnull, readonly) GTCDiscreteDotView *discreteDotView;

@end

