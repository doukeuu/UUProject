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

/// 删除json串中的转义符
- (NSString *)removeUnescapedCharacter;

/// 正则表达式去除字符串中部分HTML符号
- (NSString *)removeParagraphMarks;

/// 是否是纯数字
- (BOOL)isPureDigital;

@end

NS_ASSUME_NONNULL_END
