//
//  UUSearchPatternInputView.h
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUSearchPatternInputView;

@protocol UUSearchPatternInputViewDelegate <NSObject>

@optional
/// 返回输入的关键字
/// @param view 搜索视图
/// @param searchKey 输入的关键字
- (void)searchView:(UUSearchPatternInputView *)view searchKey:(NSString *)searchKey;

/// 清空搜索框响应方法
- (void)searchViewDidClearSearchKey:(UUSearchPatternInputView *)view;

/// 点击return按钮响应方法
- (void)searchViewKeyboardDidReturn:(UUSearchPatternInputView *)view;
@end


@interface UUSearchPatternInputView : UIView

/// 输入框
@property (nonatomic, strong, readonly) UITextField *textField;
/// 代理
@property (nonatomic, weak) id<UUSearchPatternInputViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
