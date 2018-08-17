//
//  GTCCurvedRectShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCCurvedRectShapeGenerator.h"

#import "GTCCurvedCornerTreatment.h"

static NSString *const GTCCurvedRectShapeGeneratorCornerSizeKey =
@"GTCCurvedRectShapeGeneratorCornerSizeKey";

@implementation GTCCurvedRectShapeGenerator {
    GTCRectangleShapeGenerator *_rectGenerator;
    GTCCurvedCornerTreatment *_widthHeightCorner;
    GTCCurvedCornerTreatment *_heightWidthCorner;
}

- (instancetype)init {
    return [self initWithCornerSize:CGSizeMake(0, 0)];
}

- (instancetype)initWithCornerSize:(CGSize)cornerSize {
    if (self = [super init]) {
        [self commonInit];

        self.cornerSize = cornerSize;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self commonInit];

        self.cornerSize = [aDecoder decodeCGSizeForKey:GTCCurvedRectShapeGeneratorCornerSizeKey];
    }
    return self;
}

- (void)commonInit {
    _rectGenerator = [[GTCRectangleShapeGenerator alloc] init];

    _widthHeightCorner = [[GTCCurvedCornerTreatment alloc] init];
    _heightWidthCorner = [[GTCCurvedCornerTreatment alloc] init];

    _rectGenerator.topLeftCorner = _widthHeightCorner;
    _rectGenerator.topRightCorner = _heightWidthCorner;
    _rectGenerator.bottomRightCorner = _widthHeightCorner;
    _rectGenerator.bottomLeftCorner = _heightWidthCorner;
}

- (void)setCornerSize:(CGSize)cornerSize {
    _cornerSize = cornerSize;

    _widthHeightCorner.size = _cornerSize;
    _heightWidthCorner.size = CGSizeMake(cornerSize.height, cornerSize.width);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeCGSize:_cornerSize forKey:GTCCurvedRectShapeGeneratorCornerSizeKey];
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    GTCCurvedRectShapeGenerator *copy = [[[self class] alloc] init];
    copy.cornerSize = self.cornerSize;
    return copy;
}

- (CGPathRef)pathForSize:(CGSize)size {
    return [_rectGenerator pathForSize:size];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

