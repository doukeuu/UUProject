//
//  UUSearchFielddView.h
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUSearchFielddView : UIView

@property (nonatomic, strong) UITextField *inputField;       // 输入框
@property (nonatomic, strong) UIButton *actionButton;        // 功能按钮

// 加了搜索图标的输入框
+ (UITextField *)textFieldWithSearchIcon;

// 加了搜索图标的输入框，适合放在导航栏中
+ (UITextField *)textFieldForNavigationSearch;
@end

NS_ASSUME_NONNULL_END
