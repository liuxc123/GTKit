//
//  GTCMaskedTransitionMotionForContext.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <Foundation/Foundation.h>
#import <GTMotionTransitioning/GTMotionTransitioning.h>

#import "GTCMaskedTransitionMotionSpecs.h"

FOUNDATION_EXPORT
GTCMaskedTransitionMotionSpec
GTCMaskedTransitionMotionSpecForContext(UIView *containerView,
                                        UIViewController *presentedViewController);
