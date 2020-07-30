//
//  UIScrollView+Refresh.h
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refresh)

/// 添加头部刷新
- (void)addHeaderRefresh:(void(^)(void))refreshBlock;
/// 开始头部刷新
- (void)beginHeaderRefresh;
/// 结束头部刷新
- (void)endHeaderRefresh;

/// 添加脚部刷新
- (void)addFooterRefresh:(void(^)(void))refreshBlock;
/// 开始脚部刷新
- (void)beginFooterRefresh;
/// 结束脚部刷新
- (void)endFooterRefresh;
/// 没有更多数据
- (void)endNoMoreData;

/// 结束头部脚部刷新
- (void)endBothRefresh;

/// 头部不在普通闲置状态
- (BOOL)headerStateNotIdle;
/// 脚部不在普通闲置状态
- (BOOL)footerStateNotIdle;
@end

NS_ASSUME_NONNULL_END
