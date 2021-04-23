//
//  THBaseViewController.m
//  OCProject
//
//  Created by ssbm on 2021/4/23.
//  Copyright © 2021 xyz. All rights reserved.
//

#import "THBaseViewController.h"

@interface THBaseViewController ()

@end

@implementation THBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.navBackView.hidden = NO;
    self.navLineView.hidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.view bringSubviewToFront:self.navBackView];
}

// 导航栏位置背景图片视图
- (UIImageView *)navBackView {
    if (!_navBackView) {
        CGFloat statusH =  [UIApplication sharedApplication].statusBarFrame.size.height;
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, statusH + 44);
        _navBackView = [[UIImageView alloc] initWithFrame:rect];
        _navBackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_navBackView];
    }
    return _navBackView;
}

// 导航栏位置分割线图片视图
- (UIImageView *)navLineView {
    if (!_navLineView) {
        CGSize size = self.navBackView.frame.size;
        CGRect rect = CGRectMake(0, size.height - 1, size.width, 1);
        _navLineView = [[UIImageView alloc] initWithFrame:rect];
        _navLineView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self.navBackView addSubview:_navLineView];
    }
    return _navLineView;
}

@end
