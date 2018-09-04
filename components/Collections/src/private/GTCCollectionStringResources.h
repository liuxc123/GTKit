//
//  GTCCollectionStringResources.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import <Foundation/Foundation.h>

/**
 Shorthand for returning a resource from GTCCollectionStringResources's singleton.
 */
#define GTCCollectionStringResources(sel) [[GTCCollectionStringResources sharedInstance] sel]

/** String resources that are used for collection views. */
@interface GTCCollectionStringResources : NSObject

/** Returns the shared resources singleton instance. */
+ (nonnull instancetype)sharedInstance;

/** Returns cell delete string. */
- (nonnull NSString *)deleteButtonString;

/** Returns cell gesture hint string. */
- (nonnull NSString *)infoBarGestureHintString;

@end
