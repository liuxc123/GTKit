//
//  TextFieldControllerStylesExampleSupplemental.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

#import <UIKit/UIKit.h>

@interface TextFieldControllerStylesExample : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;

@end

@interface TextFieldControllerStylesExample (Supplemental)

- (void)setupExampleViews;

@end
