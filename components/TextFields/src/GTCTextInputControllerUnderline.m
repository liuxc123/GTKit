//
//  GTCTextInputControllerUnderline.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerUnderline.h"

static const CGFloat GTCTextInputControllerUnderlineDefaultUnderlineActiveHeight = 2;
static const CGFloat GTCTextInputControllerUnderlineDefaultUnderlineNormalHeight = 1;

static CGFloat _underlineHeightActiveDefault =
GTCTextInputControllerUnderlineDefaultUnderlineActiveHeight;
static CGFloat _underlineHeightNormalDefault =
GTCTextInputControllerUnderlineDefaultUnderlineNormalHeight;

@interface GTCTextInputControllerUnderline ()
@end

@implementation GTCTextInputControllerUnderline

#pragma mark - Properties

+ (CGFloat)underlineHeightActiveDefault {
    return _underlineHeightActiveDefault;
}

+ (void)setUnderlineHeightActiveDefault:(CGFloat)underlineHeightActiveDefault {
    _underlineHeightActiveDefault = underlineHeightActiveDefault;
}

+ (CGFloat)underlineHeightNormalDefault {
    return _underlineHeightNormalDefault;
}

+ (void)setUnderlineHeightNormalDefault:(CGFloat)underlineHeightNormalDefault {
    _underlineHeightNormalDefault = underlineHeightNormalDefault;
}

@end
