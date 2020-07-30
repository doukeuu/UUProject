//
//  UIBarButtonItem+UU.m
//  OCProject
//
//  Created by Pan on 2020/7/29.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UIBarButtonItem+UU.h"

@implementation UIBarButtonItem (UU)

// 返回按钮样式
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image action:(SEL)action target:(id)target {
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.frame = CGRectMake(0, 0, 44, 44);
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [itemBtn setImage:image forState:UIControlStateNormal];
    [itemBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
}

@end
