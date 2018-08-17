//
//  GTCOverlayObserverOverlay.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

#import "GTCOverlayTransitioning.h"

@interface GTCOverlayObserverOverlay : NSObject

/**
 The unique identifier for the given overlay.
 */
@property(nonatomic, copy) NSString *identifier;

/**
 The frame of the overlay, in screen coordinates.
 */
@property(nonatomic, assign) CGRect frame;

@end
