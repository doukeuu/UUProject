//
//  UURefresher.m
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UURefresher.h"

@implementation UURefreshHeader

// 创建header
+ (instancetype)headerWithBlock:(void (^)(void))block {
    UURefreshHeader *header = [self headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    return header;
}

@end



@implementation UURefreshFooter

// 创建footer
+ (instancetype)footerWithBlock:(void (^)(void))block {
    UURefreshFooter *footer = [self footerWithRefreshingBlock:block];
    footer.stateLabel.userInteractionEnabled = NO;
    footer.ignoredScrollViewContentInsetBottom = MJRefreshFooterHeight + BOTTOM_SAFE_AREA;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载完毕" forState:MJRefreshStateNoMoreData];
    return footer;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    CGFloat originH = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom;
    self.mj_y = MAX(originH, self.scrollView.mj_h);
}

@end



@interface UUGifRefreshHeader ()

@property (nonatomic, strong) NSMutableArray *idleImages;    // 普通状态时的图片
@property (nonatomic, strong) NSMutableArray *pullImages;    // 即将刷新时的图片
@property (nonatomic, strong) NSMutableArray *refreshImages; // 正在刷新时的图片
@end

@implementation UUGifRefreshHeader

- (void)prepare {
    [super prepare];
    
    // 设置普通状态的动画图片
    [self setImages:self.idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:self.pullImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
}

// 普通状态时的图片
- (NSMutableArray *)idleImages {
    if (_idleImages) return _idleImages;
    _idleImages = [NSMutableArray arrayWithCapacity:4];
    for (int i = 1; i <= 6; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"pull_%d",i]];
        [_idleImages addObject:img];
    }
    return _idleImages;
}

// 即将刷新时的图片
- (NSMutableArray *)pullImages {
    if (_pullImages) return _pullImages;
    _pullImages = [NSMutableArray arrayWithCapacity:3];
    for (int i = 7; i <= 15; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"pull_%d",i]];
        [_pullImages addObject:img];
    }
    return _pullImages;
}

// 正在刷新时的图片
- (NSMutableArray *)refreshImages {
    if (_refreshImages) return _refreshImages;
    _refreshImages = [NSMutableArray array];
    for (int i = 16; i <= 24; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"pull_%d",i]];
        [_refreshImages addObject:img];
    }
    return _refreshImages;
}

@end
