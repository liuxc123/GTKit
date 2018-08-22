//
//  GTCRaisedButton.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/21.
//

#import "GTCRaisedButton.h"

#import "GTShadowElevations.h"
#import "private/GTCButton+Subclassing.h"

@implementation GTCRaisedButton

+ (void)initialize {
    [[GTCRaisedButton appearance] setElevation:GTCShadowElevationRaisedButtonResting
                                      forState:UIControlStateNormal];
    [[GTCRaisedButton appearance] setElevation:GTCShadowElevationRaisedButtonPressed
                                      forState:UIControlStateHighlighted];
}

@end
