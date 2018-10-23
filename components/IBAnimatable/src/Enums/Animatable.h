//
//  Animatable.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>
#import "GTCAnimatorMotionSpecs.h"

@protocol Animatable <NSObject>
@optional

@property(nonatomic, assign) BOOL autoRun;

@property(nonatomic, assign) NSTimeInterval duration;

@property(nonatomic, assign) NSTimeInterval delay;

@property(nonatomic, assign) CGFloat damping;

@property(nonatomic, assign) CGFloat velocity;

@property(nonatomic, assign) CGFloat force;

@property(nonatomic, assign) GTCAnimatorMotionSpecs *animationType;

@end
