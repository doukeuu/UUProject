//
//  UITextView+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (UU)

@property (nonatomic, strong, readonly) UILabel *placeholderLabel; // 占位符标签
@property (nonatomic, assign) NSInteger limitCount; // 限制的字数
@end

NS_ASSUME_NONNULL_END
