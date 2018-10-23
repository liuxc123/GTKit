//
//  GTCTabBarPrivateIndicatorContext.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTCTabBarIndicatorContext.h"

/// Concrete implementation of a tab indicator context.
@interface GTCTabBarPrivateIndicatorContext : NSObject <GTCTabBarIndicatorContext>

- (null_unspecified instancetype)init NS_UNAVAILABLE;

/// Designated initializer which creates a context from members.
- (nonnull instancetype)initWithItem:(nonnull UITabBarItem *)item
                              bounds:(CGRect)bounds
                        contentFrame:(CGRect)contentFrame NS_DESIGNATED_INITIALIZER;

@end
