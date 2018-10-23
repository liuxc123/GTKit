//
//  GTCFormDescriptorDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormDescriptor.h"

@class GTCFormSectionDescriptor;

typedef NS_ENUM(NSUInteger, GTCPredicateType) {
    GTCPredicateTypeDisabled = 0,
    GTCPredicateTypeHidden
};


@protocol GTCFormDescriptorDelegate <NSObject>

@required

-(void)formSectionHasBeenRemoved:(GTCFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)formSectionHasBeenAdded:(GTCFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)formRowHasBeenAdded:(GTCFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;
-(void)formRowHasBeenRemoved:(GTCFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;
-(void)formRowDescriptorValueHasChanged:(GTCFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;
-(void)formRowDescriptorPredicateHasChanged:(GTCFormRowDescriptor *)formRow
                                   oldValue:(id)oldValue
                                   newValue:(id)newValue
                              predicateType:(GTCPredicateType)predicateType;

@end
