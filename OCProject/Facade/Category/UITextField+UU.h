//
//  UITextField+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (UU)

/// 是否添加键盘上的隐藏键盘按钮
@property (nonatomic, assign) BOOL shouldInputAccessoryView;

/// 限定输入字符长度，一个中文字符相当于两个英文字符，适合少量字符输入
- (void)limitInputCharacterLength:(NSInteger)length;
/// 限定字符串长度，中英文都算一个字符，适合大量字符串输入
- (void)limitInputStringLength:(NSInteger)length;
@end

NS_ASSUME_NONNULL_END
