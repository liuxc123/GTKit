//
//  GTCMaskedTransitionMotionSpecs.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/14.
//

#import <Foundation/Foundation.h>
#import <GTMotionInterchange/GTMotionInterchange.h>

typedef struct GTCMaskedTransitionMotionTiming {
    GTMMotionTiming iconFade;
    GTMMotionTiming contentFade;
    GTMMotionTiming floodBackgroundColor;
    GTMMotionTiming maskTransformation;
    GTMMotionTiming horizontalMovement;
    GTMMotionTiming verticalMovement;
    GTMMotionTiming scrimFade;
    NSTimeInterval overallDuration;
} GTCMaskedTransitionMotionTiming;

typedef struct GTCMaskedTransitionMotionSpec {
    GTCMaskedTransitionMotionTiming expansion;
    GTCMaskedTransitionMotionTiming collapse;
    BOOL shouldSlideWhenCollapsed;
    BOOL isCentered;
} GTCMaskedTransitionMotionSpec;

@interface GTCMaskedTransitionMotionSpecs : NSObject

@property(nonatomic, class, readonly) GTCMaskedTransitionMotionSpec fullscreen;
@property(nonatomic, class, readonly) GTCMaskedTransitionMotionSpec bottomSheet;
@property(nonatomic, class, readonly) GTCMaskedTransitionMotionSpec bottomCard;
@property(nonatomic, class, readonly) GTCMaskedTransitionMotionSpec toolbar;

// This object is not meant to be instantiated.
- (instancetype)init NS_UNAVAILABLE;

@end
