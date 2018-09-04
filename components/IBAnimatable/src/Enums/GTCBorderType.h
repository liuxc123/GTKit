//
//  GTCBorderType.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import <Foundation/Foundation.h>
#import "IBEnum.h"

typedef struct GTCBorderType {
    GTMMotionTiming outerRotation;
    GTMMotionTiming innerRotation;
    GTMMotionTiming strokeStart;
    GTMMotionTiming strokeEnd;
} GTCBorderType;

typedef enum : NSString {
    GTCFadeWayIn = @"in",
    GTCFadeWayOut = @"out",
    GTCFadeWayInOut = @"inout",
    GTCFadeWayOutIn = @"outin"
} GTCFadeWay;

typedef enum : NSString {
    GTCWayIn = @"in",
    GTCWayOut = @"out"
} GTCWay;

typedef enum : NSString {
    GTCAxisX = @"x",
    GTCAxisY = @"y"
} GTCAxis;

typedef enum : NSString {
    GTCDirectionLeft = @"left",
    GTCDirectionRight = @"out"
} GTCDirection;

