//
//  GTCCollectionStringResources.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTCCollectionStringResources.h"

#import "GTCollectionsStrings.h"
#import "GTCollectionsStrings_table.h"

// The Bundle for string resources.
static NSString *const kBundleName = @"GTCollections.bundle";

@implementation GTCCollectionStringResources

+ (instancetype)sharedInstance {
    static GTCCollectionStringResources *sharedInstance;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[GTCCollectionStringResources alloc] init];
        }
    }
    return sharedInstance;
}

- (NSString *)stringForId:(GTCollectionsStringId)stringID {
    NSString *stringKey = kGTCollectionsStringTable[stringID];
    NSBundle *bundle = [[self class] bundle];
    NSString *tableName = [kBundleName stringByDeletingPathExtension];
    return [bundle localizedStringForKey:stringKey value:nil table:tableName];
}

- (NSString *)deleteButtonString {
    return [self stringForId:kStr_GTCollectionsDeleteButton];
}

- (NSString *)infoBarGestureHintString {
    return [self stringForId:kStr_GTCollectionsInfoBarGestureHint];
}

#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kBundleName]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTCCollectionStringResources class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle)resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}

@end
