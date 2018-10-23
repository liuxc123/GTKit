//
//  GTCShapeScheme.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "GTCShapeScheme.h"

@implementation GTCShapeScheme

- (instancetype)init {
    return [self initWithDefaults:GTCShapeSchemeDefaultsMaterial201809];
}

- (instancetype)initWithDefaults:(GTCShapeSchemeDefaults)defaults {
    self = [super init];
    if (self) {
        switch (defaults) {
            case GTCShapeSchemeDefaultsMaterial201809:
                _smallComponentShape =
                [[GTCShapeCategory alloc] initCornersWithFamily:GTCShapeCornerFamilyRounded
                                                        andSize:4.f];
                _mediumComponentShape =
                [[GTCShapeCategory alloc] initCornersWithFamily:GTCShapeCornerFamilyRounded
                                                        andSize:4.f];
                _largeComponentShape =
                [[GTCShapeCategory alloc] initCornersWithFamily:GTCShapeCornerFamilyRounded
                                                        andSize:0.f];
                break;
        }
    }
    return self;
}

@end
