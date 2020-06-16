//
//  UUNavigationController.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNavigationController.h"

@interface UUNavigationController ()

@end

@implementation UUNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 防止导航栏设置为透明时，跳转过程中右边有黑底
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isBeingDismissed) {
        !self.dismissCompletion ?: self.dismissCompletion(); }
}

// 导航栏样式setter方法
- (void)setStyle:(UUNavigationStyle)style {
    if (_style == style) return;
    _style = style;
    
    switch (_style) {
        case UUNavigationStyleNormal:      [self normalStyle];
            break;
        case UUNavigationStyleTranslucent: [self translucentStyle];
            break;
    }
}

- (UIView *)gradientView {
    
    if (_gradientView) return _gradientView;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATOR_H);
    _gradientView = [[UIView alloc] initWithFrame:frame];
    _gradientView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            [view addSubview:_gradientView];
            break;
        }
    }
    return _gradientView;
}

#pragma mark - Style

// 普通导航栏样式
- (void)normalStyle {
    UINavigationBar *bar = self.navigationBar;
    
    // 是否透明
    bar.translucent = NO;
    // 标题字样式
    bar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName:[UIColor blackColor]};
    // 返回按钮文字移出屏幕
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
    
    // 返回按钮样式
    bar.backIndicatorImage = [[UIImage imageNamed:@"returnArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"returnArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置背景图片
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_TabBar"] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage imageNamed:@"nav_line"]];
}

// 注册登录导航栏样式
- (void)translucentStyle {
    UINavigationBar *bar = self.navigationBar;
    
    // 是否透明
    bar.translucent = YES;
    // 标题字样式
    bar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName:[UIColor blackColor]};
    // 返回按钮文字移出屏幕
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
    
    // 返回按钮样式
    bar.backIndicatorImage = [[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 背景设置为透明图片
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_translucent"] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
}

// 设置navigationBar样式
- (void)generateBarStyle {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    NSDictionary *attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:18],
                                 NSShadowAttributeName:shadow,
                                 NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationBar setTitleTextAttributes:attributes];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
