//
//  UURippleButtonView.h
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UURippleButtonView;

@protocol UURippleButtonViewDelegate <NSObject>

@optional
/**
 视图即将弹出或隐藏

 @param view 视图
 @param willShow YES 弹出，NO 隐藏
 */
- (void)rippleButtonView:(UURippleButtonView *)view willShowOrHide:(BOOL)willShow;
/**
 点击按钮的操作

 @param view 视图
 @param events 按钮的操作，枚举类型
 */
- (void)rippleButtonView:(UURippleButtonView *)view action:(UIControlEvents)events;
@end


@interface UURippleButtonView : UIView // 波纹按钮

@property (nonatomic, strong) UIButton *voiceButton; // 语音按钮
@property (nonatomic, strong) CALayer *circleLayer;  // 动画圆圈
@property (nonatomic, assign) BOOL showTopLine;      // 是否显示顶部分割线
@property (nonatomic, weak) id<UURippleButtonViewDelegate> delegate; // 代理

// 动画展示视图
- (void)showAnimated;
// 动画隐藏视图
- (void)hideAnimated;
@end

NS_ASSUME_NONNULL_END
