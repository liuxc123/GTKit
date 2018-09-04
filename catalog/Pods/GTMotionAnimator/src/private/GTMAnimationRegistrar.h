//
//  GTMAnimationRegistrar.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

// Tracks and manipulates animations that have been added to a layer.
@interface GTMAnimationRegistrar : NSObject

// Invokes the layer's addAnimation:forKey: method with the provided animation and key and tracks
// its association. Upon completion of the animation, the provided optional completion block will be
// executed.
- (void)addAnimation:(nonnull CABasicAnimation *)animation
             toLayer:(nonnull CALayer *)layer
              forKey:(nonnull NSString *)key
          completion:(void(^ __nullable)(BOOL))completion;

// For every active animation, reads the associated layer's presentation layer key path and writes
// it to the layer.
- (void)commitCurrentAnimationValuesToAllLayers;

// Removes all active animations from their associated layer.
- (void)removeAllAnimations;

@end

