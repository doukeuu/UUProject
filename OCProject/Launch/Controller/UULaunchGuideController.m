//
//  UULaunchGuideController.m
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULaunchGuideController.h"
#import "UUDotPageControl.h"
#import "UIView+UU.h"
#import "UUDeviceCheck.h"

@interface UULaunchGuideController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;      // 滚动视图
@property (nonatomic, strong) UUDotPageControl *pageControl; // 分页控制符
@property (nonatomic, strong) UIButton *enterButton;         // 立即体验按钮
@property (nonatomic, strong) NSArray *imagePathArray;       // 图片名称数组
@end

@implementation UULaunchGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configureScrollView];
    [self configureScrollViewContentView];
    [self configurePageControl];
}

- (NSArray *)imagePathArray {
    
    if (_imagePathArray) return _imagePathArray;
    _imagePathArray = @[@"first_guide", @"second_guide", @"third_guide"];
    return _imagePathArray;
}

// 配置滚动视图
- (void)configureScrollView {
    
    CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.view.width * self.imagePathArray.count, self.view.height);
    [self.view addSubview:_scrollView];
}

// 配置滚动视图子视图
- (void)configureScrollViewContentView {
    
    CGFloat scale = self.view.frame.size.width / 320.0;
    NSInteger count = self.imagePathArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        CGRect frame = CGRectMake(_scrollView.width * i, 0, _scrollView.width, _scrollView.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[self.imagePathArray objectAtIndex:i]];
        [_scrollView addSubview:imageView];
        if (i == count - 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = UIColor.greenColor;
            CGFloat x = _scrollView.width * i + (_scrollView.width - 146.5 * scale) / 2.0;
            button.frame = CGRectMake(x, _scrollView.height - 49 * scale - 36.5 * scale, 146.5 * scale, 36.5 * scale);
            button.layer.cornerRadius = button.height / 2.f;
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickEnterButton) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }
    }
}

// 配置页面控制符
- (void)configurePageControl {
    
    CGFloat scale = self.view.frame.size.width / 320.0;
    CGFloat navigationHeight = 15 * scale;
    if ([[UUDeviceCheck deviceName] isEqualToString:@"iPhone X"]) {
        navigationHeight = 49 * scale;
    }
    CGRect frame = CGRectMake(0, self.view.height - navigationHeight - 10 * scale, self.view.width, 10 * scale);
    _pageControl = [[UUDotPageControl alloc] initWithFrame:frame];
    _pageControl.numberOfPages = self.imagePathArray.count;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.defaultImage = [UIImage imageNamed:@"empty_pot"];
    _pageControl.currentImage = [UIImage imageNamed:@"fill_pot"];
    _pageControl.pointSize = CGSizeMake(10 * scale, 10 * scale);
    [self.view addSubview:_pageControl];
}

// 点击立即体验按钮
- (void)clickEnterButton {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    [self removeFromSuperview];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.x / scrollView.width);
    _pageControl.currentPage = index;
}

@end
