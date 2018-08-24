//
//  ButtonsContentEdgeInsetsExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

#import "GTButtons.h"
#import "GTButtons+ButtonThemer.h"

@interface ButtonsContentEdgeInsetsExample : UIViewController
@property(weak, nonatomic) IBOutlet GTCButton *textButton;
@property(weak, nonatomic) IBOutlet GTCButton *containedButton;
@property(weak, nonatomic) IBOutlet GTCFloatingButton *floatingActionButton;
@property(weak, nonatomic) IBOutlet UISwitch *inkBoundingSwitch;
@end

@implementation ButtonsContentEdgeInsetsExample

#pragma mark - Catalog by Convention

+ (NSArray<NSString *> *)catalogBreadcrumbs {
    return @[ @"Buttons", @"Buttons (Content Edge Insets)" ];
}

+ (NSString *)catalogStoryboardName {
    return @"ButtonsContentEdgeInsets";
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    GTCButtonScheme *buttonScheme = [[GTCButtonScheme alloc] init];
    [GTCContainedButtonThemer applyScheme:buttonScheme toButton:self.containedButton];
    [GTCTextButtonThemer applyScheme:buttonScheme toButton:self.textButton];

    self.textButton.contentEdgeInsets = UIEdgeInsetsMake(64, 64, 0, 0);
    self.containedButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 64, 64);
    [self.floatingActionButton setContentEdgeInsets:UIEdgeInsetsMake(40, 40, 0, 0)
                                           forShape:GTCFloatingButtonShapeDefault
                                             inMode:GTCFloatingButtonModeExpanded];


    [self updateInkStyle:self.inkBoundingSwitch.isOn ? GTCInkStyleBounded : GTCInkStyleUnbounded];
}

- (IBAction)didChangeInkStyle:(UISwitch *)sender {
    [self updateInkStyle:sender.isOn ? GTCInkStyleBounded : GTCInkStyleUnbounded];
}

- (void)updateInkStyle:(GTCInkStyle)inkStyle {
    self.textButton.inkStyle = inkStyle;
    self.containedButton.inkStyle = inkStyle;
    self.floatingActionButton.inkStyle = inkStyle;
}


@end
