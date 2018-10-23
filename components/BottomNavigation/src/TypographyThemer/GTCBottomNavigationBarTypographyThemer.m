//
//  GTCBottomNavigationBarTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCBottomNavigationBarTypographyThemer.h"

@implementation GTCBottomNavigationBarTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
        toBottomNavigationBar:(nonnull GTCBottomNavigationBar *)bottomNavigationBar {
    bottomNavigationBar.itemTitleFont = typographyScheme.caption;
}

@end
