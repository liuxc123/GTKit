//
//  GTCOverlayAnimationObserver.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <Foundation/Foundation.h>

@protocol GTCOverlayAnimationObserverDelegate;

/**
 Utility class which will call its delegate at the end of the current runloop cycle.

 Called before CoreAnimation has had a chance to commit any pending implicit @c CATransactions.
 */
@interface GTCOverlayAnimationObserver : NSObject

/**
 Called to tell the observer that it should call the @c delegate at the end of the next runloop.

 Without calling this method, the observer will not call the delegate.
 */
- (void)messageDelegateOnNextRunloop;

/**
 The delegate to notify when the end of the runloop has occurred.
 */
@property(nonatomic, weak) id<GTCOverlayAnimationObserverDelegate> delegate;

@end

/**
 Delegate protocol for @c GTCOverlayAnimationObserver.
 */
@protocol GTCOverlayAnimationObserverDelegate <NSObject>

/**
 Called at the end of the current runloop, before CoreAnimation commits any implicit transactions.
 */
- (void)animationObserverDidEndRunloop:(GTCOverlayAnimationObserver *)observer;

@end
