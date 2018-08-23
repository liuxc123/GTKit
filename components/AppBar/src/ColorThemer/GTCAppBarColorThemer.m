//
//  GTCAppBarColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCAppBarColorThemer.h"

#import "GTFlexibleHeader+ColorThemer.h"
#import "GTNavigationBar+ColorThemer.h"

@implementation GTCAppBarColorThemer

+ (void)applyColorScheme:(nonnull id<GTCColorScheming>)colorScheme
  toAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController {
    [GTCFlexibleHeaderColorThemer applySemanticColorScheme:colorScheme
                                      toFlexibleHeaderView:appBarViewController.headerView];
    [GTCNavigationBarColorThemer applySemanticColorScheme:colorScheme
                                          toNavigationBar:appBarViewController.navigationBar];
}

+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                    toAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController {
    [GTCFlexibleHeaderColorThemer applySurfaceVariantWithColorScheme:colorScheme
                                                toFlexibleHeaderView:appBarViewController.headerView];
    [GTCNavigationBarColorThemer applySurfaceVariantWithColorScheme:colorScheme
                                                    toNavigationBar:
     appBarViewController.navigationBar];
}

#pragma mark - To be deprecated

+ (void)applySemanticColorScheme:(id<GTCColorScheming>)colorScheme
                        toAppBar:(GTCAppBar *)appBar {
    [GTCFlexibleHeaderColorThemer applySemanticColorScheme:colorScheme
                                      toFlexibleHeaderView:appBar.headerViewController.headerView];
    [GTCNavigationBarColorThemer applySemanticColorScheme:colorScheme
                                          toNavigationBar:appBar.navigationBar];
}

+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                                  toAppBar:(nonnull GTCAppBar *)appBar {
    [GTCFlexibleHeaderColorThemer applySurfaceVariantWithColorScheme:colorScheme
                                                toFlexibleHeaderView:
     appBar.headerViewController.headerView];
    [GTCNavigationBarColorThemer applySurfaceVariantWithColorScheme:colorScheme
                                                    toNavigationBar:appBar.navigationBar];
}


@end
