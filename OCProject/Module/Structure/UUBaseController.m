//
//  UUBaseController.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBaseController.h"
#import <UIImage+YYAdd.h>

@interface UUBaseController ()

@property (nonatomic, strong) UIView *lineView;             // 导航栏横线
@end

@implementation UUBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    _hideShadowImage = NO;
    _navigationTransparent = NO;
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11, *)) {
        self.goBackControllable = YES;
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@" -- %@", [self class]);
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    if (_hideShadowImage) {
        [self shadowImageViewFrom:self.navigationController.navigationBar].hidden = YES;
    }
    if (_navigationTransparent) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_translucent"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    
    self.lineView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    if (_hideShadowImage) { // 如果已隐藏，当离开界面时，则不再隐藏
        [self shadowImageViewFrom:self.navigationController.navigationBar].hidden = NO;
    }
    if (_navigationTransparent) { // 如果已透明，当离开界面时，则不再透明
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_TabBar"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_line"]];
    }
    
    self.lineView.hidden = NO;
}

#pragma mark - Property

// 返回功能可控
- (void)setGoBackControllable:(BOOL)goBackControllable {
    
    if (_goBackControllable == goBackControllable) return;
    _goBackControllable = goBackControllable;
    
    if (goBackControllable) {
        UIButton *button = [self buttonForNavigationItemWithTitle:nil imageName:@"returnArrow"];
        CGRect frame = button.frame;
        frame.size.width = 44;
        button.frame = frame;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 34);
        [button addTarget:self action:@selector(controlledGoBack) forControlEvents:UIControlEventTouchUpInside];
        [self addLeftNavigationItemWithCustomView:button];
        
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

// 导航栏是否透明
- (void)setBarTransparent:(BOOL)barTransparent {
    
    _barTransparent = barTransparent;
    if (!barTransparent) return;
    UIImage *clearImage = [UIImage imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:clearImage
                                                  forBarMetrics:UIBarMetricsDefault];
    // 隐藏横线
    Class barBackgroundClass = NSClassFromString(@"_UIBarBackground");
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if (![view isKindOfClass:barBackgroundClass]) continue;
        for (UIView *subview in view.subviews) {
            if (subview.bounds.size.height > 1) continue;
            subview.hidden = YES;
            break;
        }
        break;
    }
}

// 导航栏横线
- (UIView *)lineView {
    
    if (_lineView) return _lineView;
    Class barBackgroundClass = NSClassFromString(@"_UIBarBackground");
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if (![view isKindOfClass:barBackgroundClass]) continue;
        for (UIView *subview in view.subviews) {
            if (subview.bounds.size.height > 1) continue;
            _lineView = subview;
            break;
        }
        break;
    }
    return _lineView;
}

#pragma mark - Public

// 属性goBackControllable为Yes时，重写此方法，实现返回可控，其实就是添加了左边的按钮
- (void)controlledGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

// 一个类似导航栏的背景视图
- (UIView *)navigateViewSeemedWithHeight:(CGFloat)height backColor:(UIColor *)color{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    view.backgroundColor = color;
    CGRect lineFrame = CGRectMake(0, height - 0.5, self.view.bounds.size.width, 0.5);
    UIView *lineView = [[UIView alloc] initWithFrame:lineFrame];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    return view;
}

// 导航栏上左右用到的自定义按钮，根据按钮title和image
- (UIButton *)buttonForNavigationItemWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 21, 44);
    
    if (imageName) {
        UIImage *image = [UIImage imageNamed:imageName];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:image forState:UIControlStateNormal];
    }
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [button sizeToFit];
    }
    return button;
}

// 添加左边导航按钮
- (void)addLeftNavigationItemWithCustomView:(UIView *)view{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -8;
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
}

// 添加右边导航按钮
- (void)addRightNavigationItemWithCustomView:(UIView *)view {
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -8;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
}


#pragma mark - Utility

// 查找导航栏上的阴影线所在的图片视图
- (UIImageView *)shadowImageViewFrom:(UIView *)view {
    
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1.0f) {
        return (UIImageView *)view;
    }
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self shadowImageViewFrom:subView];
        if (imageView) return imageView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@" == %@", [self class]);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.lineView.hidden = scrollView.contentOffset.y <= -NAVIGATOR_H; //  向上滚动就显示
}

@end
