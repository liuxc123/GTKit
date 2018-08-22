//
//  GTCIcons.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTCIcons.h"

#import "GTCIcons+BundleLoader.h"

@implementation GTCIcons

+ (nullable NSBundle *)bundleNamed:(nonnull NSString *)bundleName {
    static NSCache *bundleCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleCache = [[NSCache alloc] init];
    });

    NSBundle *bundle = [bundleCache objectForKey:bundleName];
    if (!bundle) {
        NSBundle *baseBundle = [NSBundle bundleForClass:[GTCIcons class]];
        NSString *bundlePath = [baseBundle pathForResource:bundleName ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
        if (bundle) {
            [bundleCache setObject:bundle forKey:bundleName];
        }
    }
    return bundle;
}

+ (nonnull NSString *)pathForIconName:(nonnull NSString *)iconName
                       withBundleName:(nonnull NSString *)bundleName {
    NSBundle *bundle = [self bundleNamed:bundleName];
    NSAssert(bundle, @"Missing bundle %@ containing icon %@.", bundleName, iconName);
    return [bundle pathForResource:iconName ofType:@"png"];
}

@end
