//
//  GTMRegisteredAnimation.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMRegisteredAnimation.h"

@implementation GTMRegisteredAnimation

- (instancetype)initWithKey:(NSString *)key animation:(CABasicAnimation *)animation {
    self = [super init];
    if (self) {
        _key = [key copy];
        _animation = animation;
    }
    return self;
}

- (NSUInteger)hash {
    return _key.hash;
}

- (BOOL)isEqual:(id)object {
    return [_key isEqual:object];
}

@end
