//
//  GTCAddressModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import <Foundation/Foundation.h>

@class CityModel,DistrictModel,GDataXMLElement;

@interface GTCAddressModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSMutableArray<CityModel *> *list;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface CityModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSMutableArray<DistrictModel *> *list;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface DistrictModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *index;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
