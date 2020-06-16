//
//  UUBaseController.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUBaseController : UIViewController

@property (nonatomic, assign) BOOL hideShadowImage;       // 是否隐藏导航栏阴影线，默认NO
@property (nonatomic, assign) BOOL navigationTransparent; // 导航栏是否透明，默认NO
@property (nonatomic, assign) BOOL goBackControllable;    // 返回功能可控
@property (nonatomic, assign) BOOL barTransparent; // 导航栏是否透明


// 属性goBackControllable为Yes时，重写此方法，实现返回可控，其实就是添加了左边的按钮
- (void)controlledGoBack;

// 一个类似导航栏的背景视图
- (UIView *)navigateViewSeemedWithHeight:(CGFloat)height backColor:(UIColor *)color;
// 导航栏上左右用到的自定义按钮，根据按钮title和image
- (UIButton *)buttonForNavigationItemWithTitle:(NSString * _Nullable)title imageName:(NSString *)imageName;

// 添加左边导航按钮
- (void)addLeftNavigationItemWithCustomView:(UIView *)view;
// 添加右边导航按钮
- (void)addRightNavigationItemWithCustomView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
