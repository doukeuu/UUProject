//
//  UUDistalAreaPicker.h
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUDistalAreaPicker : UIView

/// 选择省市区后回调
@property (nonatomic, copy) void(^areaSelectedBlock)(NSString * _Nullable province,
                                                    NSString * _Nullable city,
                                                    NSString * _Nullable district);
/// 包含全部选项时的初始化方法
- (instancetype)initWithIncludeAll:(BOOL)includeAll;
/// 展示选择器
- (void)showPickerView;
/// 隐藏选择器
- (void)hidePickerView;
/// 获取所有地址信息
+ (void)acquireTotalAddress;
@end

NS_ASSUME_NONNULL_END
