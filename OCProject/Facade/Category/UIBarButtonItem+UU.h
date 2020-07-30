//
//  UIBarButtonItem+UU.h
//  OCProject
//
//  Created by Pan on 2020/7/29.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (UU)

/// 返回按钮样式
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image action:(SEL)action target:(id)target;
@end

NS_ASSUME_NONNULL_END
