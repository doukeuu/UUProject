//
//  UUHTMLFilter.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUHTMLFilter : NSObject

/// 去除HTML语言标签
+ (NSString *)filterHTMLContentWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
