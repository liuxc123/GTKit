//
//  GTCCardScheme.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCCardScheme.h"

@implementation GTCCardScheme

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorScheme = [[GTCSemanticColorScheme alloc] init];
        _shapeScheme = [[GTCShapeScheme alloc] init];
    }
    return self;
}

@end
