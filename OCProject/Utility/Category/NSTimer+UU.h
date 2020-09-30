//
//  NSTimer+UU.h
//  OCProject
//
//  Created by Pan on 2020/9/18.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (UU)

/// 计时操作，在iOS10之前，防止循环引用导致不释放的问题
+ (NSTimer *)timerExtensionInterval:(NSTimeInterval)interval repaat:(BOOL)repeat action:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
