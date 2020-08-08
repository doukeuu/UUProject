//
//  UUImitateWeChatCell.h
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUImitateWeChatCell;

@protocol UUImitateWeChatCellDelegate <NSObject>

/// 单元格是否被选中
/// @param cell 单元格本身
/// @param selected 是否被选中
- (void)imitateWeChatCell:(UUImitateWeChatCell *)cell didSelected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath;
@end


@interface UUImitateWeChatCell : UITableViewCell

/// 单元格下标
@property (nonatomic, strong) NSIndexPath *indexPath;
/// 单元格是否在编辑状态
@property (nonatomic, assign) BOOL cellEditing;
/// 单元格是否被选中
@property (nonatomic, assign) BOOL cellSelected;
/// 代理
@property (nonatomic, weak) id<UUImitateWeChatCellDelegate> delegate;

/// 设置数据类
- (void)setupModel:(id)model;
@end

NS_ASSUME_NONNULL_END
