//
//  GTCAppBarTypographyThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCAppBarTypographyThemer.h"

#import "GTNavigationBar+TypographyThemer.h"


@implementation GTCAppBarTypographyThemer

+ (void)applyTypographyScheme:(nonnull id<GTCTypographyScheming>)typographyScheme
       toAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController {
    [GTCNavigationBarTypographyThemer applyTypographyScheme:typographyScheme
                                            toNavigationBar:appBarViewController.navigationBar];
}
@end
