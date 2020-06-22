//
//  UUImageAutoScrollView.m
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUImageAutoScrollView.h"
#import <UIImageView+WebCache.h>

#define IMAGE_VIEW_COUNT 5

@interface UUImageAutoScrollView () <UIScrollViewDelegate>
{
    CGFloat _scrollHeight;   // 滚动视图高度
    NSInteger _currentIndex; // 当前图片下标
}
@property (nonatomic, strong) UIScrollView *scrollView;   // 滚动视图
@property (nonatomic, strong) UIPageControl *pageControl; // 分页控制器

@property (nonatomic, strong) NSArray *imageViewArray;    // 图片视图数组
@property (nonatomic, strong) NSArray *backViewArray;     // 阴影视图数组
@property (nonatomic, strong) NSArray *imagesArray;       // 调整后图片地址数组
@property (nonatomic, strong) NSTimer *timer;             // 计时器

@property (nonatomic, assign) CGFloat scrollWidth;        // 滚动视图宽度
@end

@implementation UUImageAutoScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        _scrollHeight = frame.size.height;
        _currentIndex = 0;
        [self generateSubview];
        [self configAllSubview];
    }
    return self;
}

- (void)dealloc {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    NSLog(@"== %@", [self class]);
}

#pragma mark - Property

- (void)setMarginH:(CGFloat)marginH {
    if (_marginH == marginH) return;
    _marginH = marginH;
    if (_marginH < 0) return;
    [self configAllSubview];
}

- (void)setMarginV:(CGFloat)marginV {
    if (_marginV == marginV) return;
    _marginV = marginV;
    if (_marginV < 0) return;
    [self configAllSubview];
}

- (void)setImageCorner:(CGFloat)imageCorner {
    if (_imageCorner == imageCorner) return;
    _imageCorner = imageCorner;
    if (imageCorner < 0) return;
    [self configAllSubview];
}

- (void)setImageShadow:(BOOL)imageShadow {
    _imageShadow = imageShadow;
    if (_backViewArray.count != 0) {
        for (UIView *backView in _backViewArray) {
            backView.hidden = !_imageShadow;
        }
    } else {
        if (!_imageShadow) return;
        [self generateImageShadow];
        [self configAllSubview];
    }
}

- (void)setSideWidth:(CGFloat)sideWidth {
    if (_sideWidth == sideWidth) return;
    _sideWidth = sideWidth;
    if (_sideWidth < 0) return;
    [self configAllSubview];
}

- (void)setScrollDuration:(NSTimeInterval)scrollDuration {
    if (_scrollDuration == scrollDuration) return;
    _scrollDuration = scrollDuration;
    if (_scrollDuration < 0) return;
    [self setupTimer];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    if (_placeholderImage == placeholderImage) return;
    _placeholderImage = placeholderImage;
    if (!_placeholderImage) return;
    for (UIImageView *imageView in _imageViewArray) {
        if (!imageView.image) imageView.image = placeholderImage;
    }
}

- (void)setImageURLArray:(NSArray<NSString *> *)imageURLArray {
    if (_imageURLArray == imageURLArray) return;
    _imageURLArray = imageURLArray;
    [self setupUrlStringArray:[imageURLArray mutableCopy]];
}

#pragma mark - Subview

// 生成子视图
- (void)generateSubview {
    // 滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    [self addSubview:_scrollView];
    
    // 图片视图
    NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:IMAGE_VIEW_COUNT];
    for (NSUInteger i = 0; i < IMAGE_VIEW_COUNT; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageViews addObject:imageView];
        [_scrollView addSubview:imageView];
        
        if (i == (IMAGE_VIEW_COUNT / 2)) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapMiddleImageView:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
    }
    _imageViewArray = [imageViews copy];
    
    // 分页控制器
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = COLOR_HEX(0x42b678);
    [self addSubview:_pageControl];
}

// 生成图片阴影
- (void)generateImageShadow {
    NSMutableArray *backViews = [NSMutableArray arrayWithCapacity:IMAGE_VIEW_COUNT];
    for (NSUInteger i = 0; i < IMAGE_VIEW_COUNT; i ++) {
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.shadowOpacity = 0.4;
        backView.layer.shadowRadius = 5.0;
        backView.layer.shadowOffset = CGSizeMake(0, 0);
        [backViews addObject:backView];
        [_scrollView insertSubview:backView atIndex:0];
    }
    _backViewArray = [backViews copy];
}

// 设置子视图frame
- (void)configAllSubview {
    _scrollWidth = self.frame.size.width - 2 * (_sideWidth + _marginH);
    _scrollView.frame = CGRectMake(_sideWidth + _marginH, 0, _scrollWidth, _scrollHeight);
    _scrollView.contentSize = CGSizeMake(_scrollWidth * IMAGE_VIEW_COUNT, _scrollHeight);
    _scrollView.contentOffset = CGPointMake(_scrollWidth * (IMAGE_VIEW_COUNT / 2), 0);
    
    CGRect frame = CGRectMake(0, _marginV, _scrollWidth - 2 * _marginH, _scrollHeight - 2 * _marginV);
    for (NSInteger i = 0; i < IMAGE_VIEW_COUNT; i ++) {
        frame.origin.x = _marginH + i * _scrollWidth;
        
        if (_backViewArray.count > i) {
            UIView *backView = _backViewArray[i];
            backView.frame = frame;
            backView.layer.cornerRadius = _imageCorner;
        }
        UIImageView *imageView = _imageViewArray[i];
        imageView.frame = frame;
        imageView.layer.cornerRadius = _imageCorner;
        imageView.layer.masksToBounds = _imageCorner > 0;
    }
    CGFloat pageHeight = [_pageControl sizeForNumberOfPages:1].height * 0.6;
    _pageControl.frame = CGRectMake(0, _scrollHeight - pageHeight - _marginV, self.frame.size.width, pageHeight);
}

#pragma mark - Image Assignment

- (void)setupUrlStringArray:(NSMutableArray *)urlStrArr {
    NSInteger count = urlStrArr.count;
    if (count == 0) return;
    if (count == 1) {
        NSString *urlStr = [urlStrArr firstObject];
        [urlStrArr addObject:urlStr];
        [urlStrArr addObject:urlStr];
    } else if (count == 2) {
        [urlStrArr addObjectsFromArray:urlStrArr];
    }
    _imagesArray = [urlStrArr copy];
    _pageControl.numberOfPages = count;
    [self setupImage];
    [self setupTimer];
}

- (void)setupImage {
    // 计算当前每个图片视图对应的图片数组下标，需先计保证图片数量不少于3个
    NSInteger imageCount = _imagesArray.count;
    if (imageCount < 3) return;
    NSArray *indexArray = @[@((_currentIndex - 2 + imageCount) % imageCount),
                            @((_currentIndex - 1 + imageCount) % imageCount),
                            @(_currentIndex),
                            @((_currentIndex + 1) % imageCount),
                            @((_currentIndex + 2) % imageCount)];

    for (NSInteger i = 0; i < IMAGE_VIEW_COUNT; i ++) {
        UIImageView *imageView = _imageViewArray[i];
        NSString *urlStr = [_imagesArray objectAtIndex:[indexArray[i] integerValue]];
        NSURL *imageUrl = [NSURL URLWithString:urlStr];
        [imageView sd_setImageWithURL:imageUrl placeholderImage:_placeholderImage options:SDWebImageRetryFailed];
    }
}

- (void)setupTimer {
    if (_timer) return;
    if (_scrollDuration <= 0) return;
    if (_imageURLArray.count <= 1) return;
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollDuration repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollWidth * 3, 0) animated:YES];
    }];
}

#pragma mark - Respond

// 点击中间图片视图
- (void)tapMiddleImageView:(UITapGestureRecognizer *)gesture {
    if (_tapImageAction) {
        NSInteger index = _imageURLArray.count > 0 ? _currentIndex % _imageURLArray.count : -1;
        _tapImageAction(index);
    }
}

// 重构hitTest事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        for (UIView *subview in _scrollView.subviews) {
            CGPoint offset = CGPointMake(point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x - subview.frame.origin.x,
                                         point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y - subview.frame.origin.y);
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return _scrollView;
    }
    return view;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger imageCount = _imagesArray.count;
    if (imageCount < 3) return;
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > _scrollWidth * 3 - 0.2) {
        _currentIndex = (_currentIndex + 1) % imageCount;
    } else if (offsetX < _scrollWidth + 0.2) {
        _currentIndex = (_currentIndex - 1 + imageCount) % imageCount;
    } else {
        return;
    }
    [self setupImage];
    [self resetScrollViewAndPageControl];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_timer) [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollDuration]];
}

// 重新设置滚动偏移量和当前分页
- (void)resetScrollViewAndPageControl {
    [_scrollView setContentOffset:CGPointMake(_scrollWidth * 2, 0) animated:NO];
    if (_pageControl.numberOfPages == 1) {
        _pageControl.currentPage = 0;
    } else if (_pageControl.numberOfPages == 2) {
        _pageControl.currentPage = _currentIndex % 2;
    } else {
        _pageControl.currentPage = _currentIndex;
    }
}

@end
