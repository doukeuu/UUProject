//
//  UUImitateWeChatController.m
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUImitateWeChatController.h"

#import "UUImitateWeChatCell.h"
#import "UUImitateWeChatView.h"
#import "UUExtensionModel.h"

#import "UIView+UU.h"
#import "UIScrollView+Refresh.h"
#import "UIScrollView+Placeholder.h"
#import "UUProgressHUD.h"
#import "UUNetWorkManager.h"

@interface UUImitateWeChatController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UUImitateWeChatCellDelegate,
    UUImitateWeChatViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;          // 列表视图
@property (nonatomic, strong) UUImitateWeChatView *bottomView; // 底部视图

@property (nonatomic, strong) NSMutableArray *messageArray;     // 消息数组
@property (nonatomic, assign) NSInteger page;                   // 当前页码
@property (nonatomic, assign) NSInteger totalPage;              // 总页码数
@property (nonatomic, assign) BOOL shouldDelete;                // 是否需要删除
@property (nonatomic, strong) NSMutableDictionary *selectedDic; // 选中的单元格
@end

@implementation UUImitateWeChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messageArray = [NSMutableArray array];
    _page = 1;
    _totalPage = 1;
    _shouldDelete = NO;
    _selectedDic = [NSMutableDictionary dictionary];
    
    [self generateSubviews];
    [self addRefreshHeaderFooter];
    [self acquireSystemMessageList];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 列表视图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90;
    [self.view addSubview:_tableView];
    
    // 获取系统左滑手势
    for (UIGestureRecognizer *ges in self.tableView.gestureRecognizers) {
        if ([ges isKindOfClass:NSClassFromString(@"_UISwipeActionPanGestureRecognizer")]) {
            [ges addTarget:self action:@selector(swipeRecognizerDidRecognized:)];
        }
    }
}

// 底部视图
- (UUImitateWeChatView *)bottomView {
    if (_bottomView) return _bottomView;
    CGRect rect = CGRectMake(0, self.view.height - 50 - BOTTOM_SAFE_AREA, self.view.width, 50);
    _bottomView = [[UUImitateWeChatView alloc] initWithFrame:rect];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    return _bottomView;
}

// 添加上下刷新
- (void)addRefreshHeaderFooter {
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderRefresh:^{
        weakSelf.page = 1;
        [weakSelf acquireSystemMessageList];
    }];
    [self.tableView addFooterRefresh:^{
        weakSelf.page += 1;
        if (weakSelf.page > weakSelf.totalPage) {
            [weakSelf.tableView endNoMoreData];
        } else {
            [weakSelf acquireSystemMessageList];
        }
    }];
}

#pragma mark - Network

// 获取系统消息列表
- (void)acquireSystemMessageList {
    [UUProgressHUD showHUD];
    NSString *path = [NSString stringWithFormat:@"%@/message/%zd/10", NET_URL_BASE, self.page];
    NSDictionary *param = @{@"pushType": @(1)};
    
    __weak typeof(self) weakSelf = self;
    [UUNetWorkManager GET:path param:param config:nil success:^(id  _Nullable result) {
        [UUProgressHUD hideHUD];
        [weakSelf.tableView endBothRefresh];
        if (!result || ![result isKindOfClass:[NSDictionary class]]) return ;
        if (weakSelf.page == 1) [weakSelf.messageArray removeAllObjects];
        weakSelf.totalPage = [result[@"pages"] integerValue];
        NSArray *resultArray = result[@"result"];
        for (NSDictionary *dic in resultArray) {
            UUExtensionModel *model = [UUExtensionModel parseWithKeyValues:dic];
            [weakSelf.messageArray addObject:model];
        }
        [weakSelf updateBottomViewSelection];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView checkEmpty:UUPlaceholderEmptyData];
    } failure:^(NSDictionary<NSErrorUserInfoKey,id> * _Nonnull userInfo) {
        [UUProgressHUD hideHUD];
        [weakSelf.tableView endBothRefresh];
        NSString *tips = userInfo[UUNetworkErrorTips];
        if (tips) [UUProgressHUD showText:tips];
        [weakSelf.tableView checkEmpty:UUPlaceholderErrorNetwork];
    }];
}

// 修改系统消息已读
- (void)modifySystemMessageReaded:(UUExtensionModel *)messageModel {
    NSString *path = [NSString stringWithFormat:@"%@/delete/%@/read", NET_URL_BASE, @"id"];
    
    __weak typeof(self) weakSelf = self;
    [UUNetWorkManager PATCH:path param:nil config:nil success:^(id  _Nullable result) {
        [weakSelf.tableView reloadData];
    } failure:nil];
}

// 删除多条信息
- (void)deleteMultitpleSystemMessage {
    [UUProgressHUD showHUD];
    NSMutableArray *messageIds = [NSMutableArray arrayWithCapacity:self.selectedDic.count];
    NSInteger count = self.messageArray.count;
    for (NSNumber *key in self.selectedDic.keyEnumerator) {
        NSInteger index = [key integerValue];
        if (index < count) {
            NSString *messageId = self.messageArray[index];
            [messageIds addObject:messageId];
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@/message/%@/batch", NET_URL_BASE, [messageIds componentsJoinedByString:@","]];
    
    __weak typeof(self) weakSelf = self;
    [UUNetWorkManager DELETE:path param:nil config:nil success:^(id  _Nullable result) {
        [UUProgressHUD hideHUD];
        for (NSNumber *key in weakSelf.selectedDic.keyEnumerator) {
            NSInteger index = [key integerValue];
            if (index < count) {
                [weakSelf.messageArray removeObjectAtIndex:index];
            }
        }
        [weakSelf.selectedDic removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView checkEmpty:UUPlaceholderEmptyData];
    } failure:^(NSDictionary<NSErrorUserInfoKey,id> * _Nonnull userInfo) {
        [UUProgressHUD hideHUD];
        NSString *tips = userInfo[UUNetworkErrorTips];
        if (tips) [UUProgressHUD showText:tips];
    }];
}

#pragma mark - Respond

// 系统左滑手势响应
- (void)swipeRecognizerDidRecognized:(UIPanGestureRecognizer *)gesture {
    self.shouldDelete = NO;
    
    if (gesture.state == UIGestureRecognizerStateBegan) return;
    CGPoint point = [gesture locationInView:gesture.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    UUImitateWeChatCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *pullViewName = @"UISwipeActionPullView";
    UIView *pullView = nil;
    
    for (UIView *subview in cell.superview.subviews) {
        if ([subview isKindOfClass:[UITableViewCell class]]) continue;
        NSString *subviewName = NSStringFromClass(subview.class);
        if ([subviewName isEqualToString:pullViewName]) {
            pullView = subview;
            break;
        }
    }
    CGFloat width = pullView.bounds.size.width / 2;
    for (UIView *view in pullView.subviews) {
        [view setValue:@(width) forKey:@"_buttonWidth"]; // 这个属性值控制UIButtonLabel的宽度
        UIButton *button = (UIButton *)view;
        if ([[button titleForState:UIControlStateNormal] isEqualToString:@"确认删除"]) {
            [button setTitle:@"删除" forState:UIControlStateNormal];
        }
        [view setNeedsLayout];
    }
}

// 重新设置列表高度、底部视图及编辑按钮是否显示
- (void)redisplayPartOfSubviews {
    self.bottomView.hidden = !self.tableView.isEditing;
    CGFloat height = self.bottomView.isHidden ? self.view.height : self.bottomView.top;
    self.tableView.height = height;
    [self.tableView reloadData];
}

// 更新底部视图的选择状态
- (void)updateBottomViewSelection {
    if (self.page == 1) {
        [self.selectedDic removeAllObjects];
    }
    if (self.messageArray.count > self.selectedDic.count) {
        if (_bottomView) _bottomView.isAllSelected = NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UUImitateWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kImitateWeChatCell"];
    if (!cell) {
        cell = [[UUImitateWeChatCell alloc] initWithStyle:1 reuseIdentifier:@"kImitateWeChatCell"];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    cell.cellEditing = tableView.isEditing;
    cell.cellSelected = [self.selectedDic[@(indexPath.row)] boolValue];
    [cell setupModel:self.messageArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" -- ");
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.shouldDelete = NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.shouldDelete = NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.shouldDelete ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO; // 编辑时，左边不缩进
}

// iOS 11.0之前，左滑手势响应方法
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        self.selectedDic[@(indexPath.row)] = @(YES);
        [tableView setEditing:NO animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除消息" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteMultitpleSystemMessage];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.selectedDic removeAllObjects];
        }]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }];
    deleteAction.backgroundColor = UIColor.redColor;
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        tableView.editing = NO;
        self.shouldDelete = YES;
        tableView.editing = YES;
        self.selectedDic[@(indexPath.row)] = @(YES);
        [self redisplayPartOfSubviews];
        self.bottomView.isAllSelected = self.messageArray.count == self.selectedDic.count;
    }];
    moreAction.backgroundColor = UIColor.blueColor;
    return @[deleteAction, moreAction];
}

// iOS 11.0之后，左滑手势响应方法
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)) {
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if (self.shouldDelete) { // 第二次可删除
            self.selectedDic[@(indexPath.row)] = @(YES);
            [self deleteMultitpleSystemMessage];
            completionHandler(YES);
            return ;
        }
        self.shouldDelete = YES;
        UIButton *button = nil;
        if ([sourceView isKindOfClass:[UIButton class]]) {
            button = (UIButton *)sourceView;
        } else if ([sourceView.superview isKindOfClass:[UIButton class]]) {
            button = (UIButton *)sourceView.superview;
        }
        [UIView animateWithDuration:0.3 animations:^{
            button.left = 0; // iOS 12中，需要手动左移
        }];
        [button setTitle:@"确认删除" forState:UIControlStateNormal];
        for (UIView *view in button.superview.subviews) {
            CGFloat width = view == button ? button.superview.width : 1;
            [view setValue:@(width) forKey:@"_buttonWidth"];
        }
    }];
    deleteAction.backgroundColor = UIColor.redColor;
    UIContextualAction *moreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"更多" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        completionHandler(YES);
        tableView.editing = NO; // 先关后开
        self.shouldDelete = YES;
        tableView.editing = YES;
        self.selectedDic[@(indexPath.row)] = @(YES);
        [self redisplayPartOfSubviews];
        self.bottomView.isAllSelected = self.messageArray.count == self.selectedDic.count;
    }];
    moreAction.backgroundColor = UIColor.blueColor;
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, moreAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

#pragma mark - UUImitateWeChatCellDelegate

- (void)imitateWeChatCell:(UUImitateWeChatCell *)cell didSelected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath {
    if (selected) {
        [self.selectedDic setObject:@(selected) forKey:@(indexPath.row)];
    } else {
        [self.selectedDic removeObjectForKey:@(indexPath.row)];
    }
    self.bottomView.isAllSelected = self.messageArray.count == self.selectedDic.count;
}

#pragma mark - UUImitateWeChatViewDelegate

- (void)imitateWeChatView:(UUImitateWeChatView *)view didClickAt:(UUImitateWeChatAction)action {
    switch (action) {
        case UUImitateWeChatSelected: { // 全选
            NSInteger count = self.messageArray.count;
            for (NSInteger i = 0; i < count; i ++) {
                self.selectedDic[@(i)] = @(YES);
            }
            [self.tableView reloadData];
        } break;
        case UUImitateWeChatDeselect: // 全不选
            [self.selectedDic removeAllObjects];
            [self.tableView reloadData];
            break;
        case UUImitateWeChatDelete: // 删除
            self.tableView.editing = NO;
            self.shouldDelete = NO;
            [self redisplayPartOfSubviews];
            [self deleteMultitpleSystemMessage];
            break;
        case UUImitateWeChatDone: // 完成
            self.tableView.editing = NO;
            self.shouldDelete = NO;
            [self.selectedDic removeAllObjects];
            [self redisplayPartOfSubviews];
            break;
        default: break;
    }

}

@end
