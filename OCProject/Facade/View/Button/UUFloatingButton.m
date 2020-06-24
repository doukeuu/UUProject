//
//  UUFloatingButton.m
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUFloatingButton.h"
#import <FLAnimatedImage.h>

@interface UUFloatingButton ()
{
    CGFloat _navigationHeight; // 导航栏高度
    CGFloat _tabBarHeight;     // TabBar高度
    CGPoint _beginPoint;       // 平移按钮时点触的视图中的位置
    CGFloat _bottomHeight;     // 底部栏高度
}
@end

@implementation UUFloatingButton

// 初始化
+ (instancetype)showFloatingButtonAddTo:(UIWindow *)window {
    
    UITabBarController *tab = (UITabBarController *)window.rootViewController;
    UUFloatingButton *button = [[self alloc] initWithFrame:CGRectMake(window.bounds.size.width - 60, 200, 60, 60)];
//    [button setImage:[UIImage imageNamed:@"assistant"] forState:UIControlStateNormal];
    [button setAssistantGifView];
    [button addObserverForHiddenOfTabBar:tab.tabBar];
    [window addSubview:button];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)addObserverForHiddenOfTabBar:(UITabBar *)tabBar {
    if (tabBar) [tabBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    NSLog(@"== %@", [self class]);
}

// 初始化属性
- (void)commonInit {
    _navigationHeight = NAVIGATOR_H;
    _tabBarHeight = TABBAR_HEIGHT;
    _bottomHeight = _tabBarHeight;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFloatingButton:)];
    [self addGestureRecognizer:pan];
}

// 添加动图
- (void)setAssistantGifView {
    
    NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:@"assistantGif" withExtension:@"gif"];
    NSData *gifData = [[NSData alloc] initWithContentsOfURL:gifUrl];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
    
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.animatedImage = image;
    [self addSubview:imageView];
}

// 拖拽手势
- (void)panFloatingButton:(UIPanGestureRecognizer *)gesture {
    
    UIView *window = self.superview;
    CGFloat winWidth = window.bounds.size.width;
    CGFloat winHeight = window.bounds.size.height;
    UIGestureRecognizerState state = gesture.state;
    
    if (state == UIGestureRecognizerStateBegan) {
        _beginPoint = [gesture locationInView:window]; // 最初始位置
        
    } else if (state == UIGestureRecognizerStateChanged) {
        // 根据滑动的下一个位置与上一个位置之间的x，y差值，计算按钮当前应移动的中心位置
        CGPoint currentPoint = [gesture locationInView:window];
        CGPoint differentPoint = CGPointMake(currentPoint.x - _beginPoint.x, currentPoint.y - _beginPoint.y);
        CGPoint centerPoint = self.center;
        centerPoint = CGPointMake(centerPoint.x + differentPoint.x, centerPoint.y + differentPoint.y);
        if (centerPoint.x < self.bounds.size.width / 2) { // 不能移出左边
            centerPoint.x = self.bounds.size.width / 2;
        } else if (centerPoint.x > winWidth - self.bounds.size.width / 2) { // 不能移出右边
            centerPoint.x = winWidth - self.bounds.size.width / 2;
        }
        if (centerPoint.y < self.bounds.size.height / 2 + _navigationHeight) { // 不能移出上边
            centerPoint.y = self.bounds.size.height / 2 + _navigationHeight;
        } else if (centerPoint.y > winHeight - _bottomHeight - self.bounds.size.height / 2) { // 不能移出下边
            centerPoint.y = winHeight - _bottomHeight - self.bounds.size.height / 2;
        }
        self.center = centerPoint;
        _beginPoint = currentPoint;
        
    } else if (state == UIGestureRecognizerStateEnded) {
        CGPoint centerPoint = self.center;
        // 最后按钮必须靠左右一边
        if (centerPoint.x > winWidth / 2) {
            centerPoint.x = winWidth - self.bounds.size.width / 2;
        } else {
            centerPoint.x = self.bounds.size.width / 2;
        }
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.center = centerPoint;
        }];
    }
}

// floatingButton 对TabBar的hidden属性的监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"hidden"]) {
        BOOL isHidden = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (isHidden) {
            _bottomHeight = _tabBarHeight - 49;
        } else {
            UIView *window = self.superview;
            _bottomHeight = _tabBarHeight;
            CGPoint centerPoint = self.center;
            if (centerPoint.y > window.bounds.size.height - _bottomHeight - self.bounds.size.height / 2) {
                centerPoint.y = window.bounds.size.height - _bottomHeight - self.bounds.size.height / 2;
                self.center = centerPoint;
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 查找当前界面控制器
- (UIViewController *)topViewControllerFrom:(UIViewController *)controller {
    
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
