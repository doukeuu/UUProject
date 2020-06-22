//
//  UUImageCirculatingView.m
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUImageCirculatingView.h"

#define PageControlHeight 44*SCREEN_RATIO

@interface UUImageCirculatingView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;     // 图片视图
@property (nonatomic, strong) UIScrollView *scrollView;   // 滚动视图
@property (nonatomic, strong) UIPageControl *pageControl; // 分页控制器
@property (nonatomic, strong) UIImage *placeholderImage;  // 站位图片
@property (nonatomic, strong) NSTimer *timer;  // 计时器
@property (nonatomic, assign) NSInteger index; // 当前显示的图片在数组中的下标
@end

@implementation UUImageCirculatingView

/// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)placeholder {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.placeholderImage = placeholder;
        self.index = 0;
    }
    return self;
}

#pragma mark - Property Method

- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    if (imagesArray.count == 1) {
        self.imageView.image = [imagesArray firstObject];
    } else if (imagesArray.count > 1) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self configScrollViewContentWithImages:imagesArray];
        
        if (self.showsPageControl) {
            self.pageControl.numberOfPages = imagesArray.count;
        }
                
        if (self.autoScrollDelay > 0.5) {
            [self removeScrollTimer];
            [self configScrollTimer];
        }
    } else {
        if (self.placeholderImage) {
            self.imageView.image = self.placeholderImage;
        }
    }
}

- (void)setShowsPageControl:(BOOL)showsPageControl {
    _showsPageControl = showsPageControl;
    if (showsPageControl && self.imagesArray.count > 1) {
        self.pageControl.numberOfPages = self.imagesArray.count;
    }
}

- (void)setAutoScrollDelay:(NSTimeInterval)autoScrollDelay {
    _autoScrollDelay = autoScrollDelay;
    if (autoScrollDelay > 0.5 && self.imagesArray.count > 1) {
        [self removeScrollTimer];
        [self configScrollTimer];
    }
}

#pragma mark - Handle Timer

/// 设置定时器
- (void)configScrollTimer {
    if (self.autoScrollDelay < 0.5) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:self.autoScrollDelay target:self selector:@selector(timeToScrollImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/// 移除定时器
- (void)removeScrollTimer {
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Config Subview

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:self.scrollView];
    }
    return _scrollView;
}

///设置滚动视图中的内容
- (void)configScrollViewContentWithImages:(NSArray *)images {
    NSInteger number = images.count;
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*(number+2), self.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
    for (int i = 0; i < number + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        
        if (number > 0) {
            if (i == 0) {
                imageView.image = images[number -1];
            } else if (i == number + 1) {
                imageView.image = images[0];
            } else {
                imageView.image = images[i - 1];
            }
        }
        CGRect frame = CGRectMake(self.scrollView.bounds.size.width * i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        imageView.frame = frame;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:imageView];
    }
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 44*[UIScreen mainScreen].bounds.size.width/ 640.0f, self.bounds.size.width, 44*[UIScreen mainScreen].bounds.size.width/ 640.0f)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2]; //ColorByRGBA_255(0, 0, 0, 0.1f);
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

#pragma mark - Respond Method

/// 中间滚动视图点触响应方法
- (void)tapImageView:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(tapCirculatingImage:atIndex:)]) {
        [self.delegate tapCirculatingImage:imageView.image atIndex:self.index];
    }
}

/// 时间控制响应方法
- (void)timeToScrollImage {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.bounds.size.width, 0) animated:YES];
}

#pragma mark - Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat targetX = scrollView.contentOffset.x;
    CGFloat scrollWidth = scrollView.bounds.size.width;
    NSInteger pageNum = self.imagesArray.count;
    if (self.showsPageControl) {
        self.pageControl.currentPage = lround(targetX / scrollWidth) - 1;
    }
    self.index = lround(targetX / scrollWidth) - 1;
    
    // 无限循环
    if (targetX < 1) {
        [scrollView setContentOffset:CGPointMake(scrollWidth * pageNum, 0) animated:NO];
    } else if (targetX > scrollWidth * (pageNum + 1) - 1) {
        [scrollView setContentOffset:CGPointMake(scrollWidth, 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScrollDelay > 0.5) {
        [self configScrollTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScrollDelay > 0.5) {
        [self removeScrollTimer];
    }
}

@end
