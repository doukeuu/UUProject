//
//  UUProgressHUD.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUProgressHUD.h"
#import <MBProgressHUD.h>

@implementation UUProgressHUD

// 显示菊花提示视图
+ (void)showHUD {
    [self showHUDInView:[self currentView]];
}

// 在指定视图中显示菊花提示视图
+ (void)showHUDInView:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [UIColor colorWithWhite:0.4 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 25;
    [view addSubview:hud];
    [hud showAnimated:YES];
}

// 显示提示文字视图
+ (void)showText:(NSString *)text {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    [self showText:text inView:view during:2];
}

// 在指定视图中显示文字提示，一段时间后隐藏
+ (void)showText:(NSString *)text inView:(UIView *)view during:(NSTimeInterval)interval {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [UIColor colorWithWhite:0.4 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    [view addSubview:hud];
    [hud showAnimated:YES];
    [hud performSelector:@selector(hideAnimated:) withObject:@(YES) afterDelay:interval];
}

// 隐藏菊花提示视图
+ (void)hideHUD {
    [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
}

// 隐藏菊花提示视图
+ (void)hideHUDInView:(UIView *)view {
    if (!view) return;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

// 获取当前Controller的view
+ (UIView *)currentView {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController; // TabBarController
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController]; // NavigationController
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController]; // current controller (不论是push还是present，都能找到)
    }
    return vc.view;
}

@end
