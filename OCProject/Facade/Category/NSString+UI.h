//
//  NSString+UI.h
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UI)

// 计算字符串特定宽度下的高度
- (CGSize)heightCalculatedInLimitedWidth:(CGFloat)width andFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
