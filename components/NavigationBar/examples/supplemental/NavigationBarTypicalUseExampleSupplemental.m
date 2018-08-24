//
//  NavigationBarTypicalUseExampleSupplemental.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import "NavigationBarTypicalUseExampleSupplemental.h"

#import "GTPalettes.h"

@interface ExampleInstructionsViewNavigationBarTypicalUseExample : UIView

@end

@implementation NavigationBarTypicalUseExample (Supplemental)

- (void)setupExampleViews {
    self.exampleView = [[ExampleInstructionsViewNavigationBarTypicalUseExample alloc]
                        initWithFrame:self.view.bounds];
    [self.view insertSubview:self.exampleView belowSubview:self.navBar];

    self.exampleView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *viewBindings = @{ @"exampleView" : self.exampleView, @"navBar" : self.navBar };
    NSMutableArray<__kindof NSLayoutConstraint *> *arrayOfConstraints = [NSMutableArray array];

    // clang-format off
    [arrayOfConstraints addObjectsFromArray:[NSLayoutConstraint
                                             constraintsWithVisualFormat:@"H:|[exampleView]|"
                                             options:0
                                             metrics:nil
                                             views:viewBindings]];
    [arrayOfConstraints addObjectsFromArray:[NSLayoutConstraint
                                             constraintsWithVisualFormat:@"V:[navBar]-[exampleView]|"
                                             options:0
                                             metrics:nil
                                             views:viewBindings]];
    // clang-format on
    [self.view addConstraints:arrayOfConstraints];
}

@end

@implementation NavigationBarTypicalUseExample (CatalogByConvention)

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Navigation Bar", @"Navigation Bar" ];
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

+ (NSString *)catalogDescription {
    return @"The Navigation Bar component is a view composed of a left and right Button Bar and"
    " either a title label or a custom title view.";
}

+ (BOOL)catalogIsPrimaryDemo {
    return YES;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end

@implementation NavigationBarTypicalUseExample (Rotation)

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [self.exampleView setNeedsDisplay];
}

@end

@implementation ExampleInstructionsViewNavigationBarTypicalUseExample

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:rect] fill];

    CGSize textSize = [self textSizeForRect:rect];
    CGRect rectForText = CGRectMake(rect.origin.x + rect.size.width / 2.f - textSize.width / 2.f,
                                    rect.origin.y + rect.size.height / 2.f - textSize.height / 2.f,
                                    textSize.width, textSize.height);
    [[self instructionsString] drawInRect:rectForText];
    [self drawArrowWithFrame:CGRectMake(rect.size.width / 2.f - 12.f,
                                        rect.size.height / 2.f - 58.f - 12.f, 24.f, 24.f)];
}

- (CGSize)textSizeForRect:(CGRect)frame {
    return [[self instructionsString] boundingRectWithSize:frame.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                                                   context:nil]
    .size;
}

- (NSAttributedString *)instructionsString {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];

    NSDictionary *instructionAttributes1 = @{
                                             NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                             NSForegroundColorAttributeName :
                                                 [GTCPalette.greyPalette.tint600 colorWithAlphaComponent:0.87f],
                                             NSParagraphStyleAttributeName : style
                                             };

    NSDictionary *instructionAttributes2 = @{
                                             NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],
                                             NSForegroundColorAttributeName :
                                                 [GTCPalette.greyPalette.tint600 colorWithAlphaComponent:0.87f],
                                             NSParagraphStyleAttributeName : style
                                             };

    NSString *instructionText = @"SWIPE RIGHT\n\n\n\nfrom left edge to go back\n\n\n\n\n\n";
    NSMutableAttributedString *instructionsAttributedString =
    [[NSMutableAttributedString alloc] initWithString:instructionText];
    [instructionsAttributedString setAttributes:instructionAttributes1 range:NSMakeRange(0, 11)];
    [instructionsAttributedString setAttributes:instructionAttributes2
                                          range:NSMakeRange(11, instructionText.length - 11)];

    return instructionsAttributedString;
}

- (void)drawArrowWithFrame:(CGRect)frame {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 12, CGRectGetMinY(frame) + 4)];
    [bezierPath
     addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 10.59f, CGRectGetMinY(frame) + 5.41f)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 16.17f, CGRectGetMinY(frame) + 11)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 11)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 13)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 16.17f, CGRectGetMinY(frame) + 13)];
    [bezierPath
     addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 10.59f, CGRectGetMinY(frame) + 18.59f)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 12, CGRectGetMinY(frame) + 20)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 12)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 12, CGRectGetMinY(frame) + 4)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;

    [[GTCPalette.greyPalette.tint600 colorWithAlphaComponent:0.87f] setFill];
    [bezierPath fill];
}

@end
