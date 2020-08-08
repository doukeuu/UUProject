//
//  UUImitateWeChatView.h
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UUImitateWeChatAction) {
    /// 全选
    UUImitateWeChatSelected,
    /// 全不选
    UUImitateWeChatDeselect,
    /// 完成
    UUImitateWeChatDone,
    /// 删除
    UUImitateWeChatDelete
};

@class UUImitateWeChatView;

@protocol UUImitateWeChatViewDelegate <NSObject>

/// 点击类型响应代理
- (void)imitateWeChatView:(UUImitateWeChatView *)view didClickAt:(UUImitateWeChatAction)action;
@end


@interface UUImitateWeChatView : UIView

/// 是否全选
@property (nonatomic, assign) BOOL isAllSelected;
/// 代理
@property (nonatomic, weak) id<UUImitateWeChatViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
