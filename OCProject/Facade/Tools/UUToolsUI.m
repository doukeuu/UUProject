//
//  UUToolsUI.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUToolsUI.h"

@implementation UUToolsUI

// 查找当前界面控制器
+ (UIViewController *)topViewControllerFrom:(UIViewController *)controller {
    if (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerFrom:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}

// 简单获取当前Controller
+ (UIViewController *)currentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController; // TabBarController
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController]; // NavigationController
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController]; // current controller (不论是push还是present，都能找到)
    }
    return vc;
}

@end
