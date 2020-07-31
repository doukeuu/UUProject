//
//  UUToolsNS.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUToolsNS : NSObject

/// 判断对象是否为空、NULL、nil
+ (BOOL)isBlank:(id)obj;

/// 生成UUID
+ (NSString *)generateUUID;

/// 取出最大值
+ (NSString *)validateMaxNumberWithArray:(NSArray *)array;
/// 取出最小值
+ (NSString *)validateMinNumberWithArray:(NSArray *)array;

/// 将手机号、身份证号中间的数字用星号代替
+ (NSString *)replacedWithAsterisk:(NSString *)number;
/// 根据身份证号计算年龄
+ (NSString *)personAgeWithIDCard:(NSString *)number;
/// 身份证校验
+ (BOOL)validateIDCardNumber:(NSString *)value;

/// 手机号验证
+ (BOOL)validatePhoneNumber:(NSString *)value;
/// 固定电话验证
+ (BOOL)validateLandlineTelephoneNumber:(NSString *)number;
/// 验证并格式化固定电话号码（如 0108887777 格式化为 010-8887777），返回值可为nil
+ (NSString *)landlineTelephoneNumberFormated:(NSString *)number;
/// 验证邮箱号
+ (BOOL)validateEmail:(NSString *)email;


/// 执行某个对象的方法，可以消除原生perform方法的警告
+ (id)performObject:(id)object withSelector:(NSString *)selString;
/// 执行某个对象的方法，无返回值，可以消除原生perform方法的警告
+ (void)executeObject:(id)object withSelector:(NSString *)selString;
/// 执行某个对象的方法(第一个Object)，无返回值，可以消除原生perform方法的警告
+ (void)executeObject:(id)object selector:(NSString *)selString object:(id)first;
/// 执行某个对象的方法，无返回值，可以消除原生perform方法的警告
+ (void)executeObject:(id)object selector:(NSString *)selString object:(id)first object:(id)second;
@end


inline static NSString *getStringValue(id obj) {
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", [obj description]];
    } else {
        return @"";
    }
}


NS_ASSUME_NONNULL_END
