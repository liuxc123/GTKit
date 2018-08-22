//
//  GTCFlatButton.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/21.
//

#import "GTCFlatButton.h"

#import "GTShadowElevations.h"
#import "private/GTCButton+Subclassing.h"

static NSString *const GTCFlatButtonHasOpaqueBackground = @"GTCFlatButtonHasOpaqueBackground";

@implementation GTCFlatButton

+ (void)initialize {
    // Default background colors.
    [GTCFlatButton.appearance setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [GTCFlatButton.appearance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [GTCFlatButton.appearance setElevation:GTCShadowElevationNone forState:UIControlStateNormal];
    [GTCFlatButton.appearance setElevation:GTCShadowElevationNone forState:UIControlStateHighlighted];
    GTCFlatButton.appearance.inkColor = [UIColor colorWithWhite:0 alpha:0.06f];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([aDecoder containsValueForKey:GTCFlatButtonHasOpaqueBackground]) {
            self.hasOpaqueBackground = [aDecoder decodeBoolForKey:GTCFlatButtonHasOpaqueBackground];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:_hasOpaqueBackground forKey:GTCFlatButtonHasOpaqueBackground];
}

#pragma mark - GTCButton Subclassing

- (void)setHasOpaqueBackground:(BOOL)hasOpaqueBackground {
    _hasOpaqueBackground = hasOpaqueBackground;
    [self updateBackgroundColor];
}

- (BOOL)shouldHaveOpaqueBackground {
    return [super shouldHaveOpaqueBackground] || self.hasOpaqueBackground;
}


@end
