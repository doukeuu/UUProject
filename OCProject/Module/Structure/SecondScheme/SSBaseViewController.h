//
//  SSBaseViewController.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSBaseViewController : UIViewController

/// 侧滑手势响应开关，最好在viewDidAppear/viewDidDisappear中使用
@property (nonatomic, assign) BOOL popGestureEnabled;
/// 模糊视图
@property (nonatomic, strong, readonly) UIVisualEffectView *effectView;
/// 分割线视图
@property (nonatomic, strong, readonly) UIView *navigatorLine;

/// 导航栏背景色
- (void)configNavigationBackColor:(UIColor * _Nullable)color;
/// 导航栏标题色
- (void)configNavigationTitleColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
