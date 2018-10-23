//
//  GTCFormDescriptor.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormRowDescriptor.h"
#import "GTCFormSectionDescriptor.h"
#import "GTCFormDescriptorDelegate.h"

extern NSString * __nonnull const GTCFormErrorDomain;
extern NSString * __nonnull const GTCValidationStatusErrorKey;

typedef NS_ENUM(NSInteger, GTCFormErrorCode)
{
    GTCFormErrorCodeGen = -999,
    GTCFormErrorCodeRequired = -1000
};

typedef NS_OPTIONS(NSUInteger, GTCFormRowNavigationOptions) {
    GTCFormRowNavigationOptionNone                               = 0,
    GTCFormRowNavigationOptionEnabled                            = 1 << 0,
    GTCFormRowNavigationOptionStopDisableRow                     = 1 << 1,
    GTCFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow  = 1 << 2,
    GTCFormRowNavigationOptionStopInlineRow                      = 1 << 3,
};

@class GTCFormSectionDescriptor;

@interface GTCFormDescriptor : NSObject

@property (readonly, nonatomic, nonnull) NSMutableArray * formSections;
@property (readonly, nullable) NSString * title;
@property (nonatomic) BOOL endEditingTableViewOnScroll;
@property (nonatomic) BOOL assignFirstResponderOnShow;
@property (nonatomic) BOOL addAsteriskToRequiredRowsTitle;
@property (getter=isDisabled) BOOL disabled;
@property (nonatomic) GTCFormRowNavigationOptions rowNavigationOptions;

@property (weak, nullable) id<GTCFormDescriptorDelegate> delegate;

+(nonnull instancetype)formDescriptor;
+(nonnull instancetype)formDescriptorWithTitle:(nullable NSString *)title;

-(void)addFormSection:(nonnull GTCFormSectionDescriptor *)formSection;
-(void)addFormSection:(nonnull GTCFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)addFormSection:(nonnull GTCFormSectionDescriptor *)formSection afterSection:(nonnull GTCFormSectionDescriptor *)afterSection;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow beforeRow:(nonnull GTCFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow beforeRowTag:(nonnull NSString *)afterRowTag;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow afterRow:(nonnull GTCFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow afterRowTag:(nonnull NSString *)afterRowTag;
-(void)removeFormSectionAtIndex:(NSUInteger)index;
-(void)removeFormSection:(nonnull GTCFormSectionDescriptor *)formSection;
-(void)removeFormRow:(nonnull GTCFormRowDescriptor *)formRow;
-(void)removeFormRowWithTag:(nonnull NSString *)tag;

-(nullable GTCFormRowDescriptor *)formRowWithTag:(nonnull NSString *)tag;
-(nullable GTCFormRowDescriptor *)formRowAtIndex:(nonnull NSIndexPath *)indexPath;
-(nullable GTCFormRowDescriptor *)formRowWithHash:(NSUInteger)hash;
-(nullable GTCFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index;

-(nullable NSIndexPath *)indexPathOfFormRow:(nonnull GTCFormRowDescriptor *)formRow;

-(nonnull NSDictionary *)formValues;
-(nonnull NSDictionary *)httpParameters:(nonnull GTCFormViewController *)formViewController;

-(nonnull NSArray *)localValidationErrors:(nonnull GTCFormViewController *)formViewController;
-(void)setFirstResponder:(nonnull GTCFormViewController *)formViewController;

-(nullable GTCFormRowDescriptor *)nextRowDescriptorForRow:(nonnull GTCFormRowDescriptor *)currentRow;
-(nullable GTCFormRowDescriptor *)previousRowDescriptorForRow:(nonnull GTCFormRowDescriptor *)currentRow;

-(void)forceEvaluate;

@end
