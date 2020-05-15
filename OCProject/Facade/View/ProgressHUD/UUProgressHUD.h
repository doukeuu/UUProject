//
//  UUProgressHUD.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUProgressHUD : UIView

/// 显示菊花提示视图
+ (void)showHUD;
/// 隐藏菊花提示视图
+ (void)hideHUD;

/**
 在指定视图中显示菊花提示视图，当presentViewController时，因为在弹出控制器的
 viewDidLoad方法中无法及时获取到当前controller，故用此方法作为解决方案
 @param view 弹出HUD的视图，一般为viewController的view
 */
+ (void)showHUDInView:(UIView *)view;
/// 隐藏视图中的菊花提示视图
+ (void)hideHUDInView:(UIView *)view;

/// 显示提示文字视图
+ (void)showText:(NSString *)text;
/// 在指定视图中显示文字提示，一段时间后隐藏
+ (void)showText:(NSString *)text inView:(UIView *)view during:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
