//
//  UULineChartOneCell.h
//  OCProject
//
//  Created by Pan on 2020/8/4.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UULineChartOneCell : UITableViewCell

/// 更新X轴Y轴数据
- (void)setupXValues:(NSArray<NSString *> *)xValues yValues:(NSArray<NSString *> *)yValues;
@end

NS_ASSUME_NONNULL_END
