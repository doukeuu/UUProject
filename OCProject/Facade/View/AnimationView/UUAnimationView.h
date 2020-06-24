//
//  UUAnimationView.h
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 弹出动画式样
typedef NS_ENUM(NSInteger, UUAnimationType) {
    /// 从顶部弹出
    UUAnimationPopFromTop,
    /// 从左边弹出
    UUAnimationPopFromLeft,
    /// 从底部弹出
    UUAnimationPopFromBottom,
    /// 从右边弹出
    UUAnimationPopFromRight,
    /// 从指定点缩放弹出
    UUAnimationScaleFromPoint,
    /// 从右上角放大弹出
    UUAnimationScaleFromRightTop
};


@interface UUAnimationView : UIView

/// 自定义内容视图
@property (nonatomic, strong) UIView *bezelView;
/// 弹出位置
@property (nonatomic, assign) CGPoint popupPoint;
/// 弹出动画样式
@property (nonatomic, assign) UUAnimationType animationType;

/// 更新视图的Frame
- (void) updateBezelViewFrame;
/// 弹出视图
- (void) popViewAnimated;
/// 隐藏视图
- (void) hideViewAnimated;
@end

NS_ASSUME_NONNULL_END
