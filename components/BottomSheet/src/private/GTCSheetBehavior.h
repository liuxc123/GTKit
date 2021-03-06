//
//  GTCSheetBehavior.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>

@interface GTCSheetBehavior : UIDynamicBehavior

/**
 * The final center-point for the item to arrive at.
 */
@property(nonatomic) CGPoint targetPoint;

/**
 * The initial velocity for the behavior.
 */
@property(nonatomic) CGPoint velocity;

/**
 * Initializes a @c MDCSheetBehavior.
 * @param item The dynamic item (a view) to apply the sheet behavior to.
 */
- (nonnull instancetype)initWithItem:(nonnull id <UIDynamicItem>)item NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
