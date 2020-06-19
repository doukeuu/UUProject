//
//  UULocalAreaPicker.h
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UULocalAreaPickerType) { // 区域类型
    
    UULocalAreaPickerProvinceCity,        // 省份、城市
    UULocalAreaPickerProvinceCityDistrict // 省份、城市、辖区
};

// 选择回调
typedef void(^PickerViewCompletion)(NSString *province, NSString *city, NSString *district);


@interface UULocalAreaPicker : UIView

/**
 展示选择省、市、辖区等区域

 @param title 标题
 @param type 展示类型，两列或三列
 @param completion 点击确定后的回调，分别为 省份、城市、辖区
 */
+ (void)showAreaPickerWithTitle:(NSString *)title areaType:(UULocalAreaPickerType)type completion:(PickerViewCompletion)completion;
@end

NS_ASSUME_NONNULL_END
