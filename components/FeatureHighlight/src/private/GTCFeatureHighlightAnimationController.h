//
//  GTCFeatureHighlightAnimationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GTCFeatureHighlightDismissAccepted,
    GTCFeatureHighlightDismissRejected,
} GTCFeatureHighlightDismissStyle;

@interface GTCFeatureHighlightAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) GTCFeatureHighlightDismissStyle dismissStyle;
@property(nonatomic, assign, getter=isPresenting) BOOL presenting;

@end
