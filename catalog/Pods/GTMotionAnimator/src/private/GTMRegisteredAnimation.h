//
//  GTMRegisteredAnimation.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface GTMRegisteredAnimation : NSObject

- (instancetype)initWithKey:(NSString *)key animation:(CABasicAnimation *)animation;

@property(nonatomic, copy, readonly) NSString *key;

@property(nonatomic, strong, readonly) CABasicAnimation *animation;

@end
