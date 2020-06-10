//
//  NSArray+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (UU)

/// 取出最大值
+ (NSString *)validateMaxNumberWithArray:(NSArray *)array;
/// 取出最小值
+ (NSString *)validateMinNumberWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
