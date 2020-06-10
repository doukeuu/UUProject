//
//  NSString+UI.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "NSString+UI.h"

@implementation NSString (UI)

// 计算字符串高
- (CGSize)heightCalculatedInLimitedWidth:(CGFloat)width andFont:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

@end
