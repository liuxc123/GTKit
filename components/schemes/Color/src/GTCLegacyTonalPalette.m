//
//  GTCLegacyTonalPalette.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/23.
//

#import "GTCLegacyTonalPalette.h"

static NSString *const GTCTonalPaletteColorsKey = @"GTCTonalPaletteColorsKey";
static NSString *const GTCTonalPaletteMainColorIndexKey = @"GTCTonalPaletteMainColorIndexKey";
static NSString *const GTCTonalPaletteLightColorIndexKey = @"GTCTonalPaletteLightColorIndexKey";
static NSString *const GTCTonalPaletteDarkColorIndexKey = @"GTCTonalPaletteDarkColorIndexKey";

@interface GTCTonalPalette ()

@property (nonatomic, copy, nonnull) NSArray<UIColor *> *colors;
@property (nonatomic) NSUInteger mainColorIndex;
@property (nonatomic) NSUInteger lightColorIndex;
@property (nonatomic) NSUInteger darkColorIndex;

@end

@implementation GTCTonalPalette

- (nonnull instancetype)initWithColors:(nonnull NSArray<UIColor *> *)colors
                        mainColorIndex:(NSUInteger)mainColorIndex
                       lightColorIndex:(NSUInteger)lightColorIndex
                        darkColorIndex:(NSUInteger)darkColorIndex {
    self = [super init];
    if (self) {
        _colors = [colors copy];
        if (mainColorIndex > colors.count - 1) {
            NSAssert(NO, @"Main color index is greater than color array size.");
        }
        if (lightColorIndex > colors.count - 1) {
            NSAssert(NO, @"Light color index is greater than color array size.");
        }
        if (darkColorIndex > colors.count - 1) {
            NSAssert(NO, @"Dark color index is greater than color array size.");
        }
        _mainColorIndex = mainColorIndex;
        _lightColorIndex = lightColorIndex;
        _darkColorIndex = darkColorIndex;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        if ([coder containsValueForKey:GTCTonalPaletteColorsKey]) {
            _colors = [coder decodeObjectOfClass:[NSArray class] forKey:GTCTonalPaletteColorsKey];
        }

        if ([coder containsValueForKey:GTCTonalPaletteMainColorIndexKey]) {
            _mainColorIndex = [coder decodeIntegerForKey:GTCTonalPaletteMainColorIndexKey];
        }

        if ([coder containsValueForKey:GTCTonalPaletteLightColorIndexKey]) {
            _lightColorIndex = [coder decodeIntegerForKey:GTCTonalPaletteLightColorIndexKey];
        }

        if ([coder containsValueForKey:GTCTonalPaletteDarkColorIndexKey]) {
            _darkColorIndex = [coder decodeIntegerForKey:GTCTonalPaletteDarkColorIndexKey];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.colors forKey:GTCTonalPaletteColorsKey];
    [aCoder encodeInteger:self.mainColorIndex forKey:GTCTonalPaletteMainColorIndexKey];
    [aCoder encodeInteger:self.lightColorIndex forKey:GTCTonalPaletteLightColorIndexKey];
    [aCoder encodeInteger:self.darkColorIndex forKey:GTCTonalPaletteDarkColorIndexKey];
}

- (UIColor *)mainColor {
    return _colors[_mainColorIndex];
}

- (UIColor *)lightColor {
    return _colors[_lightColorIndex];
}

- (UIColor *)darkColor {
    return _colors[_darkColorIndex];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    GTCTonalPalette *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.colors = [self colors];
        copy.mainColorIndex = [self mainColorIndex];
        copy.lightColorIndex = [self lightColorIndex];
        copy.darkColorIndex = [self darkColorIndex];
    }
    return copy;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

