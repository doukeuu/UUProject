//
//  UUToolsNS.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUToolsNS.h"

@implementation UUToolsNS

// 判断对象是否为空、NULL、nil
+ (BOOL)isBlank:(id)obj {
    if(obj == [NSNull null] || obj == nil) return YES;
    if([obj isKindOfClass:[NSArray class]])
        return [obj count] == 0;
    if([obj isKindOfClass:[NSDictionary class]])
        return [obj count] == 0;
    if([obj isKindOfClass:[NSData class]])
        return [obj length] == 0;
    if([obj isKindOfClass:[NSString class]])
        return [obj length] == 0;
    return NO;
}

// 生成UUID
+ (NSString *)generateUUID {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault, UUID);
    NSString *result = [[NSString alloc] initWithString:(__bridge NSString *)UUIDString];
    CFRelease(UUID);
    CFRelease(UUIDString);
    return result;
}

// 将手机号、身份证号中间的数字用星号代替
+ (NSString *)replacedWithAsterisk:(NSString *)number {
    NSRange range;
    NSUInteger length = number.length;
    if (length < 3) {
        return number;
    }
    if (length == 11) {
        range = NSMakeRange(3, 4);
        return [number stringByReplacingCharactersInRange:range withString:@"****"];
    }
    if (length == 15) {
        range = NSMakeRange(6, 6);
        return [number stringByReplacingCharactersInRange:range withString:@"******"];
    }
    if (length == 18) {
        range = NSMakeRange(6, 8);
        return [number stringByReplacingCharactersInRange:range withString:@"********"];
    }
    if (length % 3 == 0) {
        range = NSMakeRange(length / 3, length / 3);
    } else {
        range = NSMakeRange(length / 3, length / 3 + 1);
    }
    NSMutableString *asteriskString = [NSMutableString stringWithCapacity:range.length];
    for (NSUInteger i = 0; i < range.length; i ++) {
        [asteriskString appendString:@"*"];
    }
    return [number stringByReplacingCharactersInRange:range withString:asteriskString];
}

// 根据身份证号计算年龄
+ (NSString *)personAgeWithIDCard:(NSString *)number {
    NSInteger length = number.length;
    if (length != 15 && length != 18) return @"";
    
    NSRange range = NSMakeRange(6, length == 15 ? 2 : 4);
    int borthYear = [number substringWithRange:range].intValue;
    if (borthYear == 0) return @"";
    
    NSString *string =[NSString stringWithFormat:@"%@", [NSDate date]];
    int currentYear = [[string substringToIndex:4] intValue];
    int age = currentYear - borthYear - (length == 15 ? 1900 : 0);
    if (age == 0) return @"1";
    return [NSString stringWithFormat:@"%d", age];
}

// 身份证校验，15或18位身份证
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (value.length != 15 && value.length != 18) {
        return NO;
    }
    // 前两位汇总
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",
                           @"21", @"22",@"23",
                           @"31",@"32", @"33",@"34", @"35",@"36", @"37",
                           @"41", @"42",@"43", @"44",@"45", @"46",
                           @"50", @"51",@"52", @"53",@"54",
                           @"61",@"62", @"63",@"64", @"65",
                           @"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    if (![areasArray containsObject:valueStart2]) {
        return NO;
    }
    int year;
    if (value.length == 15) {
        year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900; // 2000年之后就都是18位
    } else {
        year = [value substringWithRange:NSMakeRange(6,4)].intValue;
    }
    NSString *dateExpress; // 平年与闰年的正则表达式
    if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) {
        dateExpress = @"((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))";
    } else {
        dateExpress = @"((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))";
    }
    NSString *expression;
    if (value.length == 15) {
        expression = [NSString stringWithFormat:@"^\\d{6}[4-9]\\d%@\\d{3}$", dateExpress];
    } else {
        expression = [NSString stringWithFormat:@"^\\d{6}(19[4-9]\\d|20\\d{2})%@\\d{3}[0-9Xx]$", dateExpress];
    }
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
    
    if (value.length == 15) { // 15位身份证
        return numberofMatch > 0;
    }
    // 最后一位校验，18位身份证最后一位是根据前17位计算出来的校验位
    if (numberofMatch > 0) {
        int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7 +
        ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9 +
        ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10 +
        ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5 +
        ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8 +
        ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4 +
        ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2 +
        [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 +
        [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
        
        int Y = S % 11;
        NSString *JYM = @"10X98765432";
        NSString *M = [JYM substringWithRange:NSMakeRange(Y, 1)]; // 校验位
        NSString *last = [value substringWithRange:NSMakeRange(17, 1)]; // ID最后一位
        NSComparisonResult result = [M compare:last options:NSCaseInsensitiveSearch]; // 检测ID的校验位
        return result == NSOrderedSame;
    } else {
        return NO;
    }
}

#pragma mark - 验证手机号，或固话号及其格式化

// 验证手机号
+ (BOOL)validatePhoneNumber:(NSString *)value {
    /*
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700,181
     */
    if (value.length != 11) {
        return NO;
    }
    NSString * MOBILE = @"^1((3\\d|5[0-35-9]|8[025-9])\\d|70[059])\\d{7}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    NSString * CT = @"^1((33|53|8[019])\\d|349|700)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:value] == YES) ||
        ([regextestcm evaluateWithObject:value] == YES) ||
        ([regextestcu evaluateWithObject:value] == YES) ||
        ([regextestct evaluateWithObject:value] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

// 验证固定电话
+ (BOOL)validateLandlineTelephoneNumber:(NSString *)number {
    NSString *regex = [NSString stringWithFormat:@"^(%@)|(%@)\\d{7,8}$", [self areaCodeThreeDigitRegex], [self areaCodeFourDigitRegex]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:number];
}

// 格式化固定电话
+ (NSString *)landlineTelephoneNumberFormated:(NSString *)number {
    // 先验证是否符合标准各式，是则直接返回
    NSString *regex = [NSString stringWithFormat:@"^(%@)[-]\\d{7,8}|(%@)[-]\\d{7,8}$", [self areaCodeThreeDigitRegex], [self areaCodeFourDigitRegex]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([predicate evaluateWithObject:number]){
        return number;
    }
    // 获取纯粹的电话号码数字
    NSMutableString *value = [NSMutableString stringWithString:[number stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, number.length)]];
    
    // 格式化号码 三位区号
    regex = [NSString stringWithFormat:@"^(%@)\\d{7,8}$", [self areaCodeThreeDigitRegex]];
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([predicate evaluateWithObject:value]){
        [value insertString:@"-" atIndex:3]; // 插入连字符 "-"
        return [value copy];
    }
    // 格式化号码 四位区号
    regex = [NSString stringWithFormat:@"^(%@)\\d{7,8}$", [self areaCodeFourDigitRegex]];
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:value]) {
        [value insertString:@"-" atIndex:4]; // 插入连字符 "-"
        return [value copy];
    }
    return nil; // 所有情况都不符合，返回nil
}

// 获取三位区号正则表达式
+ (NSString *)areaCodeThreeDigitRegex {
    return @"(010|02[0-57-9])|852|853";
}

// 获取四位区号正则表达式
+ (NSString *)areaCodeFourDigitRegex {
    // 03xx
    NSString *fourDigit03 = @"03([157]\\d|35|49|9[1-68])";
    // 04xx
    NSString *fourDigit04 = @"04([17]\\d|2[179]|[3,5][1-9]|4[08]|6[4789]|8[23])";
    // 05xx
    NSString *fourDigit05 = @"05([1357]\\d|2[37]|4[36]|6[1-6]|80|9[1-9])";
    // 06xx
    NSString *fourDigit06 = @"06(3[1-5]|6[0238]|9[12])";
    // 07xx
    NSString *fourDigit07 = @"07(01|[13579]\\d|2[248]|4[3-6]|6[023689])";
    // 08xx
    NSString *fourDigit08 = @"08(1[23678]|2[567]|[37]\\d|5[1-9]|8[3678]|9[1-8])";
    // 09xx
    NSString *fourDigit09 = @"09(0[123689]|[17][0-79]|[39]\\d|4[13]|5[1-5])";
    
    return [NSString stringWithFormat:@"(%@)|(%@)|(%@)|(%@)|(%@)|(%@)|(%@)", fourDigit03, fourDigit04, fourDigit05, fourDigit06, fourDigit07, fourDigit08, fourDigit09];
}

#pragma mark - 验证邮箱号

// 验证邮箱号
+ (BOOL)validateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Perform & Excute

// 执行某个对象的方法，有返回值，可以消除原生perform方法的警告
+ (id)performObject:(id)object withSelector:(NSString *)selString {
    if (!object || !selString) return nil;
    SEL sel = NSSelectorFromString(selString);
    if (![object respondsToSelector:sel]) return nil;
    IMP imp = [object methodForSelector:sel];
    id (* performMethod)(id, SEL) = (void *)imp; // 函数指针
    return performMethod(object, sel);
}

// 执行某个对象的方法，无返回值，可以消除原生perform方法的警告
+ (void)executeObject:(id)object withSelector:(NSString *)selString {
    if (!object || !selString) return;
    SEL sel = NSSelectorFromString(selString);
    if (![object respondsToSelector:sel]) return;
    IMP imp = [object methodForSelector:sel];
    void (* executeMethod)(id, SEL) = (void *)imp; // 函数指针
    executeMethod(object, sel);
}

// 执行某个对象的方法(第一个Object)，无返回值，可以消除原生perform方法的警告
+ (void)executeObject:(id)object selector:(NSString *)selString object:(id)first {
    if (!object || !selString) return;
    SEL sel = NSSelectorFromString(selString);
    if (![object respondsToSelector:sel]) return;
    IMP imp = [object methodForSelector:sel];
    void (* executeMethod)(id, SEL, id) = (void *)imp; // 函数指针
    executeMethod(object, sel, first);
}

// 执行某个对象的方法(第一个Object)，无返回值，可以消除原生perform方法的警告
+ (void)executeObject:(id)object selector:(NSString *)selString object:(id)first object:(id)second {
    if (!object || !selString) return;
    SEL sel = NSSelectorFromString(selString);
    if (![object respondsToSelector:sel]) return;
    IMP imp = [object methodForSelector:sel];
    void (* executeMethod)(id, SEL, id, id) = (void *)imp; // 函数指针
    executeMethod(object, sel, first, second);
}

@end
