//
//  GTCTextInputControllerLegacyFullWidth.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import "GTCTextInputControllerLegacyFullWidth.h"

#import "GTCIntrinsicHeightTextView.h"
#import "GTCMultilineTextField.h"
#import "GTCTextField.h"
#import "GTCTextInput.h"
#import "GTCTextInputCharacterCounter.h"
#import "GTCTextInputUnderlineView.h"
#import "private/GTCTextInputArt.h"

#import "GTAnimationTiming.h"
#import "GTMath.h"
#import "GTPalettes.h"
#import "GTTypography.h"

static const CGFloat GTCTextInputControllerLegacyFullWidthClearButtonImageSquareWidthHeight = 24.f;

@interface GTCTextInputControllerFullWidth ()
- (void)setupInput;
@end
@implementation GTCTextInputControllerLegacyFullWidth


- (void)setupInput {
    [super setupInput];
    if (!self.textInput) {
        return;
    }

    [self setupClearButton];
}

- (void)setupClearButton {
    UIImage *image = [self
                      drawnClearButtonImage:[UIColor colorWithWhite:0 alpha:[GTCTypography captionFontOpacity]]];
    [self.textInput.clearButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Clear Button Customization

- (UIImage *)drawnClearButtonImage:(UIColor *)color {
    CGSize clearButtonSize =
    CGSizeMake(GTCTextInputControllerLegacyFullWidthClearButtonImageSquareWidthHeight,
               GTCTextInputControllerLegacyFullWidthClearButtonImageSquareWidthHeight);

    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect bounds = CGRectMake(0, 0, clearButtonSize.width * scale, clearButtonSize.height * scale);
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
    [color setFill];

    [GTCPathForClearButtonLegacyImageFrame(bounds) fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

@end
