//
//  GTCTabBarIndicatorTemplate.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

@class GTCTabBarIndicatorAttributes;
@protocol GTCTabBarIndicatorContext;

/*
 Template for indicator content which defines how the indicator changes appearance in response to
 changes in its context.

 Template objects are expected to be immutable once set on a tab bar.
 */
@protocol GTCTabBarIndicatorTemplate <NSObject>

/**
 Returns an attributes object that describes how the indicator should appear in a given context.
 */
- (nonnull GTCTabBarIndicatorAttributes *)
indicatorAttributesForContext:(nonnull id<GTCTabBarIndicatorContext>)context;

@end
