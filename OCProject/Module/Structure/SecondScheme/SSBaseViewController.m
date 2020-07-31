//
//  SSBaseViewController.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "SSBaseViewController.h"
#import "SSNavigationController.h"

#import "UIImage+UU.h"

@interface SSBaseViewController ()

@end

@implementation SSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self commonConfiguration];
}

- (void)dealloc {
    NSLog(@" == %@", [self class]);
}

// 常规配置
- (void)commonConfiguration {
    // 返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"    "
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
}

// 导航栏背景色
- (void)configNavigationBackColor:(UIColor *)color {
    UINavigationBar *bar = self.navigationController.navigationBar;
    if (color != nil) {
        bar.shadowImage = [UIImage imageFromColor:color];
        self.effectView.contentView.backgroundColor = color;
    } else {
        bar.shadowImage = [UIImage imageFromColor:UIColor.lightGrayColor];
        self.effectView.contentView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
    }
}

// 导航栏标题色
- (void)configNavigationTitleColor:(UIColor *)color {
    UINavigationBar *bar = self.navigationController.navigationBar;
    if (color != nil) {
        bar.titleTextAttributes = @{NSForegroundColorAttributeName: color};
    } else {
        bar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor};
    }
}

#pragma mark - Getter & Setter

// 侧滑手势响应开关
- (void)setPopGestureEnabled:(BOOL)popGestureEnabled {
    _popGestureEnabled = popGestureEnabled;
    SSNavigationController *navigation = (SSNavigationController *)self.navigationController;
    navigation.popGestureEnabled = _popGestureEnabled;
}

// 模糊视图
- (UIVisualEffectView *)effectView {
    SSNavigationController *navigation = (SSNavigationController *)self.navigationController;
    return navigation.effectView;
}

// 分割线视图
- (UIView *)navigatorLine {
    SSNavigationController *navigation = (SSNavigationController *)self.navigationController;
    return navigation.navigatorLine;
}

@end
