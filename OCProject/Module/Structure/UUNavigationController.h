//
//  UUNavigationController.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UUNavigationStyle) { // 导航栏样式枚举
    
    UUNavigationStyleNormal = 1, // 基础样式
    UUNavigationStyleTranslucent // 透明样式
};

@interface UUNavigationController : UINavigationController

@property (nonatomic, assign) UUNavigationStyle style;    // 导航栏样式
@property (nonatomic, strong) UIView *gradientView;         // 导航栏渐变背景视图
@property (nonatomic, copy) void(^dismissCompletion)(void); // dismiss后回调
@end

NS_ASSUME_NONNULL_END
