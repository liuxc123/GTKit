//
//  NSArray+GTCFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "NSArray+GTCFormAdditions.h"
#import "NSObject+GTCFormAdditions.h"

@implementation NSArray (GTCFormAdditions)

- (NSInteger)formIndexForItem:(id)item {
    for (id selectedValueItem in self) {
        if ([[selectedValueItem valueData] isEqual:[item valueData]]){
            return [self indexOfObject:selectedValueItem];
        }
    }
    return NSNotFound;
}

@end
