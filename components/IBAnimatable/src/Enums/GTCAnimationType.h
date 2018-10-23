//
//  GTCAnimationType.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GTCWayIn,
    GTCWayOut,
} GTCWay;

typedef enum : NSUInteger {
    GTCFadeWayIn,
    GTCFadeWayOut,
    GTCFadeWayInOut,
    GTCFadeWayOutIn,
} GTCFadeWay;

typedef enum : NSUInteger {
    GTCDirectionLeft,
    GTCDirectionRight,
    GTCDirectionUp,
    GTCDirectionDown,
} GTCDirection;

typedef enum : NSUInteger {
    GTCAxisX,
    GTCAxisY,
} GTCAxis;


typedef enum : NSUInteger {
    GTCRotationDirectionCW,
    GTCRotationDirectionCCW,
} GTCRotationDirection;


typedef enum : NSUInteger {
    GTCRunSequential,
    GTCRunParallel,
} GTCRun;



