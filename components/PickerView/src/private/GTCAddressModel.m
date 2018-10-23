//
//  GTCAddressModel.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCAddressModel.h"

@implementation GTCAddressModel

- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary) {
            self.name = dictionary[@"name"];
            self.zipcode = dictionary[@"zipcode"];
        }
    }
    return self;
}

@end

@implementation CityModel

- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary) {
            self.name = dictionary[@"name"];
            self.zipcode = dictionary[@"zipcode"];
        }
    }
    return self;
}

@end

@implementation DistrictModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary) {
            self.name = dictionary[@"name"];
            self.zipcode = dictionary[@"zipcode"];
        }
    }
    return self;
}
@end
