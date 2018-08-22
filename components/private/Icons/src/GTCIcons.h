//
//  GTCIcons.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import <Foundation/Foundation.h>

/**
 The GTCIcons class is designed to be extended by adding individual icon extensions to a project.

 Individual icons can be accessed by importing their MaterialIcons+<icon_name>.h header and calling
 [GTCIcons pathFor_<icon_name>] to get the icon's file system path or calling
 [GTCIcons imageFor_<icon_name>] to get a cached image.
 */
@interface GTCIcons : NSObject

// This object is not intended to be instantiated.
- (instancetype)init NS_UNAVAILABLE;

@end
