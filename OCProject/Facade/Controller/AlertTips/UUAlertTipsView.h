//
//  UUAlertTipsView.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UUAlertTipsButtonType) {
    UUAlertTipsButtonBlue, ///< 蓝底白字样式按钮
    UUAlertTipsButtonWhite ///< 白底蓝字样式按钮
};

@interface UUAlertTipsView : UIView

@property (nonatomic ,assign)BOOL isLeftText;//居左显示

/// 根据标题和消息声明类
+ (instancetype)customizedWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
/// 根据富文本标题和消息声明类
+ (instancetype)customizedWithAttributedTitle:(nullable NSAttributedString *)title message:(nullable NSAttributedString *)message;

/// 根据标题和类型添加响应按钮
- (void)addActionWithTitle:(NSString *)title type:(UUAlertTipsButtonType)type handler:(nullable void(^)(void))handler;
/// 弹出视图
- (void)popupAlertView;
/// 在一定时间间隔内弹出并隐藏视图
- (void)popupAlertViewWithDuration:(NSTimeInterval)interval;
/// 隐藏视图
- (void)hideAlertView;

@end

NS_ASSUME_NONNULL_END
