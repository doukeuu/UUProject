//
//  UUInteractiveTransition.h
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UUInteractiveTransitionType) {      // 交互类型
    UUInteractiveTransitionTypePop = 1,
    UUInteractiveTransitionTypeDismiss
};

typedef NS_ENUM(NSInteger, UUInteractiveTransitionDirection) { // 手势方向
    UUInteractiveTransitionDirectionUp = 1,
    UUInteractiveTransitionDirectionLeft,
    UUInteractiveTransitionDirectionDown,
    UUInteractiveTransitionDirectionRight
};

@interface UUInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL isInterating;                         // 是否正在交互
@property (nonatomic, assign) UUInteractiveTransitionType interactiveType; // 操作类型
@property (nonatomic, assign) UUInteractiveTransitionDirection direction;  // 手势方向

// 添加Pan手势的初始化
- (instancetype)initWithPanGestureAddedController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
