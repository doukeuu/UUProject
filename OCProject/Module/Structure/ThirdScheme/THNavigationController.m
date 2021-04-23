//
//  THNavigationController.m
//  OCProject
//
//  Created by ssbm on 2021/4/23.
//  Copyright © 2021 xyz. All rights reserved.
//

#import "THNavigationController.h"
#import <UIImage+YYAdd.h>

@interface THNavigationController ()

@end

@implementation THNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBarBackImage];
}

// 配置导航栏背景
- (void)configNavigationBarBackImage {
    UIImage *navImage = [UIImage imageWithColor:UIColor.clearColor];
    [self.navigationBar setShadowImage:navImage];
    [self.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
}

@end
