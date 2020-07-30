//
//  UUPlaceholderView.h
//  OCProject
//
//  Created by Pan on 2020/7/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UUPlaceholderViewType) {
    /// 网络错误
    UUPlaceholderErrorNetwork,
    /// 暂无数据
    UUPlaceholderEmptyData,
    /// 没有搜索结果
    UUPlaceholderEmptySearch,
    /// 没有工单
    UUPlaceholderEmptyOrder,
    /// 没有消息
    UUPlaceholderEmptyMessage,
    /// 没有净水设备库存
    UUPlaceholderEmptyInventory,
    /// 没有滤芯物料库存
    UUPlaceholderEmptyMateriel
};

@interface UUPlaceholderView : UIView

/// 竖直方向偏移值
@property (nonatomic, assign) CGFloat verticalOffset;

/// 根据类型加载空数据占位视图，仅限UITableView及UICollectionView
- (void)setupEmptyType:(UUPlaceholderViewType)type;
@end

NS_ASSUME_NONNULL_END
