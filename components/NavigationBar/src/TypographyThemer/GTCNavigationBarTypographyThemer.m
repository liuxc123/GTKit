//
//  GTCNavigationBarTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCNavigationBarTypographyThemer.h"

@implementation GTCNavigationBarTypographyThemer

+ (void)applyTypographyScheme:(id<GTCTypographyScheming>)typographyScheme
              toNavigationBar:(GTCNavigationBar *)navigationBar {
    navigationBar.titleFont = typographyScheme.headline6;
}

@end
