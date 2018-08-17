//
//  UIFont+GTCSimpleEquality.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "UIFont+GTCSimpleEquality.h"

#import "GTMath.h"

@implementation UIFont (GTCSimpleEquality)

- (BOOL)gtc_isSimplyEqual:(UIFont *)font {
    return [self.fontName isEqualToString:font.fontName] &&
    GTCCGFloatEqual(self.pointSize, font.pointSize) &&
    [[self.fontDescriptor objectForKey:UIFontDescriptorFaceAttribute]
     isEqual:[font.fontDescriptor objectForKey:UIFontDescriptorFaceAttribute]];
}

@end
