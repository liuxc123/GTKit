//
//  GTCFormOptionsObject.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTCFormRowDescriptor.h"

@interface GTCFormOptionsObject : NSObject <GTCFormOptionObject, NSCoding>

@property (nonatomic) NSString * formDisplaytext;
@property (nonatomic) id formValue;

+(GTCFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText;
+(GTCFormOptionsObject *)formOptionsOptionForValue:(id)value fromOptions:(NSArray *)options;
+(GTCFormOptionsObject *)formOptionsOptionForDisplayText:(NSString *)displayText fromOptions:(NSArray *)options;

@end
