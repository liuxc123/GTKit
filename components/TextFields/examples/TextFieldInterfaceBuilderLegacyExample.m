//
//  TextFieldInterfaceBuilderLegacyExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GTTextFields.h"

#import "supplemental/TextFieldInterfaceBuilderExampleSupplemental.h"

@interface TextFieldInterfaceBuilderLegacyExample () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet GTCTextField *firstTextField;
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *firstController;
@property(weak, nonatomic) IBOutlet GTCTextField *lastTextField;
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *lastController;
@property(weak, nonatomic) IBOutlet GTCTextField *address1TextField;
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *address1Controller;
@property(weak, nonatomic) IBOutlet GTCTextField *address2TextField;
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *address2Controller;
@property(weak, nonatomic) IBOutlet GTCMultilineTextField *messageTextField;
@property(nonatomic, strong) GTCTextInputControllerLegacyDefault *messageController;

@end

@implementation TextFieldInterfaceBuilderLegacyExample

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupExampleViews];

    self.firstController =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:self.firstTextField];
    self.lastController =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:self.lastTextField];
    self.address1Controller =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:self.address1TextField];
    self.address2Controller =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:self.address2TextField];

    // This will cause the text field to expand on overflow. This is because the default
    // for GTCTextInputControllerFilled is to do so. This overrides any choices in the
    // storyboard because it happens after the storyboard is awoken.
    self.messageController =
    [[GTCTextInputControllerLegacyDefault alloc] initWithTextInput:self.messageTextField];
    self.messageTextField.minimumLines = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.address2TextField.text = @"Apt 3F";
}

@end

