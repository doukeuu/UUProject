//
//  NSString+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UU)

/// 设置格式日期
+ (NSString *)dateFormatedStringWithTimeString:(NSString *)timeString;

/// 删除json串中的转义符
+ (NSString *)removeUnescapedCharacter:(NSString *)inputSt;

/// 正则表达式去除字符串中HTMl段落符号
+ (NSString *)removeParagraphMarks:(NSString *)str;

/// 验证是否是纯数字
+ (BOOL)validatePureDigital:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
