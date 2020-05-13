//
//  NSString+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "NSString+UU.h"

@implementation NSString (UU)

// 计算字符串高
- (CGSize)heightCalculatedInLimitedWidth:(CGFloat)width andFont:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

// 将手机号、身份证号中间的数字用星号代替
- (NSString *)replaceNumberWithAsterisk {
    NSRange range;
    NSUInteger length = self.length;
    
    if (length < 3) {
        return self;
    }
    if (length == 11) {
        range = NSMakeRange(3, 4);
        return [self stringByReplacingCharactersInRange:range withString:@"****"];
    }
    if (length == 15) {
        range = NSMakeRange(6, 6);
        return [self stringByReplacingCharactersInRange:range withString:@"******"];
    }
    if (length == 18) {
        range = NSMakeRange(6, 8);
        return [self stringByReplacingCharactersInRange:range withString:@"********"];
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
    return [self stringByReplacingCharactersInRange:range withString:asteriskString];
}

// 根据身份证号计算年龄
- (NSString *)personAgeForIDCardNumber {
    
    NSInteger length = self.length;
    if (length != 15 && length != 18) return @"";
    
    NSRange range = NSMakeRange(6, length == 15 ? 2 : 4);
    int borthYear = [self substringWithRange:range].intValue;
    if (borthYear == 0) return @"";
    
    NSString *string =[NSString stringWithFormat:@"%@", [NSDate date]];
    int currentYear = [[string substringToIndex:4] intValue];
    int age = currentYear - borthYear - (length == 15 ? 1900 : 0);
    if (age == 0) return @"1";
    
    return [NSString stringWithFormat:@"%d", age];
}

// 设置格式日期
+ (NSString *)dateFormatedStringWithTimeString:(NSString *)timeString  {
    NSTimeInterval timeInterval = [timeString longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC-8"]];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

@end
