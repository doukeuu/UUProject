//
//  NSString+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "NSString+UU.h"

@implementation NSString (UU)

// 设置格式日期
+ (NSString *)dateFormatedStringWithTimeString:(NSString *)timeString  {
    NSTimeInterval timeInterval = [timeString longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC-8"]];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

// 删除json串中的转义符
+ (NSString *)removeUnescapedCharacter:(NSString *)inputStr {
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputStr;
}

// 正则表达式去除字符串中HTMl段落符号
+ (NSString *)removeParagraphMarks:(NSString *)str {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"</?[p|P][^>]*>" options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
}

// 验证是否是纯数字
+ (BOOL)validatePureDigital:(NSString *)value {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d*$"] evaluateWithObject:value];
}

@end
