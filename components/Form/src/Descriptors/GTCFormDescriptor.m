//
//  GTCFormDescriptor.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormDescriptor.h"
#import "../Helpers/NSObject+GTCFormAdditions.h"
#import "../Helpers/NSPredicate+GTCFormAdditions.h"
#import "../Helpers/NSString+GTCFormAdditions.h"

NSString * const GTCFormErrorDomain = @"GTCFormErrorDomain";
NSString * const GTCValidationStatusErrorKey = @"GTCValidationStatusErrorKey";


@interface GTCFormSectionDescriptor (_GTCFormDescriptor)

@property NSArray * allRows;
-(BOOL)evaluateIsHidden;

@end


@interface GTCFormRowDescriptor(_GTCFormDescriptor)

-(BOOL)evaluateIsDisabled;
-(BOOL)evaluateIsHidden;

@end


@interface GTCFormDescriptor()

@property NSMutableArray * formSections;
@property (readonly) NSMutableArray * allSections;
@property NSString * title;
@property (readonly) NSMutableDictionary* allRowsByTag;
@property NSMutableDictionary* rowObservers;

@end

@implementation GTCFormDescriptor

-(instancetype)init
{
    return [self initWithTitle:nil];
}

-(instancetype)initWithTitle:(NSString *)title;
{
    self = [super init];
    if (self){
        _formSections = [NSMutableArray array];
        _allSections = [NSMutableArray array];
        _allRowsByTag = [NSMutableDictionary dictionary];
        _rowObservers = [NSMutableDictionary dictionary];
        _title = title;
        _addAsteriskToRequiredRowsTitle = NO;
        _disabled = NO;
        _endEditingTableViewOnScroll = YES;
        _rowNavigationOptions = GTCFormRowNavigationOptionEnabled;
        [self addObserver:self forKeyPath:@"formSections" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:0];
    }
    return self;
}

+(instancetype)formDescriptor
{
    return [[self class] formDescriptorWithTitle:nil];
}

+(instancetype)formDescriptorWithTitle:(NSString *)title
{
    return [[[self class] alloc] initWithTitle:title];
}

-(void)addFormSection:(GTCFormSectionDescriptor *)formSection
{
    [self insertObject:formSection inAllSectionsAtIndex:[self.allSections count]];
}

-(void)addFormSection:(GTCFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    if (index == 0){
        [self insertObject:formSection inAllSectionsAtIndex:0];
    }
    else{
        GTCFormSectionDescriptor* previousSection = [self.formSections objectAtIndex:MIN(self.formSections.count, index-1)];
        [self addFormSection:formSection afterSection:previousSection];
    }
}

-(void)addFormSection:(GTCFormSectionDescriptor *)formSection afterSection:(GTCFormSectionDescriptor *)afterSection
{
    NSUInteger sectionIndex;
    NSUInteger allSectionIndex;
    if ((sectionIndex = [self.allSections indexOfObject:formSection]) == NSNotFound){
        allSectionIndex = [self.allSections indexOfObject:afterSection];
        if (allSectionIndex != NSNotFound) {
            [self insertObject:formSection inAllSectionsAtIndex:(allSectionIndex + 1)];
        }
        else { //case when afterSection does not exist. Just insert at the end.
            [self addFormSection:formSection];
            return;
        }
    }
    formSection.hidden = formSection.hidden;
}


-(void)addFormRow:(GTCFormRowDescriptor *)formRow beforeRow:(GTCFormRowDescriptor *)beforeRow
{
    if (beforeRow.sectionDescriptor){
        [beforeRow.sectionDescriptor addFormRow:formRow beforeRow:beforeRow];
    }
    else{
        [[self.allSections lastObject] addFormRow:formRow beforeRow:beforeRow];
    }
}

-(void)addFormRow:(GTCFormRowDescriptor *)formRow beforeRowTag:(NSString *)beforeRowTag
{
    GTCFormRowDescriptor * beforeRowForm = [self formRowWithTag:beforeRowTag];
    [self addFormRow:formRow beforeRow:beforeRowForm];
}



-(void)addFormRow:(GTCFormRowDescriptor *)formRow afterRow:(GTCFormRowDescriptor *)afterRow
{
    if (afterRow.sectionDescriptor){
        [afterRow.sectionDescriptor addFormRow:formRow afterRow:afterRow];
    }
    else{
        [[self.allSections lastObject] addFormRow:formRow afterRow:afterRow];
    }
}

-(void)addFormRow:(GTCFormRowDescriptor *)formRow afterRowTag:(NSString *)afterRowTag
{
    GTCFormRowDescriptor * afterRowForm = [self formRowWithTag:afterRowTag];
    [self addFormRow:formRow afterRow:afterRowForm];
}

-(void)removeFormSectionAtIndex:(NSUInteger)index
{
    if (self.formSections.count > index){
        GTCFormSectionDescriptor *formSection = [self.formSections objectAtIndex:index];
        [self removeObjectFromFormSectionsAtIndex:index];
        NSUInteger allSectionIndex = [self.allSections indexOfObject:formSection];
        [self removeObjectFromAllSectionsAtIndex:allSectionIndex];
    }
}

-(void)removeFormSection:(GTCFormSectionDescriptor *)formSection
{
    NSUInteger index = NSNotFound;
    if ((index = [self.formSections indexOfObject:formSection]) != NSNotFound){
        [self removeFormSectionAtIndex:index];
    }
    else if ((index = [self.allSections indexOfObject:formSection]) != NSNotFound){
        [self removeObjectFromAllSectionsAtIndex:index];
    };
}

-(void)removeFormRow:(GTCFormRowDescriptor *)formRow
{
    for (GTCFormSectionDescriptor * section in self.formSections){
        if ([section.formRows containsObject:formRow]){
            [section removeFormRow:formRow];
        }
    }
}

-(void)showFormSection:(GTCFormSectionDescriptor*)formSection
{
    NSUInteger formIndex = [self.formSections indexOfObject:formSection];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allSections indexOfObject:formSection];
    if (index != NSNotFound){
        while (formIndex == NSNotFound && index > 0) {
            GTCFormSectionDescriptor* previous = [self.allSections objectAtIndex:--index];
            formIndex = [self.formSections indexOfObject:previous];
        }
        [self insertObject:formSection inFormSectionsAtIndex:(formIndex == NSNotFound ? 0 : ++formIndex)];
    }
}

-(void)hideFormSection:(GTCFormSectionDescriptor*)formSection
{
    NSUInteger index = [self.formSections indexOfObject:formSection];
    if (index != NSNotFound){
        [self removeObjectFromFormSectionsAtIndex:index];
    }
}


-(GTCFormRowDescriptor *)formRowWithTag:(NSString *)tag
{
    return self.allRowsByTag[tag];
}

-(GTCFormRowDescriptor *)formRowWithHash:(NSUInteger)hash
{
    for (GTCFormSectionDescriptor * section in self.allSections){
        for (GTCFormRowDescriptor * row in section.allRows) {
            if ([row hash] == hash){
                return row;
            }
        }
    }
    return nil;
}


-(void)removeFormRowWithTag:(NSString *)tag
{
    GTCFormRowDescriptor * formRow = [self formRowWithTag:tag];
    [self removeFormRow:formRow];
}

-(GTCFormRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath
{
    if ((self.formSections.count > indexPath.section) && [[self.formSections objectAtIndex:indexPath.section] formRows].count > indexPath.row){
        return [[[self.formSections objectAtIndex:indexPath.section] formRows] objectAtIndex:indexPath.row];
    }
    return nil;
}

-(GTCFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index
{
    return [self objectInFormSectionsAtIndex:index];
}

-(NSIndexPath *)indexPathOfFormRow:(GTCFormRowDescriptor *)formRow
{
    GTCFormSectionDescriptor * section = formRow.sectionDescriptor;
    if (section){
        NSUInteger sectionIndex = [self.formSections indexOfObject:section];
        if (sectionIndex != NSNotFound){
            NSUInteger rowIndex = [section.formRows indexOfObject:formRow];
            if (rowIndex != NSNotFound){
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

-(NSIndexPath *)globalIndexPathOfFormRow:(GTCFormRowDescriptor *)formRow
{
    GTCFormSectionDescriptor * section = formRow.sectionDescriptor;
    if (section){
        NSUInteger sectionIndex = [self.allSections indexOfObject:section];
        if (sectionIndex != NSNotFound){
            NSUInteger rowIndex = [section.allRows indexOfObject:formRow];
            if (rowIndex != NSNotFound){
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

-(NSDictionary *)formValues
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    for (GTCFormSectionDescriptor * section in self.formSections) {
        if (section.multivaluedTag.length > 0){
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            for (GTCFormRowDescriptor * row in section.formRows) {
                if (row.value){
                    [multiValuedValuesArray addObject:row.value];
                }
            }
            [result setObject:multiValuedValuesArray forKey:section.multivaluedTag];
        }
        else{
            for (GTCFormRowDescriptor * row in section.formRows) {
                if (row.tag.length > 0){
                    [result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
                }
            }
        }
    }
    return result;
}

-(NSDictionary *)httpParameters:(GTCFormViewController *)formViewController
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    for (GTCFormSectionDescriptor * section in self.formSections) {
        if (section.multivaluedTag.length > 0){
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            for (GTCFormRowDescriptor * row in section.formRows) {
                if ([row.value valueData]){
                    [multiValuedValuesArray addObject:[row.value valueData]];
                }
            }
            [result setObject:multiValuedValuesArray forKey:section.multivaluedTag];
        }
        else{
            for (GTCFormRowDescriptor * row in section.formRows) {
                NSString * httpParameterKey = nil;
                if ((httpParameterKey = [self httpParameterKeyForRow:row cell:[row cellForFormController:formViewController]])){
                    id parameterValue = [row.value valueData] ?: [NSNull null];
                    [result setObject:parameterValue forKey:httpParameterKey];
                }
            }
        }
    }
    return result;
}

-(NSString *)httpParameterKeyForRow:(GTCFormRowDescriptor *)row cell:(UITableViewCell<GTCFormDescriptorCell> *)descriptorCell
{
    if ([descriptorCell respondsToSelector:@selector(formDescriptorHttpParameterName)]){
        return [descriptorCell formDescriptorHttpParameterName];
    }
    if (row.tag.length > 0){
        return row.tag;
    }
    return nil;
}

-(NSArray *)localValidationErrors:(GTCFormViewController *)formViewController {
    NSMutableArray * result = [NSMutableArray array];
    for (GTCFormSectionDescriptor * section in self.formSections) {
        for (GTCFormRowDescriptor * row in section.formRows) {
            GTCFormValidationStatus* status = [row doValidation];
            if (status != nil && (![status isValid])) {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: status.msg,
                                            GTCValidationStatusErrorKey: status };
                NSError * error = [[NSError alloc] initWithDomain:GTCFormErrorDomain code:GTCFormErrorCodeGen userInfo:userInfo];
                if (error){
                    [result addObject:error];
                }
            }
        }
    }

    return result;
}


- (void)setFirstResponder:(GTCFormViewController *)formViewController
{
    for (GTCFormSectionDescriptor * formSection in self.formSections) {
        for (GTCFormRowDescriptor * row in formSection.formRows) {
            UITableViewCell<GTCFormDescriptorCell> * cell = [row cellForFormController:formViewController];
            if ([cell formDescriptorCellCanBecomeFirstResponder]){
                if ([cell formDescriptorCellBecomeFirstResponder]){
                    return;
                }
            }
        }
    }
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.delegate) return;
    if ([keyPath isEqualToString:@"formSections"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            GTCFormSectionDescriptor * section = [self.formSections objectAtIndex:indexSet.firstIndex];
            [self.delegate formSectionHasBeenAdded:section atIndex:indexSet.firstIndex];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            GTCFormSectionDescriptor * removedSection = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
            [self.delegate formSectionHasBeenRemoved:removedSection atIndex:indexSet.firstIndex];
        }
    }
}

-(void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"formSections"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - KVC

-(NSUInteger)countOfFormSections
{
    return self.formSections.count;
}

- (id)objectInFormSectionsAtIndex:(NSUInteger)index {
    return [self.formSections objectAtIndex:index];
}

- (NSArray *)formSectionsAtIndexes:(NSIndexSet *)indexes {
    return [self.formSections objectsAtIndexes:indexes];
}

- (void)insertObject:(GTCFormSectionDescriptor *)formSection inFormSectionsAtIndex:(NSUInteger)index {
    [self.formSections insertObject:formSection atIndex:index];
}

- (void)removeObjectFromFormSectionsAtIndex:(NSUInteger)index {
    [self.formSections removeObjectAtIndex:index];
}

#pragma mark - allSections KVO

-(NSUInteger)countOfAllSections
{
    return self.allSections.count;
}

- (id)objectInAllSectionsAtIndex:(NSUInteger)index {
    return [self.allSections objectAtIndex:index];
}

- (NSArray *)allSectionsAtIndexes:(NSIndexSet *)indexes {
    return [self.allSections objectsAtIndexes:indexes];
}

- (void)removeObjectFromAllSectionsAtIndex:(NSUInteger)index {
    GTCFormSectionDescriptor* section = [self.allSections objectAtIndex:index];
    [section.allRows enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL *stop) {
        GTCFormRowDescriptor * row = (id)obj;
        [self removeObserversOfObject:row predicateType:GTCPredicateTypeDisabled];
        [self removeObserversOfObject:row predicateType:GTCPredicateTypeHidden];
    }];
    [self removeObserversOfObject:section predicateType:GTCPredicateTypeHidden];
    [self.allSections removeObjectAtIndex:index];
}

- (void)insertObject:(GTCFormSectionDescriptor *)section inAllSectionsAtIndex:(NSUInteger)index {
    section.formDescriptor = self;
    [self.allSections insertObject:section atIndex:index];
    section.hidden = section.hidden;
    [section.allRows enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL * __unused stop) {
        GTCFormRowDescriptor * row = (id)obj;
        [self addRowToTagCollection:obj];
        row.hidden = row.hidden;
        row.disabled = row.disabled;
    }];


}

#pragma mark - EvaluateForm

-(void)forceEvaluate
{
    for (GTCFormSectionDescriptor* section in self.allSections){
        for (GTCFormRowDescriptor* row in section.allRows) {
            [self addRowToTagCollection:row];
        }
    }
    for (GTCFormSectionDescriptor* section in self.allSections){
        for (GTCFormRowDescriptor* row in section.allRows) {
            [row evaluateIsDisabled];
            [row evaluateIsHidden];
        }
        [section evaluateIsHidden];
    }
}

#pragma mark - private


-(NSMutableArray *)formSections
{
    return _formSections;
}

#pragma mark - Helpers

-(GTCFormRowDescriptor *)nextRowDescriptorForRow:(GTCFormRowDescriptor *)row
{
    NSUInteger indexOfRow = [row.sectionDescriptor.formRows indexOfObject:row];
    if (indexOfRow != NSNotFound){
        if (indexOfRow + 1 < row.sectionDescriptor.formRows.count){
            return [row.sectionDescriptor.formRows objectAtIndex:++indexOfRow];
        }
        else{
            NSUInteger sectionIndex = [self.formSections indexOfObject:row.sectionDescriptor];
            NSUInteger numberOfSections = [self.formSections count];
            if (sectionIndex != NSNotFound && sectionIndex < numberOfSections - 1){
                sectionIndex++;
                GTCFormSectionDescriptor * sectionDescriptor;
                while ([[(sectionDescriptor = [row.sectionDescriptor.formDescriptor.formSections objectAtIndex:sectionIndex]) formRows] count] == 0 && sectionIndex < numberOfSections - 1){
                    sectionIndex++;
                }
                return [sectionDescriptor.formRows firstObject];
            }
        }
    }
    return nil;
}


-(GTCFormRowDescriptor *)previousRowDescriptorForRow:(GTCFormRowDescriptor *)row
{
    NSUInteger indexOfRow = [row.sectionDescriptor.formRows indexOfObject:row];
    if (indexOfRow != NSNotFound){
        if (indexOfRow > 0 ){
            return [row.sectionDescriptor.formRows objectAtIndex:--indexOfRow];
        }
        else{
            NSUInteger sectionIndex = [self.formSections indexOfObject:row.sectionDescriptor];
            if (sectionIndex != NSNotFound && sectionIndex > 0){
                sectionIndex--;
                GTCFormSectionDescriptor * sectionDescriptor;
                while ([[(sectionDescriptor = [row.sectionDescriptor.formDescriptor.formSections objectAtIndex:sectionIndex]) formRows] count] == 0 && sectionIndex > 0 ){
                    sectionIndex--;
                }
                return [sectionDescriptor.formRows lastObject];
            }
        }
    }
    return nil;
}

-(void)addRowToTagCollection:(GTCFormRowDescriptor*) rowDescriptor
{
    if (rowDescriptor.tag) {
        self.allRowsByTag[rowDescriptor.tag] = rowDescriptor;
    }
}

-(void)removeRowFromTagCollection:(GTCFormRowDescriptor *)rowDescriptor
{
    if (rowDescriptor.tag){
        [self.allRowsByTag removeObjectForKey:rowDescriptor.tag];
    }
}


-(void)addObserversOfObject:(id)sectionOrRow predicateType:(GTCPredicateType)predicateType
{
    NSPredicate* predicate;
    id descriptor;
    switch(predicateType){
        case GTCPredicateTypeHidden:
            if ([sectionOrRow isKindOfClass:([GTCFormRowDescriptor class])]) {
                descriptor = ((GTCFormRowDescriptor*)sectionOrRow).tag;
                predicate = ((GTCFormRowDescriptor*)sectionOrRow).hidden;
            }
            else if ([sectionOrRow isKindOfClass:([GTCFormSectionDescriptor class])]) {
                descriptor = sectionOrRow;
                predicate = ((GTCFormSectionDescriptor*)sectionOrRow).hidden;
            }
            break;
        case GTCPredicateTypeDisabled:
            if ([sectionOrRow isKindOfClass:([GTCFormRowDescriptor class])]) {
                descriptor = ((GTCFormRowDescriptor*)sectionOrRow).tag;
                predicate = ((GTCFormRowDescriptor*)sectionOrRow).disabled;
            }
            else return;

            break;
    }
    NSMutableArray* tags = [predicate getPredicateVars];
    for (NSString* tag in tags) {
        NSString* auxTag = [tag formKeyForPredicateType:predicateType];
        if (!self.rowObservers[auxTag]){
            self.rowObservers[auxTag] = [NSMutableArray array];
        }
        if (![self.rowObservers[auxTag] containsObject:descriptor])
            [self.rowObservers[auxTag] addObject:descriptor];
    }

}

-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(GTCPredicateType)predicateType
{
    NSPredicate* predicate;
    id descriptor;
    switch(predicateType){
        case GTCPredicateTypeHidden:
            if ([sectionOrRow isKindOfClass:([GTCFormRowDescriptor class])]) {
                descriptor = ((GTCFormRowDescriptor*)sectionOrRow).tag;
                predicate = ((GTCFormRowDescriptor*)sectionOrRow).hidden;
            }
            else if ([sectionOrRow isKindOfClass:([GTCFormSectionDescriptor class])]) {
                descriptor = sectionOrRow;
                predicate = ((GTCFormSectionDescriptor*)sectionOrRow).hidden;
            }
            break;
        case GTCPredicateTypeDisabled:
            if ([sectionOrRow isKindOfClass:([GTCFormRowDescriptor class])]) {
                descriptor = ((GTCFormRowDescriptor*)sectionOrRow).tag;
                predicate = ((GTCFormRowDescriptor*)sectionOrRow).disabled;
            }
            break;
    }
    if (descriptor && [predicate isKindOfClass:[NSPredicate class] ]) {
        NSMutableArray* tags = [predicate getPredicateVars];
        for (NSString* tag in tags) {
            NSString* auxTag = [tag formKeyForPredicateType:predicateType];
            if (self.rowObservers[auxTag]){
                [self.rowObservers[auxTag] removeObject:descriptor];
            }
        }
    }
}

@end

