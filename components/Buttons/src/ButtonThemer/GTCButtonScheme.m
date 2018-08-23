//
//  GTCButtonScheme.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCButtonScheme.h"

@implementation GTCButtonScheme

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorScheme = [[GTCSemanticColorScheme alloc] init];
        _typographyScheme = [[GTCTypographyScheme alloc] init];
        _minimumHeight = 36;
        _cornerRadius = (CGFloat)4;
    }
    return self;
}
@end
