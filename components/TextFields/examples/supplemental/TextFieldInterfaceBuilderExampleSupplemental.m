//
//  TextFieldInterfaceBuilderExampleSupplemental.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "TextFieldInterfaceBuilderExampleSupplemental.h"

@implementation TextFieldInterfaceBuilderExample (Supplemental)

- (void)setupExampleViews {
    self.title = @"Text Fields";
}

@end

@implementation TextFieldInterfaceBuilderExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"Storyboard" ];
}

+ (NSString *)catalogStoryboardName {
    return @"TextFieldInterfaceBuilderExample";
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end

@implementation TextFieldInterfaceBuilderLegacyExample (Supplemental)

- (void)setupExampleViews {
    self.title = @"Legacy Text Fields";
}

@end

@implementation TextFieldInterfaceBuilderLegacyExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Text Field", @"[Legacy] Storyboard" ];
}

+ (NSString *)catalogStoryboardName {
    return @"TextFieldInterfaceBuilderLegacyExample";
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end

