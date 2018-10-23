//
//  GTCShapeCategory.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "GTCShapeCategory.h"
#import "GTShapeLibrary.h"

@implementation GTCShapeCategory


- (instancetype)init {
    return [self initCornersWithFamily:GTCShapeCornerFamilyRounded andSize:0];
}

- (instancetype)initCornersWithFamily:(GTCShapeCornerFamily)cornerFamily
                              andSize:(CGFloat)cornerSize {
    if (self = [super init]) {
        GTCCornerTreatment *cornerTreatment;
        switch (cornerFamily) {
            case GTCShapeCornerFamilyCut:
                cornerTreatment = [GTCCornerTreatment cornerWithCut:cornerSize];
                break;
            case GTCShapeCornerFamilyRounded:
                cornerTreatment = [GTCCornerTreatment cornerWithRadius:cornerSize];
                break;
        }
        _topLeftCorner = cornerTreatment;
        _topRightCorner = cornerTreatment;
        _bottomLeftCorner = cornerTreatment;
        _bottomRightCorner = cornerTreatment;
    }
    return self;
}


@end
