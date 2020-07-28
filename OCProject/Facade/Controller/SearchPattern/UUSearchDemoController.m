//
//  UUSearchDemoController.m
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchDemoController.h"

#import "UUProgressHUD.h"

#import "UUNetWorkManager.h"

@interface UUSearchDemoController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;  // 列表视图

@property (nonatomic, strong) NSString *searchKey;         // 搜索关键字
@property (nonatomic, assign) NSInteger currentPage;       // 当前页码
@property (nonatomic, assign) NSInteger totalPage;         // 总页数
@property (nonatomic, strong) NSMutableArray *deviceArray; // 设备数组
@end

@implementation UUSearchDemoController

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentPage = 1;
    _totalPage = 1;
    _deviceArray = [NSMutableArray array];
    
    [self generateSubviews];
    [self addRefreshHeaderFooter];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 列表视图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.hidden = YES;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
}

// 添加上下刷新
- (void)addRefreshHeaderFooter {
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addHeaderRefresh:^{
//        weakSelf.currentPage = 1;
//        [weakSelf searchDeviceStatisticsList];
//    }];
//    [self.tableView addFooterRefresh:^{
//        weakSelf.currentPage += 1;
//        if (weakSelf.currentPage > weakSelf.totalPage) {
//            [weakSelf.tableView endNoMoreData];
//        } else {
//            [weakSelf searchDeviceStatisticsList];
//        }
//    }];
}

#pragma mark - Network

// 搜索已安装设备列表
- (void)searchDeviceStatisticsList {
//    [UUProgressHUD showHUD];
//    NSString *suffix = [NSString stringWithFormat:@"/%zd/10", self.currentPage];
//    NSDictionary *param = @{@"key": self.searchKey ?: @""};
//
//    __weak typeof(self) weakSelf = self;
//    [UUNetworkManager get:HTTP_STATISTICS_DEVICE_LIST suffix:suffix params:param success:^(id  _Nullable result) {
//        [UUProgressHUD hideHUD];
//        [weakSelf.tableView endBothRefresh];
//        if (!result || ![result isKindOfClass:[NSDictionary class]]) return ;
//        if (weakSelf.currentPage == 1) [weakSelf.deviceArray removeAllObjects];
//        weakSelf.totalPage = [result[@"pages"] integerValue];
//        if ([result[@"result"] isKindOfClass:[NSArray class]]) {
//            NSArray *modelArray = [UUStatisticsDeviceModel objectArrayWithKeyValuesArray:result[@"result"]];
//            [weakSelf.deviceArray addObjectsFromArray:modelArray];
//        }
//        [weakSelf.tableView reloadData];
//        [weakSelf.tableView checkEmpty:UUEmptyPlaceholderEmptyData];
//    } failure:^(NSError * _Nonnull error) {
//        [UUProgressHUD hideHUD];
//        [weakSelf.tableView endBothRefresh];
//        NSString *tips = error.userInfo[NetworkErrorTips];
//        if (tips) [UUProgressHUD showText:tips];
//        [weakSelf.tableView checkEmpty:UUEmptyPlaceholderErrorNetwork];
//    }];
}

#pragma mark - Respond

- (void)beginToSearch:(NSString *)key {
    self.searchKey = key;
    if (!key || key.length == 0) {
        [self cleanToSearch];
    } else {
        self.currentPage = 1;
        [self searchDeviceStatisticsList];
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    }
}

- (void)cleanToSearch {
    self.currentPage = 1;
    [self.deviceArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.hidden = YES;
    self.collectionView.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;//self.deviceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewSearchCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"TableViewSearchCell"];
    }
    cell.textLabel.text = @"123";
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" -- %@", indexPath);
}

@end
