//
//  NSString+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "NSString+UU.h"

@implementation NSString (UU)

// 删除json串中的转义符
- (NSString *)removeUnescapedCharacter {
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [self rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:self];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return [mutable copy];
    }
    return self;
}

// 正则表达式去除字符串中部分HTML符号
- (NSString *)removeParagraphMarks {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"</?[p|img|strong|a][^>]*>|&nbsp;" options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
}

// 是否是纯数字
- (BOOL)isPureDigital {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d*$"] evaluateWithObject:self];
}

@end
