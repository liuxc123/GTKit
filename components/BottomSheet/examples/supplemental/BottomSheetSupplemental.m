//
//  BottomSheetSupplemental.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "BottomSheetSupplemental.h"

@implementation BottomSheetTypicalUseExample (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs": @[ @"Bottom Sheet", @"Bottom Sheet" ],
             @"description": @"Bottom sheets are surfaces anchored to the bottom of the screen "
             @"containing supplementary content, actions, or navigation.",
             @"primaryDemo": @YES,
             @"presentable": @YES,
             };
}

@end
