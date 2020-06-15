//
//  UUDataStorage.m
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDataStorage.h"

@implementation UUDataStorage

+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (BOOL)createFileDirectoryNonexistent:(NSString *)filePath {
    
    if (filePath.length == 0) return NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![manager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        NSError *error = nil;
        BOOL result = [manager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) NSLog(@"%@", error);
        return result;
    }
    return YES;
}

+ (void)archiverObject:(id)object forKey:(NSString *)key atPath:(NSString *)filePath {
    
    if (!object) return;
    if (filePath.length == 0) return;
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (id)unarchiverObjectForKey:(NSString *)key atPath:(NSString *)filePath {
    
    if (filePath.length == 0) return nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return object;
}

@end
