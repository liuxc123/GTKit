//
//  GTCFormViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "GTCFormOptionsViewController.h"
#import "GTCFormDescriptor.h"
#import "GTCFormSectionDescriptor.h"
#import "GTCFormDescriptorDelegate.h"
#import "GTCFormRowNavigationAccessoryView.h"
#import "GTCFormBaseCell.h"

@class GTCFormViewController;
@class GTCFormRowDescriptor;
@class GTCFormSectionDescriptor;
@class GTCFormDescriptor;
@class GTCFormBaseCell;

typedef NS_ENUM(NSUInteger, GTCFormRowNavigationDirection) {
    GTCFormRowNavigationDirectionPrevious = 0,
    GTCFormRowNavigationDirectionNext
};

@protocol GTCFormViewControllerDelegate <NSObject>

@optional

-(void)didSelectFormRow:(GTCFormRowDescriptor *)formRow;
-(void)deselectFormRow:(GTCFormRowDescriptor *)formRow;
-(void)reloadFormRow:(GTCFormRowDescriptor *)formRow;
-(GTCFormBaseCell *)updateFormRow:(GTCFormRowDescriptor *)formRow;

-(NSDictionary *)formValues;
-(NSDictionary *)httpParameters;

-(GTCFormRowDescriptor *)formRowFormMultivaluedFormSection:(GTCFormSectionDescriptor *)formSection;
-(void)multivaluedInsertButtonTapped:(GTCFormRowDescriptor *)formRow;
-(UIStoryboard *)storyboardForRow:(GTCFormRowDescriptor *)formRow;

-(NSArray *)formValidationErrors;
-(void)showFormValidationError:(NSError *)error;
-(void)showFormValidationError:(NSError *)error withTitle:(NSString*)title;

-(UITableViewRowAnimation)insertRowAnimationForRow:(GTCFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)deleteRowAnimationForRow:(GTCFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)insertRowAnimationForSection:(GTCFormSectionDescriptor *)formSection;
-(UITableViewRowAnimation)deleteRowAnimationForSection:(GTCFormSectionDescriptor *)formSection;

// InputAccessoryView
-(UIView *)inputAccessoryViewForRowDescriptor:(GTCFormRowDescriptor *)rowDescriptor;
-(GTCFormRowDescriptor *)nextRowDescriptorForRow:(GTCFormRowDescriptor*)currentRow withDirection:(GTCFormRowNavigationDirection)direction;

// highlight/unhighlight
-(void)beginEditing:(GTCFormRowDescriptor *)rowDescriptor;
-(void)endEditing:(GTCFormRowDescriptor *)rowDescriptor;

-(void)ensureRowIsVisible:(GTCFormRowDescriptor *)inlineRowDescriptor;

@end

@interface GTCFormViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GTCFormDescriptorDelegate, UITextFieldDelegate, UITextViewDelegate, GTCFormViewControllerDelegate>

@property GTCFormDescriptor * form;
@property IBOutlet UITableView * tableView;

-(instancetype)initWithForm:(GTCFormDescriptor *)form;
-(instancetype)initWithForm:(GTCFormDescriptor *)form style:(UITableViewStyle)style;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
+(NSMutableDictionary *)cellClassesForRowDescriptorTypes;
+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;

-(void)performFormSelector:(SEL)selector withObject:(id)sender;

@end
