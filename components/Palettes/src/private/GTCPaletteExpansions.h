//
//  GTCPaletteExpansions.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

UIColor* _Nonnull GTCPaletteTintFromTargetColor(UIColor* _Nonnull targetColor,
                                                NSString* _Nonnull tintName);

UIColor* _Nonnull GTCPaletteAccentFromTargetColor(UIColor* _Nonnull targetColor,
                                                  NSString* _Nonnull accentName);
