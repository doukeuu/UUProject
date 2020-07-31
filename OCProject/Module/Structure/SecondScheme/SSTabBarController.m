//
//  SSTabBarController.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "SSTabBarController.h"
#import "SSNavigationController.h"

#import "UIImage+UU.h"

@interface SSTabBarController ()

@end

@implementation SSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.backgroundImage = [UIImage imageFromColor:[UIColor whiteColor]];
    self.tabBar.shadowImage = [UIImage imageFromColor:UIColor.lightGrayColor];
    
    [self childContorllerAddition];
}

// 添加子控制器
- (void)childContorllerAddition {
    NSArray *serviceInfo = @[@"SSServicePageController", @"服务", @"tab_service_n", @"tab_service_s"];
    [self generateChildControllerWithInfo:serviceInfo];
    NSArray *messageInfo = @[@"SSMessagePageController", @"消息", @"tab_message_n", @"tab_message_s"];
    [self generateChildControllerWithInfo:messageInfo];
    NSArray *mineInfo = @[@"SSMinePageController", @"我的", @"tab_mine_n", @"tab_mine_s"];
    [self generateChildControllerWithInfo:mineInfo];
}

// 生成子控制器
- (void)generateChildControllerWithInfo:(NSArray *)info {
    if (info.count < 4) return ;
    Class controllerClass = NSClassFromString(info[0]);
    UIViewController *controller = [[controllerClass alloc] init];
    UITabBarItem *item = [self generateTabBarItem:info[1] normal:info[2] selected:info[3]];
    SSNavigationController *navigation = [[SSNavigationController alloc] initWithRootViewController:controller];
    navigation.tabBarItem = item;
    [self addChildViewController:navigation];
}

// 生成tabBarItem
- (UITabBarItem *)generateTabBarItem:(NSString *)title normal:(NSString *)normal selected:(NSString *)selected {
    UIImage *normalImage = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    NSDictionary *normalAttributes = @{NSForegroundColorAttributeName: UIColor.lightGrayColor, NSFontAttributeName: FONT(13)};
    NSDictionary *selectedAttributes = @{NSForegroundColorAttributeName: UIColor.blueColor, NSFontAttributeName: FONT(13)};
    [item setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -1);
    return item;
}

@end
