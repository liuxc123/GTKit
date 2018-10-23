//
//  NSString+GTCFormAdditions.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormDescriptor.h"

@interface NSString (GTCFormAdditions)

- (NSPredicate *)formPredicate;

- (NSString *)formKeyForPredicateType:(GTCPredicateType)predicateType;

- (CGSize)gtc_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

@end
