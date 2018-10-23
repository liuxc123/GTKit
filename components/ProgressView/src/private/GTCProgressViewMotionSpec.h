//
//  GTCProgressViewMotionSpec.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <Foundation/Foundation.h>
#import <GTMotionInterchange/GTMotionInterchange.h>

@interface GTCProgressViewMotionSpec: NSObject

@property(nonatomic, class, readonly) GTMMotionTiming willChangeProgress;
@property(nonatomic, class, readonly) GTMMotionTiming willChangeHidden;

// This object is not meant to be instantiated.
- (instancetype)init NS_UNAVAILABLE;

@end
