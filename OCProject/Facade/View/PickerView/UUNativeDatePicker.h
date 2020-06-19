//
//  UUNativeDatePicker.h
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUNativeDatePicker : UIView

@property (nonatomic, strong) UILabel * titleLabel;              // 标题
@property (nonatomic, strong) UIDatePicker *datePicker;          // 时间滚轴
@property (nonatomic, copy) void(^selectionBlock)(NSDate *date); // 选择完成回调

// 显示
- (void)showAnimated:(BOOL)animated;
// 隐藏
- (void)hideAnimated:(BOOL)animated;

/**
 固定样式的时间滚轴选择器，时间不限期限
 
 @param title 标题
 @param completion 点击确定选择完成时的回调，返回选择的时间类
 */
+ (void)showPickerWithTitle:(NSString *)title completion:(void(^)(NSDate *date))completion;

/**
 固定样式的时间滚轴选择器，时间期限从现在开始
 
 @param title 标题
 @param completion 点击确定选择完成时的回调，返回选择的时间类
 */
+ (void)showPickerBeginNowWithTitle:(NSString *)title completion:(void(^)(NSDate *date))completion;

/**
 固定样式的时间滚轴选择器，时间期限截止到现在

 @param title 标题
 @param completion 点击确定选择完成时的回调，返回选择的时间类
 */
+ (void)showPickerUntilNowWithTitle:(NSString *)title completion:(void(^)(NSDate *date))completion;

/**
 固定样式的时间滚轴选择器，时间期限为当前时间至之前的一年时间内
 
 @param title 标题
 @param completion 点击确定选择完成时的回调，返回选择的时间类
 */
+ (void)showPickerForLastYearWithTitle:(NSString *)title completion:(void(^)(NSDate *date))completion;
@end

NS_ASSUME_NONNULL_END
