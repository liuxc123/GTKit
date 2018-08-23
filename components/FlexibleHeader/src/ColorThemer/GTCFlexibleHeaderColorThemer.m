//
//  GTCFlexibleHeaderColorThemer.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCFlexibleHeaderColorThemer.h"

@implementation GTCFlexibleHeaderColorThemer

+ (void)applySemanticColorScheme:(nonnull id<GTCColorScheming>)colorScheme
            toFlexibleHeaderView:(nonnull GTCFlexibleHeaderView *)flexibleHeaderView {
    flexibleHeaderView.backgroundColor = colorScheme.primaryColor;
}

+ (void)applySurfaceVariantWithColorScheme:(nonnull id<GTCColorScheming>)colorScheme
                      toFlexibleHeaderView:(nonnull GTCFlexibleHeaderView *)flexibleHeaderView {
    flexibleHeaderView.backgroundColor = colorScheme.surfaceColor;
}

@end
