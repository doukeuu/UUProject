//
//  UUCustomDefaults.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUCustomDefaults : NSObject

/// 存入对象
+ (void)setObject:(id)object forKey:(NSString *)aKey;
/// 获取对象
+ (id)objectForKey:(NSString *)aKey;
/// 存入归档后的对象
+ (void)setArchiverObject:(id)object forKey:(NSString *)aKey;
/// 获取解档后的对象
+ (id)unarchiverObjectForKey:(NSString *)aKey;
/// 移除对象
+ (void)removeObjectForKey:(NSString *)aKey;
@end

NS_ASSUME_NONNULL_END
