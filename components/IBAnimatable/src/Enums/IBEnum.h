//
//  IBEnum.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/31.
//

#import <Foundation/Foundation.h>

/**
 A protocol provides extension method for converting `String` into `enum`.
 Because `@IBInspectable` property can not support `enum` directly. To provide both `enum` API in code and `@IBInspectable` supported type `String` in Interface Builder, we use `IBEnum` to bridge Swift `enum` and `String`
 */
@protocol IBEnum

- (void)initWithString(NSString *string);

@end

@protocol IBEnum (optional string)

- (void)initWithString(NSString *string);

@end

@protocol IBEnum ()

- (NSString *name, NSArray<NSString *> *params)extractNameAndParamsFrom(NSString *string)

@end
