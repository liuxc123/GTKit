//
//  GTCFormTool.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTCFormTool.h"

#define GTCUserDefault [NSUserDefaults standardUserDefaults]

@implementation GTCFormTool

+ (id)objectForKey:(NSString *)key {
    return [GTCUserDefault objectForKey:key];
}

+ (void)setObject:(id)value forKey:(NSString *)key {
    [GTCUserDefault setObject:value forKey:key];
    [GTCUserDefault synchronize];
}

+ (BOOL)boolForKey:(NSString *)key {
    return [GTCUserDefault boolForKey:key];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    [GTCUserDefault setBool:value forKey:key];
    [GTCUserDefault synchronize];
}

@end
