//
//  UUDataStorage.h
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUDataStorage : NSObject

+ (NSString *)documentPath;

+ (BOOL)createFileDirectoryNonexistent:(NSString *)filePath;

+ (void)archiverObject:(id)object forKey:(NSString *)key atPath:(NSString *)filePath;

+ (id)unarchiverObjectForKey:(NSString *)key atPath:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
