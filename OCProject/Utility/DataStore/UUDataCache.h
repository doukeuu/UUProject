//
//  UUDataCache.h
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUDataCache : NSObject

+ (NSString *)cacheDefaultPath;
+ (NSString *)cachePathWithComponent:(NSString *)subpath;
+ (NSString *)cachePath;

+ (void)resetCache;
+ (NSData *)objectForKey:(NSString *)key;
+ (id)objectForFilePath:(NSString *)filePath forName:(NSString *)name;
+ (NSArray *)arrayForFilePath:(NSString *)filePath forName:(NSString *)name;
+ (void)setObject:(NSData *)data forKey:(NSString *)key;
+ (void)setObject:(id)object forFilePath:(NSString *)filePath forName:(NSString *)name;
+ (void)removeObjectFromFilePath:(NSString *)filePath forFileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
