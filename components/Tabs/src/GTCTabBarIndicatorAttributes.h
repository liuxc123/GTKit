//
//  GTCTabBarIndicatorAttributes.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

/** Defines how a tab bar indicator should appear in a specific context. */
@interface GTCTabBarIndicatorAttributes : NSObject <NSCopying>

/** If non-nil, a path that should be filled with the indicator tint color. */
@property(nonatomic, nullable) UIBezierPath *path;

@end
