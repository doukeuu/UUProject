//
//  NSString+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UU)

// 计算字符串特定宽度下的高度
- (CGSize)heightCalculatedInLimitedWidth:(CGFloat)width andFont:(UIFont *)font;

// 将手机号、身份证号中间的数字用星号代替
- (NSString *)replaceNumberWithAsterisk;

// 根据身份证号计算年龄
- (NSString *)personAgeForIDCardNumber;

/// 设置格式日期
+ (NSString *)dateFormatedStringWithTimeString:(NSString *)timeString;

@end

NS_ASSUME_NONNULL_END
