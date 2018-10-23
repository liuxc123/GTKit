//
//  NSObject+GTCFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "NSObject+GTCFormAdditions.h"

#import "../Descriptors/GTCFormRowDescriptor.h"

@implementation NSObject (GTCFormAdditions)

-(NSString *)displayText
{
    if ([self conformsToProtocol:@protocol(GTCFormOptionObject)]){
        return [(id<GTCFormOptionObject>)self formDisplayText];
    }
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]]){
        return [self description];
    }
    return nil;
}

-(id)valueData
{
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSDate class]]){
        return self;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        NSMutableArray * result = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL __unused *stop) {
            [result addObject:[obj valueData]];
        }];
        return result;
    }
    if ([self conformsToProtocol:@protocol(GTCFormOptionObject)]){
        return [(id<GTCFormOptionObject>)self formValue];
    }
    return nil;
}

@end
