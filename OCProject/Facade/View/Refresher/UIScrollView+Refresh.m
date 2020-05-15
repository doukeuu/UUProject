//
//  UIScrollView+Refresh.m
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "UURefresher.h"

@implementation UIScrollView (Refresh)

// 添加头部刷新
- (void)addHeaderRefresh:(void(^)(void))refreshBlock {
    self.mj_header = [UURefreshHeader headerWithBlock:refreshBlock];
}

// 开始头部刷新
- (void)beginHeaderRefresh {
    [self.mj_header beginRefreshing];
}

// 结束头部刷新
- (void)endHeaderRefresh {
    [self.mj_header endRefreshing];
}

// 添加脚部刷新
- (void)addFooterRefresh:(void(^)(void))refreshBlock {
    self.mj_footer = [UURefreshFooter footerWithBlock:refreshBlock];
}

// 开始脚部刷新
- (void)beginFooterRefresh {
    [self.mj_footer beginRefreshing];
}

// 结束脚部刷新
- (void)endFooterRefresh {
    [self.mj_footer endRefreshing];
}

// 没有更多数据
- (void)endNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

// 结束头部脚部刷新
- (void)endBothRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
