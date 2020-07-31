//
//  SSNavigationController.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSNavigationController : UINavigationController

/// 侧滑手势响应开关，最好在viewDidAppear/viewDidDisappear中使用
@property (nonatomic, assign) BOOL popGestureEnabled;
/// 模糊视图
@property (nonatomic, strong) UIVisualEffectView *effectView;
/// 分割线视图
@property (nonatomic, strong) UIView *navigatorLine;
@end

NS_ASSUME_NONNULL_END
