//
//  TextFieldInterfaceBuilderExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GTTextFields.h"

#import "supplemental/TextFieldInterfaceBuilderExampleSupplemental.h"

@interface TextFieldInterfaceBuilderExample () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet GTCTextField *firstTextField;
@property(nonatomic, strong) GTCTextInputControllerFilled *firstController;
@property(weak, nonatomic) IBOutlet GTCTextField *lastTextField;
@property(nonatomic, strong) GTCTextInputControllerFilled *lastController;
@property(weak, nonatomic) IBOutlet GTCTextField *address1TextField;
@property(nonatomic, strong) GTCTextInputControllerFilled *address1Controller;
@property(weak, nonatomic) IBOutlet GTCTextField *address2TextField;
@property(nonatomic, strong) GTCTextInputControllerFilled *address2Controller;
@property(weak, nonatomic) IBOutlet GTCMultilineTextField *messageTextField;
@property(nonatomic, strong) GTCTextInputControllerFilled *messageController;

@end

@implementation TextFieldInterfaceBuilderExample
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupExampleViews];

    self.firstController =
    [[GTCTextInputControllerFilled alloc] initWithTextInput:self.firstTextField];
    self.lastController = [[GTCTextInputControllerFilled alloc] initWithTextInput:self.lastTextField];
    self.address1Controller =
    [[GTCTextInputControllerFilled alloc] initWithTextInput:self.address1TextField];
    self.address2Controller =
    [[GTCTextInputControllerFilled alloc] initWithTextInput:self.address2TextField];

    // This will cause the text field to expand on overflow. This is because the default
    // for GTCTextInputControllerFilled is to do so. This overrides any choices in the
    // storyboard because it happens after the storyboard is awoken.
    self.messageController =
    [[GTCTextInputControllerFilled alloc] initWithTextInput:self.messageTextField];
    self.messageTextField.minimumLines = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.address2TextField.text = @"Apt 3F";
}

@end
