//
//  UUAlertTipsController.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 按钮样式
typedef NS_ENUM(NSInteger, UUAlertTipsActionType) {
    /// 蓝底白字样式按钮
    UUAlertTipsActionBlueBack,
    /// 白底蓝字样式按钮
    UUAlertTipsActionWhiteBack
};


@interface UUAlertTipsController : UIViewController

/// 居左显示
@property (nonatomic, assign) BOOL messageAlignmentLeft;

/// 根据标题和消息声明类
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
/// 根据富文本标题和消息声明类
- (instancetype)initWithAttributedTitle:(NSAttributedString *)title message:(NSAttributedString *)message;
/// 根据标题和类型添加响应按钮
- (void)addAction:(NSString *)title type:(UUAlertTipsActionType)type handler:(void(^ _Nullable)(void))handler;
@end

NS_ASSUME_NONNULL_END
