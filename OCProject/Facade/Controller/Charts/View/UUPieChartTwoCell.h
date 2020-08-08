//
//  UUPieChartTwoCell.h
//  OCProject
//
//  Created by Pan on 2020/8/4.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUPieChartTwoCell : UITableViewCell

/// 标题数组
@property (nonatomic, strong) NSArray *titles;
/// 颜色数组
@property (nonatomic, strong) NSArray *colors;

/// 设置数据数组
- (void)setupCountArray:(NSArray<NSString *> *)array;
/// 点击饼图
/// @param index 饼图区块下标
- (void)tapPieChartAt:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
