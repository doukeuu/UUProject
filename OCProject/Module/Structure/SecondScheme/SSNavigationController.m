//
//  SSNavigationController.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "SSNavigationController.h"
#import "UIImage+UU.h"

@interface SSNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation SSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.popGestureEnabled = YES;
    [self configNavigationBar];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addVisualEffectViewToBar];
}

// 状态栏颜色设置的一部分
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - Subviews & Style

// 导航栏背景及字体样式
- (void)configNavigationBar {
    UIImage *backImage = [UIImage imageFromColor:[UIColor whiteColor]];
    [self.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageFromColor:UIColor.lightGrayColor];
    
    UIImage *indicatorImage = [[UIImage imageNamed:@"arrow_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    self.navigationBar.backIndicatorImage = indicatorImage;
    self.navigationBar.backIndicatorTransitionMaskImage = indicatorImage;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: FONT(17.0)};
    self.navigationBar.titleTextAttributes = attributes;
}

// 模糊视图
- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATOR_H);
    _effectView.contentView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
    return _effectView;
}

// 分割线视图
- (UIView *)navigatorLine {
    if (_navigatorLine) return _navigatorLine;
    _navigatorLine = [self lookupNavigatorLine];
    return _navigatorLine;
}

// 添加模糊视图
- (void)addVisualEffectViewToBar {
    if (self.effectView.superview != nil) return;
    UIView *backgroundView = [self lookupBarBackgroundView];
    [backgroundView addSubview:self.effectView];
}

// 查找Bar分割线
- (UIView *)lookupNavigatorLine {
    UIView *backgroundView = [self lookupBarBackgroundView];
    if (!backgroundView) return nil;
    for (UIView *subview in backgroundView.subviews) {
        if (subview.bounds.size.height > 1.0) continue;
        return subview;
    }
    return nil;
}

// 查找Barbackground视图
- (UIView *)lookupBarBackgroundView {
    Class backgroundClass = NSClassFromString(@"_UINavigationBarBackground");
    if (!backgroundClass) {
        backgroundClass = NSClassFromString(@"_UIBarBackground");
    }
    if (!backgroundClass) return nil;
    for (UIView *subview in self.navigationBar.subviews) {
        if ([subview isKindOfClass:backgroundClass]) {
            return subview;
        }
    }
    return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置返回按钮,只有非根控制器
//        UIBarButtonItem *item = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"arrow_back_black"]
//                                                            action:@selector(itemBack) target:self];
//        viewController.navigationItem.leftBarButtonItem = item;
    }
    [super pushViewController:viewController animated:animated];
}

// 点击返回按钮
//- (void)itemBack {
//    [self popViewControllerAnimated:YES];
//}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1 && self.popGestureEnabled;
}

@end
