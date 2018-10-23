//
//  GTCFeatureHighlightDismissGestureRecognizer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

#import <UIKit/UIKit.h>

@interface GTCFeatureHighlightDismissGestureRecognizer : UIGestureRecognizer

@property(nonatomic, readonly) CGFloat progress;
@property(nonatomic, readonly) CGFloat velocity;

@end
