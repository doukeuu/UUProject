//
//  UUEncryption.h
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUEncryption : NSObject

// 字符串MD5值
+ (NSString *)MD5:(NSString *)string;
+ (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;

// 字符串DES加密，空字符串也加密
+ (NSString *)encryptionDESForString:(NSString *)parameter;
// 字符串DES解密
+ (NSString *)decryptionDESForString:(NSString *)parameter;

/// 字符串AES加密，空字符串也加密
+ (NSString *)encryptionAESForString:(NSString *)parameter;
/// 字符串AES解密
+ (NSString *)decryptionAESForString:(NSString *)parameter;

@end

NS_ASSUME_NONNULL_END
