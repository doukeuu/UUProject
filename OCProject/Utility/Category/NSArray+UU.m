//
//  NSArray+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "NSArray+UU.h"

@implementation NSArray (UU)

// 修复终端打印汉字
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    [str appendString:@"]"];
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    return str;
}

// 取出最大值
+ (NSString *)validateMaxNumberWithArray:(NSArray *)array {
    if (!array || array.count == 0) return nil;
    __block float max = [[array firstObject] floatValue];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float tempFloat = [obj floatValue];
        if (tempFloat > max) {
            max = tempFloat;
        }
    }];
    return [NSString stringWithFormat:@"%lf", max];
}

// 取出最小值
+ (NSString *)validateMinNumberWithArray:(NSArray *)array {
    if (!array || array.count == 0) return nil;
    __block float min = [[array firstObject] floatValue];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float tempFloat = [obj floatValue];
        if (tempFloat < min) {
            min = tempFloat;
        }
    }];
    return [NSString stringWithFormat:@"%lf", min];
}

@end
