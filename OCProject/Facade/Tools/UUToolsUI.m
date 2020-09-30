//
//  UUToolsUI.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUToolsUI.h"

@implementation UUToolsUI

// 获取当前Controller
+ (UIViewController *)currentViewController {
    return [self topViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}

// 查找最上层Controller
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

@end
