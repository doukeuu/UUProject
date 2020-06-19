//
//  UUCustomDatePicker.h
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

/// 选择器日期类型
typedef NS_OPTIONS(NSInteger, UUCustomDatePickerType) {
    /// 年
    UUCustomDatePickerYear = 1 << 0,
    /// 月
    UUCustomDatePickerMonth = 1 << 1,
    /// 日
    UUCustomDatePickerDay = 1 << 2,
};

/// 日期回调，返回年、月、日
typedef void(^DatePickerBlock)(NSInteger year, NSInteger month, NSInteger day);

@interface UUCustomDatePicker : UUAnimationView

/// 日期类型
@property (nonatomic, assign) UUCustomDatePickerType pickerType;
/// 最小日期
@property (nonatomic, strong) NSDate *minimumDate;
/// 最大日期
@property (nonatomic, strong) NSDate *maximumDate;
/// 含有全部
@property (nonatomic, assign) BOOL includeTotal;
/// 选择回调
@property (nonatomic, copy) DatePickerBlock block;


/// 展示日期选择视图
/// @param type 日期类型
/// @param block 选择后回调
+ (void)showDatePickerWithType:(UUCustomDatePickerType)type
                    completion:(DatePickerBlock _Nullable)block;

/// 展示日期选择视图
/// @param type 日期类型
/// @param minDate 最小日期
/// @param maxDate 最大日期
/// @param includeTotal 是否包含全部选项
/// @param block 选择后回调
+ (void)showPickerWithType:(UUCustomDatePickerType)type
                   minDate:(NSDate * _Nullable)minDate
                   maxDate:(NSDate * _Nullable)maxDate
              includeTotal:(BOOL)includeTotal
                completion:(DatePickerBlock _Nullable)block;

@end

NS_ASSUME_NONNULL_END
