//
//  UUEncryption.m
//  OCProject
//
//  Created by Pan on 2020/6/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUEncryption.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define kEncryptionKey @"somethingForKey"

@implementation UUEncryption

#pragma mark - MD5

+ (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString {
    return [signString isEqualToString:[self MD5:string]];
}

+ (NSString *)MD5:(NSString *)string {
    
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return [result uppercaseString];
}

#pragma mark - DES

// 字符串Base64加密，空字符串也加密
+ (NSString *)encryptionDESForString:(NSString *)parameter {
    if (!parameter) return parameter;
    return [UUEncryption encryptWithContent:parameter type:0 key:kEncryptionKey];
}

// 字符串Base64解密
+ (NSString *)decryptionDESForString:(NSString *)parameter {
    if (!parameter || parameter.length == 0) return parameter;
    return [UUEncryption encryptWithContent:parameter type:1 key:kEncryptionKey];
}

+ (NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey {
    
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return miChar ? [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding] : nil;
}

// 类型l（kCCDecrypt）解码，类型0为加密
static const char* encryptWithKeyAndType(const char *text, CCOperation encryptOperation, char *key) {
    
    NSString *textString= [[NSString alloc] initWithCString:text encoding:NSUTF8StringEncoding];
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt) { //传递过来的是decrypt 解码
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = (const void *)[decryptData bytes];
        
    } else { //encrypt
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    //NSString *initIv = @"12345678";
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    //    NSLog(@"ccStatus %d", ccStatus);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt) { //encryptOperation==1  解码
        //得到解密出来的data数据，改变为utf-8的字符串
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    } else { //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    free(dataOut);
    
    return [result UTF8String];
}

#pragma mark - AES

// 字符串AES加密，空字符串也加密
+ (NSString *)encryptionAESForString:(NSString *)parameter {
    if (!parameter) return parameter;
    return [self commonCryptorWithText:parameter operationType:kCCEncrypt];
}
// 字符串AES解密
+ (NSString *)decryptionAESForString:(NSString *)parameter {
    if (!parameter || parameter.length == 0) return parameter;
    return [self commonCryptorWithText:parameter operationType:kCCDecrypt];
}
// 加密方法
+ (NSString *)commonCryptorWithText:(NSString *)text operationType:(CCOperation)operation {
    
    const void *key = [@"youjuke00ekujuoy" UTF8String]; // 密钥
    
    const void *dataIn;
    size_t dataInLength;
    NSData *textData;
    
    if (operation == kCCEncrypt) { // 加密数据转data
        textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    } else { // 解密的base64数据转data
        textData = [[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    dataIn = textData.bytes;
    dataInLength = (size_t)textData.length;
    
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable;
    size_t dataOUtMoved;
    
    dataOutAvailable = (dataInLength + kCCKeySizeAES128);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset(dataOut, 00, dataOutAvailable); //将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    CCCryptorStatus status;
    status = CCCrypt( // CCCrypt函数
                     operation, // 加密/解密
                     kCCAlgorithmAES, // 根据哪个标准（des，3des，aes。。。。）
                     kCCOptionPKCS7Padding, // 偏移量
                     key, // 密钥
                     kCCKeySizeAES128, // 密钥大小
                     NULL, // 可选的初始矢量
                     dataIn, // 数据的存储单元
                     dataInLength, // 数据的大小
                     dataOut, // 返回的数据存储单元
                     dataOutAvailable, // 缓存大小
                     &dataOUtMoved // 若成功，返回加密/解密后的数据大小， 若缓存太小，返回缺失的大小
                     );
    
    NSData *data = [NSData dataWithBytes:dataOut length:dataOUtMoved];
    free(dataOut);
    
    NSString *result = nil;
    if (operation == kCCEncrypt) { // 加密后的数据转base64
        result = [data base64EncodedStringWithOptions:0];
    } else { // 解密后的数据
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return result;
}


@end
