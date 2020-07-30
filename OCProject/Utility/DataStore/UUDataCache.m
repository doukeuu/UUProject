//
//  UUDataCache.m
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDataCache.h"
#import "SDImageCache.h"
#import <WebKit/WebKit.h>

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


// 计算缓存
+ (NSString *)caculateCacheSize {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    float cacheSize = [self folderSizeAtPath:cachPath];  //计算目录大小
    return  [NSString stringWithFormat:@"%.2f",cacheSize];
}

+ (void)clearCacheBlock:(void(^)(void))block {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    [self clearCacheWithPath:cachPath];
    [self clearDisk];
    [self deleteWebCache];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        if (block) {
            block();
        }
    }];
}

//缓存计算
+ (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算目录
+ (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] totalDiskSize]/1024.0/1024.0;
        return folderSize;
    }
    return folderSize;
}

//清理缓存
+ (void)clearDisk {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    if ([fileManager fileExistsAtPath:cachePath]) {
        
        [fileManager removeItemAtPath:cachePath error:nil];
        [fileManager createDirectoryAtPath:cachePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        
    }
}

+(void)clearCacheWithPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            if ([fileManager isDeletableFileAtPath:absolutePath] && [fileManager fileExistsAtPath:absolutePath]) {
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
}

+ (void)deleteWebCache {
    if (@available(iOS 9.0, *)) {
        NSSet *cookieTypeSet = [WKWebsiteDataStore allWebsiteDataTypes];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:cookieTypeSet modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{

        }];
    }
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSFileManager *fileManager=[NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:cookiesFolderPath]) {
        NSError *errors = nil;
        [fileManager removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

@end
