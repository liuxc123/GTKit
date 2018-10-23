//
//  GTCFormSectionDescriptor.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormRowDescriptor.h"

typedef NS_OPTIONS(NSUInteger, GTCFormSectionOptions) {
    GTCFormSectionOptionNone        = 0,
    GTCFormSectionOptionCanInsert   = 1 << 0,
    GTCFormSectionOptionCanDelete   = 1 << 1,
    GTCFormSectionOptionCanReorder  = 1 << 2
};

typedef NS_ENUM(NSUInteger, GTCFormSectionInsertMode) {
    GTCFormSectionInsertModeLastRow = 0,
    GTCFormSectionInsertModeButton = 2
};

@class GTCFormDescriptor;

@interface GTCFormSectionDescriptor : NSObject

@property (nonatomic, nullable) NSString * title;
@property (nonatomic, nullable) NSString * footerTitle;
@property (readonly, nonnull) NSMutableArray * formRows;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;


@property (nonatomic, assign) BOOL cellTitleEqualWidth;
@property (nonatomic) CGFloat cellTitleMaxWidth;

@property (readonly) GTCFormSectionInsertMode sectionInsertMode;
@property (readonly) GTCFormSectionOptions sectionOptions;
@property (nullable) GTCFormRowDescriptor * multivaluedRowTemplate;
@property (readonly, nullable) GTCFormRowDescriptor * multivaluedAddButton;
@property (nonatomic, nullable) NSString * multivaluedTag;

@property (weak, null_unspecified) GTCFormDescriptor * formDescriptor;

@property (nonnull) id hidden;
-(BOOL)isHidden;

+(nonnull instancetype)formSection;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(GTCFormSectionOptions)sectionOptions;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(GTCFormSectionOptions)sectionOptions sectionInsertMode:(GTCFormSectionInsertMode)sectionInsertMode;

-(BOOL)isMultivaluedSection;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow afterRow:(nonnull GTCFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull GTCFormRowDescriptor *)formRow beforeRow:(nonnull GTCFormRowDescriptor *)beforeRow;
-(void)removeFormRowAtIndex:(NSUInteger)index;
-(void)removeFormRow:(nonnull GTCFormRowDescriptor *)formRow;
-(void)moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndex toIndexPath:(nonnull NSIndexPath *)destinationIndex;

@end
