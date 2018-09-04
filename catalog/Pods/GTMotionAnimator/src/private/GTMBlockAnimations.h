//
//  GTMBlockAnimations.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface GTMImplicitAction: NSObject
@property(nonatomic, strong, readonly) id initialModelValue;
@property(nonatomic, readonly) BOOL hadPresentationLayer;
@property(nonatomic, strong, readonly) id initialPresentationValue;
@property(nonatomic, copy, readonly) NSString *keyPath;
@property(nonatomic, strong, readonly) CALayer *layer;
@end

NSArray<GTMImplicitAction *> *GTMAnimateImplicitly(void (^animations)(void));

