//
//  UIScrollView+Placeholder.h
//  OCProject
//
//  Created by Pan on 2020/7/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUPlaceholderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Placeholder)

/// 点击刷新按钮的响应回调
@property (nonatomic, copy) void(^actionBlock)(void);

/// 根据类型加载空数据占位视图，仅限UITableView及UICollectionView
- (void)checkEmpty:(UUPlaceholderViewType)type;

/// 根据类型加载空数据占位视图，仅限UITableView及UICollectionView，offsetY竖直偏移量
- (void)checkEmpty:(UUPlaceholderViewType)type offsetY:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
