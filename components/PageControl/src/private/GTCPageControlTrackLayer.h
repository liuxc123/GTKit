//
//  GTCPageControlTrackLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/27.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 This shape layer provides a rounded rectangular track on which a page indicator can travel
 between subsequent indicators. The track animates on appearance, removal, and when its
 end points are updated.

 @internal
 */
@interface GTCPageControlTrackLayer : CAShapeLayer

/** The color of the indicator track. */
@property(nonatomic, strong) UIColor *trackColor;

/** A Boolean value indicating whether the track is hidden. */
@property(nonatomic, readonly, getter=isTrackHidden) BOOL trackHidden;

/**
 Default initializer.

 @param radius The radius of this indicator and track edges.
 */
- (instancetype)initWithRadius:(CGFloat)radius NS_DESIGNATED_INITIALIZER;

/**
 Draws a track with animation from the startpoint to endpoint.

 @param startPoint The start point of the track.
 @param endPoint The end point of the track.
 */
- (void)drawTrackFromStartPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint;

/**
 Extends the visible track with animation to encompass the startpoint and endpoint.

 @param startPoint The start point of the track.
 @param endPoint The end point of the track.
 */
- (void)extendTrackFromStartPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint;

/**
 Draws a track and extends it with animation to encompass the startpoint and endpoint. This
 method should be called when an immediate track needs to be drawn and extended without
 waiting for the draw animation. A typical use case is when called programmatically as
 opposed to user gesture driven.

 @param startPoint The start point of the track.
 @param endPoint The end point of the track.
 @param completion A block to execute when the presentation is finished.
 */
- (void)drawAndExtendTrackFromStartPoint:(CGPoint)startPoint
                              toEndPoint:(CGPoint)endPoint
                              completion:(void (^)(void))completion;

/**
 Removes the track with animation towards the designated point.

 @param point The point the track should animate towards.
 @param completion A block to execute when the presentation is finished.
 */
- (void)removeTrackTowardsPoint:(CGPoint)point completion:(void (^)(void))completion;

/**
 Resets the track with animation to the designated point.

 @param point The point the track should be set to.
 */
- (void)resetAtPoint:(CGPoint)point;


@end
