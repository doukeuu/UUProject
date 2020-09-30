//
//  UUTitleTableCell.h
//  OCProject
//
//  Created by Pan on 2020/9/19.
//  Copyright © 2020 xyz. All rights reserved.
//
//  包含左图、中间两标签、右箭头共四个可选视图，其中边距等需提前设定
//  中间两标签有左右和上下两种格式，UITableViewCellStyle=3为上下，其余为左右

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUTitleTableCell : UITableViewCell

/// 左边距
@property (nonatomic, assign) CGFloat leftMargin;
/// 右边距
@property (nonatomic, assign) CGFloat rightMargin;
/// 距中间上下距离
@property (nonatomic, assign) CGFloat middleSpace;

/// 标题标签
@property (nonatomic, strong, readonly, nullable) UILabel *titleLabel;
/// 详情标签
@property (nonatomic, strong, readonly, nullable) UILabel *stateLabel;
/// 分割线视图
@property (nonatomic, strong, readonly, nullable) UIView *lineView;

/// 左边图标名称
@property (nonatomic, copy) NSString *iconName;
/// 右边指示图名称
@property (nonatomic, copy) NSString *indicatorName;
/// 是否展示指示图，默认YES
@property (nonatomic, assign) BOOL showIndicator;
@end

NS_ASSUME_NONNULL_END
