//
//  GTCIcons+BundleLoader.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTCIcons.h"

/**
 The GTCIcons class is designed to be extended by adding individual icon extensions to a project.

 Individual icons can be accessed by importing their MaterialIcons+<icon_name>.h header and calling
 [GTCIcons pathFor_<icon_name>] to get the icon's file system path or calling
 [GTCIcons imageFor_<icon_name>] to get a cached image.
 */
@interface GTCIcons (BundleLoader)

/** Returns a disk path for an icon contained within a bundle of a given name. */
+ (nonnull NSString *)pathForIconName:(nonnull NSString *)iconName
                       withBundleName:(nonnull NSString *)bundleName;

+ (nullable NSBundle *)bundleNamed:(nonnull NSString *)bundleName;

@end
