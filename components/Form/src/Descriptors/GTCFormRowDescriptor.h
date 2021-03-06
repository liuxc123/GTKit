//
//  GTCFormRowDescriptor.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormBaseCell.h"
#import "GTCFormValidatorProtocol.h"
#import "GTCFormValidationStatus.h"

extern CGFloat GTCFormUnspecifiedCellHeight;

@class GTCFormSectionDescriptor;
@class GTCFormRowDescriptor;
@class GTCFormValidatorProtocol;
@class GTCFormAction;
@class GTCFormBaseCell;

typedef NS_ENUM(NSUInteger, GTCFormPresentationMode) {
    GTCFormPresentationModeDefault = 0,
    GTCFormPresentationModePush,
    GTCFormPresentationModePresent
};

typedef void(^GTCOnChangeBlock)(id __nullable oldValue,id __nullable newValue,GTCFormRowDescriptor* __nonnull rowDescriptor);


@interface GTCFormRowDescriptor : NSObject

@property (nullable) id cellClass;                      //cell类
@property (readwrite, nullable) NSString * tag;         //标记tag
@property (readonly, nonnull) NSString * rowType;       //row类型
@property (nullable) NSString * title;                  //标题
@property (nonatomic, nullable) id value;               //值（任意类型 根据cell不同情况返回）
@property (nullable) Class valueTransformer;
@property (nonatomic) CGFloat height;                   //cell高度

@property UITableViewCellStyle cellStyle;               //cellStyle
@property UITableViewCellAccessoryType accessoryType;   //accessoryType
@property UITableViewCellSelectionStyle selectionStyle; //selectionStyle

@property (copy, nullable) GTCOnChangeBlock onChangeBlock;
@property BOOL useValueFormatterDuringInput;
@property (nullable) NSFormatter *valueFormatter;

// returns the display text for the row descriptor, taking into account NSFormatters and default placeholder values
- (nonnull NSString *) displayTextValue;

// returns the editing text value for the row descriptor, taking into account NSFormatters.
- (nonnull NSString *) editTextValue;

@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfig;
@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfigForSelector;
@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfigIfDisabled;
@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfigAtConfigure;

@property (nonnull) id disabled;
-(BOOL)isDisabled;
@property (nonnull) id hidden;
-(BOOL)isHidden;
@property (getter=isRequired) BOOL required;

@property (nonnull) GTCFormAction * action;

@property (weak, null_unspecified) GTCFormSectionDescriptor * sectionDescriptor;

+(nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType;
+(nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;
-(nonnull instancetype)initWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;

-(GTCFormBaseCell *)cellForFormController:(GTCFormViewController * __unused)formController;

@property (nullable) NSString *requireMsg;
- (void)removeValidator:(nonnull id)validator;
- (void)addValidator:(nonnull id)validator;
-(nullable GTCFormValidationStatus *)doValidation;


// ===========================
// property used for Selectors
// ===========================
@property (nullable) NSString * noValueDisplayText;
@property (nullable) NSString * selectorTitle;
@property (nullable) NSArray * selectorOptions;

@property (null_unspecified) id leftRightSelectorLeftOptionSelected;


@end


typedef NS_ENUM(NSUInteger, GTCFormLeftRightSelectorOptionLeftValueChangePolicy)
{
    GTCFormLeftRightSelectorOptionLeftValueChangePolicyNullifyRightValue = 0,
    GTCFormLeftRightSelectorOptionLeftValueChangePolicyChooseFirstOption,
    GTCFormLeftRightSelectorOptionLeftValueChangePolicyChooseLastOption
};


// =====================================
// helper object used for LEFTRIGHTSelector Descriptor
// =====================================
@interface GTCFormLeftRightSelectorOption : NSObject

@property (nonatomic, assign) GTCFormLeftRightSelectorOptionLeftValueChangePolicy leftValueChangePolicy;
@property (readonly, nonnull) id leftValue;
@property (readonly, nonnull) NSArray *  rightOptions;
@property (readonly, null_unspecified) NSString * httpParameterKey;
@property (nullable) Class rightSelectorControllerClass;

@property (nullable) NSString * noValueDisplayText;
@property (nullable) NSString * selectorTitle;


+(nonnull GTCFormLeftRightSelectorOption *)formLeftRightSelectorOptionWithLeftValue:(nonnull id)leftValue
                                                                  httpParameterKey:(null_unspecified NSString *)httpParameterKey
                                                                      rightOptions:(nonnull NSArray *)rightOptions;


@end

@protocol GTCFormOptionObject

@required

-(nonnull NSString *)formDisplayText;
-(nonnull id)formValue;

@end

@interface GTCFormAction : NSObject

@property (nullable, nonatomic, strong) Class viewControllerClass;
@property (nullable, nonatomic, strong) NSString * viewControllerStoryboardId;
@property (nullable, nonatomic, strong) NSString * viewControllerNibName;

@property (nonatomic) GTCFormPresentationMode viewControllerPresentationMode;

@property (nullable, nonatomic, strong) void (^formBlock)(GTCFormRowDescriptor * __nonnull sender);
@property (nullable, nonatomic) SEL formSelector;
@property (nullable, nonatomic, strong) NSString * formSegueIdentifier;
@property (nullable, nonatomic, strong) Class formSegueClass;

@end
