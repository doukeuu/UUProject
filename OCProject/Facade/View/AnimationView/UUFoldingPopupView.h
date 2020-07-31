//
//  UUFoldingPopupView.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUFoldingPopupView : UUAnimationView

/// 标题数组
@property (nonatomic, strong) NSArray *titleArray;
/// 选中的下标
@property (nonatomic, assign) NSInteger selectedIndex;
/// 选择的列表下标回调
@property (nonatomic, copy) void(^selectedBlock)(NSInteger index);
/// 列表视图
@property (nonatomic, strong, readonly) UITableView *tableView;

/// 从view中隐藏选择视图
+ (void)hidePopupViewIn:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
