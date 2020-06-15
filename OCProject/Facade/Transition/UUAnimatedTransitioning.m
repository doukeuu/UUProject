//
//  UUAnimatedTransitioning.m
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAnimatedTransitioning.h"

@implementation UUAnimatedTransitioning

- (instancetype)initWithType:(UUTransitioningType)type {
    
    if (self = [super init]) {
        self.transitioningType = type;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    switch (self.transitioningType) {
        case UUTransitioningPushFromBottom: return .3f;
            break;
        case UUTransitioningPopFromTop:     return .2f;
    }
    return .3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    switch (self.transitioningType) {
        case UUTransitioningPushFromBottom:
            [self pushControllerFromBottomAnimatedWithContext:transitionContext];
            break;
            
        case UUTransitioningPopFromTop:
            [self popControllerFromTopAnimatedWithContext:transitionContext];
            break;
    }
}


#pragma mark - Animated Transitioning

// 从下往上压入导航视图的动画设置
- (void)pushControllerFromBottomAnimatedWithContext:(id<UIViewControllerContextTransitioning>)context {
    
    UIViewController *fromController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 做快照，主要是用于起始视图不适合做动画的情况，这里可以不用，仅仅是作为一种方法展示一下
    UIView *fromView = [fromController.view snapshotViewAfterScreenUpdates:YES];
    fromView.frame = fromController.view.frame;
    
    // 调整压入的视图的frame，以便做动画
    CGRect finalFrame = [context finalFrameForViewController:toController];
    toController.view.frame = CGRectOffset(finalFrame, 0, [UIScreen mainScreen].bounds.size.height);
    
    // 动画执行容器视图，添加视图的顺序有讲究的
    UIView *containerView = [context containerView];
    [containerView addSubview:fromView];
    [containerView addSubview:toController.view];
    
    NSTimeInterval duration = [self transitionDuration:context];
    [UIView animateWithDuration:duration delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toController.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [context completeTransition:YES]; // 必须添加，如果响应手势，要判断是否取消手势
        [fromView removeFromSuperview]; // 快照仅用于动画，使用后需删除
    }];
}

// 从上向下推出导航视图的动画设置
- (void)popControllerFromTopAnimatedWithContext:(id<UIViewControllerContextTransitioning>)context {
    
    UIViewController *fromController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initialFrame = [context initialFrameForViewController:fromController];
    
    // 动画执行容器视图，添加视图的顺序有讲究的
    UIView *containerView = [context containerView];
    [containerView addSubview:toController.view];
    [containerView addSubview:fromController.view];
    
    NSTimeInterval duration = [self transitionDuration:context];
    [UIView animateWithDuration:duration delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        fromController.view.frame = CGRectOffset(initialFrame, 0, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        
        [context completeTransition:![context transitionWasCancelled]];
    }];
}


@end
