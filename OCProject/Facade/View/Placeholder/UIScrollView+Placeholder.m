//
//  UIScrollView+Placeholder.m
//  OCProject
//
//  Created by Pan on 2020/7/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UIScrollView+Placeholder.h"
#import <objc/runtime.h>
#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Placeholder)

#pragma mark - Property

static const void *kActionBlock = &kActionBlock;

- (void)setActionBlock:(void (^)(void))actionBlock {
    objc_setAssociatedObject(self, kActionBlock, actionBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))actionBlock {
    return objc_getAssociatedObject(self, kActionBlock);
}

#pragma mark - Public

// 根据类型加载空数据占位视图，仅限UITableView及UICollectionView
- (void)checkEmpty:(UUPlaceholderViewType)type {
    [self checkEmpty:type offsetY:0.0];
}

// 根据类型加载空数据占位视图，仅限UITableView及UICollectionView，offsetY竖直偏移量
- (void)checkEmpty:(UUPlaceholderViewType)type offsetY:(CGFloat)offsetY {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UUPlaceholderView class]]) {
            [subview removeFromSuperview];
        }
    }
    if ([self rowItemCount] != 0) return;
    UUPlaceholderView *emptyView = [[UUPlaceholderView alloc] init];
    emptyView.verticalOffset = offsetY;
    CGFloat headerH = [self headerViewHeight];
    CGFloat footerH = [self footerViewHeight];
    if (@available(iOS 11.0, *)) {
        headerH += self.adjustedContentInset.top;
        footerH += self.adjustedContentInset.bottom;
    } else {
        headerH += self.contentInset.top;
        footerH += self.contentInset.bottom;
    }
    // 规避MJRefresh框架中的header与footer，如果没有引用框架，去掉下面相关代码
    if ([self headerStateNotIdle]) {
        headerH -= 54;
    }
    if ([self footerStateNotIdle]) {
        footerH -= 44;
    }
    CGFloat height = self.bounds.size.height - headerH - footerH;
    emptyView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
    [emptyView setupEmptyType:type];
    [self insertSubview:emptyView atIndex:0];
}

#pragma mark - Utility

// 头部视图高度
- (CGFloat)headerViewHeight {
    CGFloat headerBottom = 0.0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        CGRect rect = tableView.tableHeaderView.frame;
        headerBottom = rect.origin.y + rect.size.height;
    }
    return headerBottom;
}

// 底部视图高度
- (CGFloat)footerViewHeight {
    CGFloat footerHeight = 0.0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        footerHeight = tableView.tableFooterView.frame.size.height;
    }
    return footerHeight;
}

// 判断section与row/item的数量
- (NSInteger)rowItemCount {
    NSInteger items = 0;
    // UIScollView
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    // UITableView
    if ([self isKindOfClass:[UITableView class]]) {
        NSInteger sections = 1;
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView
    else if ([self isKindOfClass:[UICollectionView class]]) {
        NSInteger sections = 1;
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    return items;
}

@end
