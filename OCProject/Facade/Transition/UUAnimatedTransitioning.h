//
//  UUAnimatedTransitioning.h
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UUTransitioningType) { // 动画类型
    
    UUTransitioningPushFromBottom = 1, // 从下往上压入
    UUTransitioningPopFromTop          // 从上向下推出
};

@interface UUAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UUTransitioningType transitioningType; // 动画类型
// 根据动画类型初始化
- (instancetype)initWithType:(UUTransitioningType)type;
@end

NS_ASSUME_NONNULL_END
