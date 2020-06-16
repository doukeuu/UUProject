//
//  UUBulgeTabBar.m
//  OCProject
//
//  Created by Pan on 2020/6/16.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBulgeTabBar.h"
#import "UIImage+UU.h"

@interface UUBulgeTabBar ()

@property (nonatomic, strong) UIView *middleButton; // 中间的按钮
@end

@implementation UUBulgeTabBar

- (instancetype)init {
    if (self = [super init]) {
        _centerBulged = YES;
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (backgroundImage) {
        CGSize size = CGSizeMake(SCREEN_WIDTH, backgroundImage.size.height + BOTTOM_SAFE_AREA);
        backgroundImage = [backgroundImage stretchToFitTabBarSize:size];
    }
    [super setBackgroundImage:backgroundImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.centerBulged) return;
    Class buttonClass = NSClassFromString(@"UITabBarButton");
    Class groundClass = NSClassFromString(@"_UIBarBackground");
    NSInteger index = 0;
    NSInteger itemNum = self.items.count;
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:buttonClass]) {
            if (index == itemNum / 2) {
                //设置中心按钮的大小和位置
                CGSize viewSize = view.bounds.size;
                viewSize.height *= 1.4;
                view.bounds = CGRectMake(0, 0, viewSize.width, viewSize.height);
                
                CGFloat centerY = self.bounds.size.height * 0.5 - 10 - BOTTOM_SAFE_AREA / 2;
                view.center = CGPointMake(self.center.x, centerY);
                self.middleButton = view;
            }
            index ++;
        } else if ([view isKindOfClass:groundClass]) {
            // iOS11 去掉TabBar上部的横线的方法
            for (UIView *ground in view.subviews) {
                if (ground.opaque == YES) ground.hidden = YES;
            }
        } else if ([view isKindOfClass:[UIImageView class]]) {
            // iOS8 去掉TabBar上部的横线的方法
            if (view.bounds.size.height <= 1) view.hidden = YES;
        }
    }
}

/*
 这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
 self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
 在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
 是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.isHidden && self.centerBulged) {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newPoint = [self convertPoint:point toView:self.middleButton];
        //判断如果这个新的点是在突出的按钮身上，那么处理点击事件最合适的view就是突出的按钮
        if ([self.middleButton pointInside:newPoint withEvent:event]) {
            return self.middleButton;
        } else {
            //如果点不在突出的按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    } else {
        //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
