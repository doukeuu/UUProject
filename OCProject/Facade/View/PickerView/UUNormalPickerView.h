//
//  UUNormalPickerView.h
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUNormalPickerView : UIView

/**
 弹出单列选择视图
 @param title 中间标题
 @param texts 字符串数组
 @param block 选择后回调
 */
+ (void)showPickerWithTitle:(NSString *)title texts:(NSArray *)texts
                 completion:(void(^)(NSInteger index, NSString *title))block;
@end

NS_ASSUME_NONNULL_END
