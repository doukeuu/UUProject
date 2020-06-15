//
//  UUDataCache.m
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDataCache.h"

static NSTimeInterval cacheTime =  (double)604800;

@implementation UUDataCache

+ (NSString *)cacheDefaultPath {
    return [self cachePathWithComponent:@"UUDataCache_Default"];
}

+ (NSString *)cachePathWithComponent:(NSString *)subpath {
    return [[self cachePath] stringByAppendingPathComponent:subpath];
}

+ (NSString *)cachePath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (void)resetCache {
    [[NSFileManager defaultManager] removeItemAtPath:[UUDataCache cacheDefaultPath] error:nil];
}

+ (NSData *)objectForKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDefaultPath stringByAppendingPathComponent:key];
    if ([fileManager fileExistsAtPath:filename]) {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            return data;
        }
    }
    return nil;
}

+ (id)objectForFilePath:(NSString *)filePath forName:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [filePath stringByAppendingPathComponent:name];
    if ([fileManager fileExistsAtPath:filename]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filename];
        return dic;
    }
    return nil;
}

+ (NSArray *)arrayForFilePath:(NSString *)filePath forName:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [filePath stringByAppendingPathComponent:name];
    if ([fileManager fileExistsAtPath:filename]) {
        NSArray *arr = [NSArray arrayWithContentsOfFile:filename];
        return arr;
    }
    return nil;
}

+ (void)setObject:(NSData *)data forKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDefaultPath stringByAppendingPathComponent:key];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDefaultPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDefaultPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSError *error;
    @try {
        [data writeToFile:filename options:NSDataWritingAtomic error:&error];
    } @catch (NSException *e) {
        //TODO: error handling maybe
    }
}

+ (void)setObject:(id)object forFilePath:(NSString *)filePath forName:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [filePath stringByAppendingPathComponent:name];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    @try {
        [object writeToFile:filename atomically:YES];
    } @catch (NSException *e) {
        //TODO: error handling maybe
    }
}

+ (void)removeObjectFromFilePath:(NSString *)filePath forFileName:(NSString *)fileName {
    NSString *name = [filePath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:name error:nil];
}

@end
