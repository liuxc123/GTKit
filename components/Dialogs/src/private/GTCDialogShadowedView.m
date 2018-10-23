//
//  GTCDialogShadowedView.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/12.
//

#import "GTCDialogShadowedView.h"

#import "GTShadowElevations.h"
#import "GTShadowLayer.h"

@implementation GTCDialogShadowedView

+ (Class)layerClass {
    return [GTCShadowLayer class];
}

- (GTCShadowLayer *)shadowLayer {
    return (GTCShadowLayer *)self.layer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[self shadowLayer] setElevation:GTCShadowElevationDialog];
    }
    return self;
}

- (CGFloat)elevation {
    return [self shadowLayer].elevation;
}

- (void)setElevation:(CGFloat)elevation {
    [[self shadowLayer] setElevation:elevation];
}


@end
