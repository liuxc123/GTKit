//
//  GTMCoreAnimationTraceable.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <UIKit/UIKit.h>

/**
 An object conforming to this protocol allows registration of tracers for the purposes of debugging
 Core Animation animations.
 */
@protocol GTMCoreAnimationTraceable

/**
 Adds a block that will be invoked each time an animation is added to a layer.
 */
- (void)addCoreAnimationTracer:(nonnull void (^)(CALayer * _Nonnull, CAAnimation * _Nonnull))tracer;

@end
