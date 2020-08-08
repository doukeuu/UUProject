//
//  UUChartListController.m
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUChartListController.h"
#import "UUPieChartOneCell.h"
#import "UUPieChartTwoCell.h"
#import "UUBarChartOneCell.h"
#import "UUBarChartTwoCell.h"
#import "UULineChartOneCell.h"

@interface UUChartListController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@end

@implementation UUChartListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateSubviews];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 列表视图
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) return 1;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UUPieChartOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPieChartOneCell"];
            if (!cell) {
                cell = [[UUPieChartOneCell alloc] initWithStyle:0 reuseIdentifier:@"kPieChartOneCell"];
            }
            [cell setupCountArray:@[@"1", @"2", @"3", @"4", @"5"]];
            return cell;
        }
        UUPieChartTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPieChartTwoCell"];
        if (!cell) {
            cell = [[UUPieChartTwoCell alloc] initWithStyle:0 reuseIdentifier:@"kPieChartTwoCell"];
            cell.titles = @[@"净水服务", @"健康食品", @"生物科技", @"健康评估"];
            cell.colors = @[COLOR_HEX(0x2E74E8), COLOR_HEX(0x56D52B), COLOR_HEX(0xFF586E), COLOR_HEX(0xF6AB30)];
        }
        [cell setupCountArray:@[@"1", @"2", @"3", @"4"]];
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UUBarChartOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kBarChartOneCell"];
            if (!cell) {
                cell = [[UUBarChartOneCell alloc] initWithStyle:0 reuseIdentifier:@"kBarChartOneCell"];
            }
            [cell setupXValues:@[@"吃", @"喝", @"睡"] yValues:@[@"1", @"2", @"3"]];
            return cell;
        }
        UUBarChartTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kBarChartTwoCell"];
        if (!cell) {
            cell = [[UUBarChartTwoCell alloc] initWithStyle:0 reuseIdentifier:@"kBarChartTwoCell"];
        }
        [cell setupXValues:@[@"吃", @"喝", @"玩", @"乐", @"睡", @"消遣"] yValues:@[@"1", @"2", @"3", @"4", @"5", @"6"]];
        return cell;
    }
    UULineChartOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kLineChartOneCell"];
    if (!cell) {
        cell = [[UULineChartOneCell alloc] initWithStyle:0 reuseIdentifier:@"kLineChartOneCell"];
    }
    [cell setupXValues:@[@"吃", @"喝", @"玩", @"乐", @"睡", @"消遣"] yValues:@[@"1", @"2", @"3", @"4", @"5", @"6"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
