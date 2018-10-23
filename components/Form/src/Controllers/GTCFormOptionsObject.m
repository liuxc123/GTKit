//
//  GTCFormOptionsObject.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormOptionsObject.h"

@implementation GTCFormOptionsObject

-(instancetype)initWithValue:(id)value displayText:(NSString *)displayText
{
    self = [super init];
    if (self){
        _formValue = value;
        _formDisplaytext = displayText;
    }
    return self;
}

+ (GTCFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText {
    return [[GTCFormOptionsObject alloc] initWithValue:value displayText:displayText];
}

+ (GTCFormOptionsObject *)formOptionsOptionForValue:(id)value fromOptions:(NSArray *)options {
    for (GTCFormOptionsObject * option in options) {
        if ([option.formValue isEqual:value]){
            return option;
        }
    }
    return nil;
}

+ (GTCFormOptionsObject *)formOptionsOptionForDisplayText:(NSString *)displayText fromOptions:(NSArray *)options {
    for (GTCFormOptionsObject * option in options) {
        if ([option.formDisplayText isEqualToString:displayText]){
            return option;
        }
    }
    return nil;
}

-(BOOL)isEqual:(id)object
{
    if (![[self class] isEqual:[object class]]){
        return NO;
    }
    return [self.formValue isEqual:((GTCFormOptionsObject *)object).formValue];
}


#pragma mark - GTFormOptionObject

-(NSString *)formDisplayText
{
    return _formDisplaytext;
}

-(id)formValue
{
    return _formValue;
}


#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)encoder
{

    [encoder encodeObject:self.formValue
                   forKey:@"formValue"];
    [encoder encodeObject:self.formDisplayText
                   forKey:@"formDisplayText"];
}

-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if ((self=[super init])) {

        [self setValue:[decoder decodeObjectForKey:@"formValue"]
                forKey:@"formValue"];
        [self setValue:[decoder decodeObjectForKey:@"formDisplayText"]
                forKey:@"formDisplaytext"];

    }

    return self;

}


@end
