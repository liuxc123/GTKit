//
//  GTCPalettes.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import "GTCPalettes.h"
#import "private/GTCPaletteExpansions.h"
#import "private/GTCPaletteNames.h"

const GTCPaletteTint GTCPaletteTint50Name = GTC_PALETTE_TINT_50_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint100Name = GTC_PALETTE_TINT_100_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint200Name = GTC_PALETTE_TINT_200_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint300Name = GTC_PALETTE_TINT_300_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint400Name = GTC_PALETTE_TINT_400_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint500Name = GTC_PALETTE_TINT_500_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint600Name = GTC_PALETTE_TINT_600_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint700Name = GTC_PALETTE_TINT_700_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint800Name = GTC_PALETTE_TINT_800_INTERNAL_NAME;
const GTCPaletteTint GTCPaletteTint900Name = GTC_PALETTE_TINT_900_INTERNAL_NAME;

const GTCPaletteAccent GTCPaletteAccent100Name = GTC_PALETTE_ACCENT_100_INTERNAL_NAME;
const GTCPaletteAccent GTCPaletteAccent200Name = GTC_PALETTE_ACCENT_200_INTERNAL_NAME;
const GTCPaletteAccent GTCPaletteAccent400Name = GTC_PALETTE_ACCENT_400_INTERNAL_NAME;
const GTCPaletteAccent GTCPaletteAccent700Name = GTC_PALETTE_ACCENT_700_INTERNAL_NAME;

// Creates a UIColor from a 24-bit RGB color encoded as an integer.
static inline UIColor *ColorFromRGB(uint32_t rgbValue) {
    return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255
                           green:((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255
                            blue:((CGFloat)((rgbValue & 0x0000FF) >> 0)) / 255
                           alpha:1];
}

@interface GTCPalette () {
    NSDictionary<GTCPaletteTint, UIColor *> *_tints;
    NSDictionary<GTCPaletteAccent, UIColor *> *_accents;
}

@end

@implementation GTCPalette

+ (GTCPalette *)redPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFFEBEE),
                                                GTCPaletteTint100Name : ColorFromRGB(0xFFCDD2),
                                                GTCPaletteTint200Name : ColorFromRGB(0xEF9A9A),
                                                GTCPaletteTint300Name : ColorFromRGB(0xE57373),
                                                GTCPaletteTint400Name : ColorFromRGB(0xEF5350),
                                                GTCPaletteTint500Name : ColorFromRGB(0xF44336),
                                                GTCPaletteTint600Name : ColorFromRGB(0xE53935),
                                                GTCPaletteTint700Name : ColorFromRGB(0xD32F2F),
                                                GTCPaletteTint800Name : ColorFromRGB(0xC62828),
                                                GTCPaletteTint900Name : ColorFromRGB(0xB71C1C)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xFF8A80),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xFF5252),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xFF1744),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xD50000)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)pinkPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFCE4EC),
                                                GTCPaletteTint100Name : ColorFromRGB(0xF8BBD0),
                                                GTCPaletteTint200Name : ColorFromRGB(0xF48FB1),
                                                GTCPaletteTint300Name : ColorFromRGB(0xF06292),
                                                GTCPaletteTint400Name : ColorFromRGB(0xEC407A),
                                                GTCPaletteTint500Name : ColorFromRGB(0xE91E63),
                                                GTCPaletteTint600Name : ColorFromRGB(0xD81B60),
                                                GTCPaletteTint700Name : ColorFromRGB(0xC2185B),
                                                GTCPaletteTint800Name : ColorFromRGB(0xAD1457),
                                                GTCPaletteTint900Name : ColorFromRGB(0x880E4F)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xFF80AB),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xFF4081),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xF50057),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xC51162)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)purplePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xF3E5F5),
                                                GTCPaletteTint100Name : ColorFromRGB(0xE1BEE7),
                                                GTCPaletteTint200Name : ColorFromRGB(0xCE93D8),
                                                GTCPaletteTint300Name : ColorFromRGB(0xBA68C8),
                                                GTCPaletteTint400Name : ColorFromRGB(0xAB47BC),
                                                GTCPaletteTint500Name : ColorFromRGB(0x9C27B0),
                                                GTCPaletteTint600Name : ColorFromRGB(0x8E24AA),
                                                GTCPaletteTint700Name : ColorFromRGB(0x7B1FA2),
                                                GTCPaletteTint800Name : ColorFromRGB(0x6A1B9A),
                                                GTCPaletteTint900Name : ColorFromRGB(0x4A148C)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xEA80FC),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xE040FB),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xD500F9),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xAA00FF)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)deepPurplePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xEDE7F6),
                                                GTCPaletteTint100Name : ColorFromRGB(0xD1C4E9),
                                                GTCPaletteTint200Name : ColorFromRGB(0xB39DDB),
                                                GTCPaletteTint300Name : ColorFromRGB(0x9575CD),
                                                GTCPaletteTint400Name : ColorFromRGB(0x7E57C2),
                                                GTCPaletteTint500Name : ColorFromRGB(0x673AB7),
                                                GTCPaletteTint600Name : ColorFromRGB(0x5E35B1),
                                                GTCPaletteTint700Name : ColorFromRGB(0x512DA8),
                                                GTCPaletteTint800Name : ColorFromRGB(0x4527A0),
                                                GTCPaletteTint900Name : ColorFromRGB(0x311B92)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xB388FF),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x7C4DFF),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x651FFF),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x6200EA)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)indigoPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xE8EAF6),
                                                GTCPaletteTint100Name : ColorFromRGB(0xC5CAE9),
                                                GTCPaletteTint200Name : ColorFromRGB(0x9FA8DA),
                                                GTCPaletteTint300Name : ColorFromRGB(0x7986CB),
                                                GTCPaletteTint400Name : ColorFromRGB(0x5C6BC0),
                                                GTCPaletteTint500Name : ColorFromRGB(0x3F51B5),
                                                GTCPaletteTint600Name : ColorFromRGB(0x3949AB),
                                                GTCPaletteTint700Name : ColorFromRGB(0x303F9F),
                                                GTCPaletteTint800Name : ColorFromRGB(0x283593),
                                                GTCPaletteTint900Name : ColorFromRGB(0x1A237E)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0x8C9EFF),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x536DFE),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x3D5AFE),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x304FFE)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)bluePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xE3F2FD),
                                                GTCPaletteTint100Name : ColorFromRGB(0xBBDEFB),
                                                GTCPaletteTint200Name : ColorFromRGB(0x90CAF9),
                                                GTCPaletteTint300Name : ColorFromRGB(0x64B5F6),
                                                GTCPaletteTint400Name : ColorFromRGB(0x42A5F5),
                                                GTCPaletteTint500Name : ColorFromRGB(0x2196F3),
                                                GTCPaletteTint600Name : ColorFromRGB(0x1E88E5),
                                                GTCPaletteTint700Name : ColorFromRGB(0x1976D2),
                                                GTCPaletteTint800Name : ColorFromRGB(0x1565C0),
                                                GTCPaletteTint900Name : ColorFromRGB(0x0D47A1)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0x82B1FF),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x448AFF),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x2979FF),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x2962FF)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)lightBluePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xE1F5FE),
                                                GTCPaletteTint100Name : ColorFromRGB(0xB3E5FC),
                                                GTCPaletteTint200Name : ColorFromRGB(0x81D4FA),
                                                GTCPaletteTint300Name : ColorFromRGB(0x4FC3F7),
                                                GTCPaletteTint400Name : ColorFromRGB(0x29B6F6),
                                                GTCPaletteTint500Name : ColorFromRGB(0x03A9F4),
                                                GTCPaletteTint600Name : ColorFromRGB(0x039BE5),
                                                GTCPaletteTint700Name : ColorFromRGB(0x0288D1),
                                                GTCPaletteTint800Name : ColorFromRGB(0x0277BD),
                                                GTCPaletteTint900Name : ColorFromRGB(0x01579B)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0x80D8FF),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x40C4FF),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x00B0FF),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x0091EA)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)cyanPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xE0F7FA),
                                                GTCPaletteTint100Name : ColorFromRGB(0xB2EBF2),
                                                GTCPaletteTint200Name : ColorFromRGB(0x80DEEA),
                                                GTCPaletteTint300Name : ColorFromRGB(0x4DD0E1),
                                                GTCPaletteTint400Name : ColorFromRGB(0x26C6DA),
                                                GTCPaletteTint500Name : ColorFromRGB(0x00BCD4),
                                                GTCPaletteTint600Name : ColorFromRGB(0x00ACC1),
                                                GTCPaletteTint700Name : ColorFromRGB(0x0097A7),
                                                GTCPaletteTint800Name : ColorFromRGB(0x00838F),
                                                GTCPaletteTint900Name : ColorFromRGB(0x006064)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0x84FFFF),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x18FFFF),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x00E5FF),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x00B8D4)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)tealPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xE0F2F1),
                                                GTCPaletteTint100Name : ColorFromRGB(0xB2DFDB),
                                                GTCPaletteTint200Name : ColorFromRGB(0x80CBC4),
                                                GTCPaletteTint300Name : ColorFromRGB(0x4DB6AC),
                                                GTCPaletteTint400Name : ColorFromRGB(0x26A69A),
                                                GTCPaletteTint500Name : ColorFromRGB(0x009688),
                                                GTCPaletteTint600Name : ColorFromRGB(0x00897B),
                                                GTCPaletteTint700Name : ColorFromRGB(0x00796B),
                                                GTCPaletteTint800Name : ColorFromRGB(0x00695C),
                                                GTCPaletteTint900Name : ColorFromRGB(0x004D40)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xA7FFEB),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x64FFDA),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x1DE9B6),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x00BFA5)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)greenPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xE8F5E9),
                                                GTCPaletteTint100Name : ColorFromRGB(0xC8E6C9),
                                                GTCPaletteTint200Name : ColorFromRGB(0xA5D6A7),
                                                GTCPaletteTint300Name : ColorFromRGB(0x81C784),
                                                GTCPaletteTint400Name : ColorFromRGB(0x66BB6A),
                                                GTCPaletteTint500Name : ColorFromRGB(0x4CAF50),
                                                GTCPaletteTint600Name : ColorFromRGB(0x43A047),
                                                GTCPaletteTint700Name : ColorFromRGB(0x388E3C),
                                                GTCPaletteTint800Name : ColorFromRGB(0x2E7D32),
                                                GTCPaletteTint900Name : ColorFromRGB(0x1B5E20)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xB9F6CA),
                                                GTCPaletteAccent200Name : ColorFromRGB(0x69F0AE),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x00E676),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x00C853)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)lightGreenPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xF1F8E9),
                                                GTCPaletteTint100Name : ColorFromRGB(0xDCEDC8),
                                                GTCPaletteTint200Name : ColorFromRGB(0xC5E1A5),
                                                GTCPaletteTint300Name : ColorFromRGB(0xAED581),
                                                GTCPaletteTint400Name : ColorFromRGB(0x9CCC65),
                                                GTCPaletteTint500Name : ColorFromRGB(0x8BC34A),
                                                GTCPaletteTint600Name : ColorFromRGB(0x7CB342),
                                                GTCPaletteTint700Name : ColorFromRGB(0x689F38),
                                                GTCPaletteTint800Name : ColorFromRGB(0x558B2F),
                                                GTCPaletteTint900Name : ColorFromRGB(0x33691E)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xCCFF90),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xB2FF59),
                                                GTCPaletteAccent400Name : ColorFromRGB(0x76FF03),
                                                GTCPaletteAccent700Name : ColorFromRGB(0x64DD17)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)limePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xF9FBE7),
                                                GTCPaletteTint100Name : ColorFromRGB(0xF0F4C3),
                                                GTCPaletteTint200Name : ColorFromRGB(0xE6EE9C),
                                                GTCPaletteTint300Name : ColorFromRGB(0xDCE775),
                                                GTCPaletteTint400Name : ColorFromRGB(0xD4E157),
                                                GTCPaletteTint500Name : ColorFromRGB(0xCDDC39),
                                                GTCPaletteTint600Name : ColorFromRGB(0xC0CA33),
                                                GTCPaletteTint700Name : ColorFromRGB(0xAFB42B),
                                                GTCPaletteTint800Name : ColorFromRGB(0x9E9D24),
                                                GTCPaletteTint900Name : ColorFromRGB(0x827717)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xF4FF81),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xEEFF41),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xC6FF00),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xAEEA00)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)yellowPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFFFDE7),
                                                GTCPaletteTint100Name : ColorFromRGB(0xFFF9C4),
                                                GTCPaletteTint200Name : ColorFromRGB(0xFFF59D),
                                                GTCPaletteTint300Name : ColorFromRGB(0xFFF176),
                                                GTCPaletteTint400Name : ColorFromRGB(0xFFEE58),
                                                GTCPaletteTint500Name : ColorFromRGB(0xFFEB3B),
                                                GTCPaletteTint600Name : ColorFromRGB(0xFDD835),
                                                GTCPaletteTint700Name : ColorFromRGB(0xFBC02D),
                                                GTCPaletteTint800Name : ColorFromRGB(0xF9A825),
                                                GTCPaletteTint900Name : ColorFromRGB(0xF57F17)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xFFFF8D),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xFFFF00),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xFFEA00),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xFFD600)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)amberPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFFF8E1),
                                                GTCPaletteTint100Name : ColorFromRGB(0xFFECB3),
                                                GTCPaletteTint200Name : ColorFromRGB(0xFFE082),
                                                GTCPaletteTint300Name : ColorFromRGB(0xFFD54F),
                                                GTCPaletteTint400Name : ColorFromRGB(0xFFCA28),
                                                GTCPaletteTint500Name : ColorFromRGB(0xFFC107),
                                                GTCPaletteTint600Name : ColorFromRGB(0xFFB300),
                                                GTCPaletteTint700Name : ColorFromRGB(0xFFA000),
                                                GTCPaletteTint800Name : ColorFromRGB(0xFF8F00),
                                                GTCPaletteTint900Name : ColorFromRGB(0xFF6F00)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xFFE57F),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xFFD740),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xFFC400),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xFFAB00)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)orangePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFFF3E0),
                                                GTCPaletteTint100Name : ColorFromRGB(0xFFE0B2),
                                                GTCPaletteTint200Name : ColorFromRGB(0xFFCC80),
                                                GTCPaletteTint300Name : ColorFromRGB(0xFFB74D),
                                                GTCPaletteTint400Name : ColorFromRGB(0xFFA726),
                                                GTCPaletteTint500Name : ColorFromRGB(0xFF9800),
                                                GTCPaletteTint600Name : ColorFromRGB(0xFB8C00),
                                                GTCPaletteTint700Name : ColorFromRGB(0xF57C00),
                                                GTCPaletteTint800Name : ColorFromRGB(0xEF6C00),
                                                GTCPaletteTint900Name : ColorFromRGB(0xE65100)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xFFD180),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xFFAB40),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xFF9100),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xFF6D00)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)deepOrangePalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFBE9E7),
                                                GTCPaletteTint100Name : ColorFromRGB(0xFFCCBC),
                                                GTCPaletteTint200Name : ColorFromRGB(0xFFAB91),
                                                GTCPaletteTint300Name : ColorFromRGB(0xFF8A65),
                                                GTCPaletteTint400Name : ColorFromRGB(0xFF7043),
                                                GTCPaletteTint500Name : ColorFromRGB(0xFF5722),
                                                GTCPaletteTint600Name : ColorFromRGB(0xF4511E),
                                                GTCPaletteTint700Name : ColorFromRGB(0xE64A19),
                                                GTCPaletteTint800Name : ColorFromRGB(0xD84315),
                                                GTCPaletteTint900Name : ColorFromRGB(0xBF360C)
                                                }
                                      accents:@{
                                                GTCPaletteAccent100Name : ColorFromRGB(0xFF9E80),
                                                GTCPaletteAccent200Name : ColorFromRGB(0xFF6E40),
                                                GTCPaletteAccent400Name : ColorFromRGB(0xFF3D00),
                                                GTCPaletteAccent700Name : ColorFromRGB(0xDD2C00)
                                                }];
    });
    return palette;
}

+ (GTCPalette *)brownPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xEFEBE9),
                                                GTCPaletteTint100Name : ColorFromRGB(0xD7CCC8),
                                                GTCPaletteTint200Name : ColorFromRGB(0xBCAAA4),
                                                GTCPaletteTint300Name : ColorFromRGB(0xA1887F),
                                                GTCPaletteTint400Name : ColorFromRGB(0x8D6E63),
                                                GTCPaletteTint500Name : ColorFromRGB(0x795548),
                                                GTCPaletteTint600Name : ColorFromRGB(0x6D4C41),
                                                GTCPaletteTint700Name : ColorFromRGB(0x5D4037),
                                                GTCPaletteTint800Name : ColorFromRGB(0x4E342E),
                                                GTCPaletteTint900Name : ColorFromRGB(0x3E2723)
                                                }
                                      accents:nil];
    });
    return palette;
}

+ (GTCPalette *)greyPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xFAFAFA),
                                                GTCPaletteTint100Name : ColorFromRGB(0xF5F5F5),
                                                GTCPaletteTint200Name : ColorFromRGB(0xEEEEEE),
                                                GTCPaletteTint300Name : ColorFromRGB(0xE0E0E0),
                                                GTCPaletteTint400Name : ColorFromRGB(0xBDBDBD),
                                                GTCPaletteTint500Name : ColorFromRGB(0x9E9E9E),
                                                GTCPaletteTint600Name : ColorFromRGB(0x757575),
                                                GTCPaletteTint700Name : ColorFromRGB(0x616161),
                                                GTCPaletteTint800Name : ColorFromRGB(0x424242),
                                                GTCPaletteTint900Name : ColorFromRGB(0x212121)
                                                }
                                      accents:nil];
    });
    return palette;
}

+ (GTCPalette *)blueGreyPalette {
    static GTCPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTCPaletteTint50Name : ColorFromRGB(0xECEFF1),
                                                GTCPaletteTint100Name : ColorFromRGB(0xCFD8DC),
                                                GTCPaletteTint200Name : ColorFromRGB(0xB0BEC5),
                                                GTCPaletteTint300Name : ColorFromRGB(0x90A4AE),
                                                GTCPaletteTint400Name : ColorFromRGB(0x78909C),
                                                GTCPaletteTint500Name : ColorFromRGB(0x607D8B),
                                                GTCPaletteTint600Name : ColorFromRGB(0x546E7A),
                                                GTCPaletteTint700Name : ColorFromRGB(0x455A64),
                                                GTCPaletteTint800Name : ColorFromRGB(0x37474F),
                                                GTCPaletteTint900Name : ColorFromRGB(0x263238)
                                                }
                                      accents:nil];
    });
    return palette;
}

+ (instancetype)paletteGeneratedFromColor:(nonnull UIColor *)target500Color {
    NSArray *tintNames = @[
                           GTCPaletteTint50Name, GTCPaletteTint100Name, GTCPaletteTint200Name, GTCPaletteTint300Name,
                           GTCPaletteTint400Name, GTCPaletteTint500Name, GTCPaletteTint600Name, GTCPaletteTint700Name,
                           GTCPaletteTint800Name, GTCPaletteTint900Name, GTCPaletteAccent100Name, GTCPaletteAccent200Name,
                           GTCPaletteAccent400Name, GTCPaletteAccent700Name
                           ];

    NSMutableDictionary *tints = [[NSMutableDictionary alloc] init];
    for (GTCPaletteTint name in tintNames) {
        [tints setObject:GTCPaletteTintFromTargetColor(target500Color, name) forKey:name];
    }

    NSArray *accentNames = @[
                             GTCPaletteAccent100Name, GTCPaletteAccent200Name, GTCPaletteAccent400Name,
                             GTCPaletteAccent700Name
                             ];
    NSMutableDictionary *accents = [[NSMutableDictionary alloc] init];
    for (GTCPaletteAccent name in accentNames) {
        [accents setObject:GTCPaletteAccentFromTargetColor(target500Color, name) forKey:name];
    }

    return [self paletteWithTints:tints accents:accents];
}

+ (instancetype)paletteWithTints:(NSDictionary<GTCPaletteTint, UIColor *> *)tints
                         accents:(NSDictionary<GTCPaletteAccent, UIColor *> *)accents {
    return [[self alloc] initWithTints:tints accents:accents];
}

- (instancetype)initWithTints:(NSDictionary<GTCPaletteTint, UIColor *> *)tints
                      accents:(NSDictionary<GTCPaletteAccent, UIColor *> *)accents {
    self = [super init];
    if (self) {
        _accents = accents ? [accents copy] : @{};

        // Check if all the accent colors are present.
        NSDictionary<GTCPaletteTint, UIColor *> *allTints = tints;
        NSMutableSet<GTCPaletteAccent> *requiredTintKeys =
        [NSMutableSet setWithSet:[[self class] requiredTintKeys]];
        [requiredTintKeys minusSet:[NSSet setWithArray:[tints allKeys]]];
        if ([requiredTintKeys count] != 0) {
            NSAssert(NO, @"Missing accent colors for the following keys: %@.", requiredTintKeys);
            NSMutableDictionary<GTCPaletteTint, UIColor *> *replacementTints =
            [NSMutableDictionary dictionaryWithDictionary:_accents];
            for (GTCPaletteTint tintKey in requiredTintKeys) {
                [replacementTints setObject:[UIColor clearColor] forKey:tintKey];
            }
            allTints = replacementTints;
        }

        _tints = [allTints copy];
    }
    return self;
}

- (UIColor *)tint50 {
    return _tints[GTCPaletteTint50Name];
}

- (UIColor *)tint100 {
    return _tints[GTCPaletteTint100Name];
}

- (UIColor *)tint200 {
    return _tints[GTCPaletteTint200Name];
}

- (UIColor *)tint300 {
    return _tints[GTCPaletteTint300Name];
}

- (UIColor *)tint400 {
    return _tints[GTCPaletteTint400Name];
}

- (UIColor *)tint500 {
    return _tints[GTCPaletteTint500Name];
}

- (UIColor *)tint600 {
    return _tints[GTCPaletteTint600Name];
}

- (UIColor *)tint700 {
    return _tints[GTCPaletteTint700Name];
}

- (UIColor *)tint800 {
    return _tints[GTCPaletteTint800Name];
}

- (UIColor *)tint900 {
    return _tints[GTCPaletteTint900Name];
}

- (UIColor *)accent100 {
    return _accents[GTCPaletteAccent100Name];
}

- (UIColor *)accent200 {
    return _accents[GTCPaletteAccent200Name];
}

- (UIColor *)accent400 {
    return _accents[GTCPaletteAccent400Name];
}

- (UIColor *)accent700 {
    return _accents[GTCPaletteAccent700Name];
}

#pragma mark - Private methods

+ (nonnull NSSet<GTCPaletteTint> *)requiredTintKeys {
    return [NSSet setWithArray:@[
                                 GTCPaletteTint50Name, GTCPaletteTint100Name, GTCPaletteTint200Name, GTCPaletteTint300Name,
                                 GTCPaletteTint400Name, GTCPaletteTint500Name, GTCPaletteTint600Name, GTCPaletteTint700Name,
                                 GTCPaletteTint800Name, GTCPaletteTint900Name
                                 ]];
}

@end

