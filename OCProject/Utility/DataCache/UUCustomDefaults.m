//
//  UUCustomDefaults.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUCustomDefaults.h"

@implementation UUCustomDefaults

// NSUserDefaults单例
+ (NSUserDefaults *)customUserDefaults {
    static NSUserDefaults *customDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"CustomDefaults"];
    });
    return customDefaults;
}

// 存入对象
+ (void)setObject:(id)object forKey:(NSString *)aKey {
    if (!aKey || aKey.length == 0) return;
    [[UUCustomDefaults customUserDefaults] setObject:object forKey:aKey];
}

// 获取对象
+ (id)objectForKey:(NSString *)aKey {
    if (!aKey || aKey.length == 0) return nil;
    return [[UUCustomDefaults customUserDefaults] objectForKey:aKey];
}

// 存入归档后的对象
+ (void)setArchiverObject:(id)object forKey:(NSString *)aKey {
    
    if (!aKey || aKey.length == 0) return;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[UUCustomDefaults customUserDefaults] setObject:data forKey:aKey];
}

// 获取解档后的对象
+ (id)unarchiverObjectForKey:(NSString *)aKey {
    
    if (!aKey || aKey.length == 0) return nil;
    id object = [[UUCustomDefaults customUserDefaults] objectForKey:aKey];
    if ([object isKindOfClass:[NSData class]]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)object];
    }
    return object;
}

// 移除对象
+ (void)removeObjectForKey:(NSString *)aKey {
    if (!aKey || aKey.length == 0) return;
    [[UUCustomDefaults customUserDefaults] removeObjectForKey:aKey];
}

@end
