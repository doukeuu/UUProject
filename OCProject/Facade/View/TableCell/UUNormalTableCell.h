//
//  UUNormalTableCell.h
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUNormalTableCell : UITableViewCell

@property (nonatomic, assign) CGFloat      cellHeight;      // 单元格高度，需最先设定，默认70*SCREEN_RATIO
@property (nonatomic, strong) NSIndexPath *indexPath;       // 单元格所在行列
@property (nonatomic, assign) BOOL         showAccessory;   // 是否显示箭头指示标志

@property (nonatomic, strong) UIImageView *headerImageView; // 头像视图
@property (nonatomic, strong) UILabel     *titleLabel;      // 标题标签
@property (nonatomic, strong) UILabel     *contentLabel;    // 内容标签
@property (nonatomic, strong) UIButton    *actionButton;    // 操作按钮
@end

NS_ASSUME_NONNULL_END
