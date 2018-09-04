//
//  GTMDragCoefficient.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMDragCoefficient.h"

#import <UIKit/UIKit.h>

#if TARGET_IPHONE_SIMULATOR
UIKIT_EXTERN float UIAnimationDragCoefficient(void); // UIKit private drag coefficient.
#endif

CGFloat GTMSimulatorAnimationDragCoefficient(void) {
#if TARGET_IPHONE_SIMULATOR
    return UIAnimationDragCoefficient();
#else
    return 1.0;
#endif
}
