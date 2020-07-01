//
//  UULoginAreaCodeController.m
//  OCProject
//
//  Created by Pan on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULoginAreaCodeController.h"

@interface UULoginAreaCodeController () 
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (nonatomic, strong) NSDictionary *areaCodeDic; // 区号字典
@property (nonatomic, strong) NSArray *sortedArray;      // 字母排序
//@property (nonatomic, strong) UITableView *tableView;    // 列表视图
@end

@implementation UULoginAreaCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择国家和地区";
    [self generateTableView];
}

// 区号字典
- (NSDictionary *)areaCodeDic {
    if (_areaCodeDic) return _areaCodeDic;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GlobalAreaCode" ofType:@".plist"];
    _areaCodeDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    return _areaCodeDic;
}

// 字母排序
- (NSArray *)sortedArray {
    if (_sortedArray) return _sortedArray;
    NSComparator comparator = ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    };
    NSArray *allKeys = [self.areaCodeDic allKeys];
    NSMutableArray *mutableArray = [[allKeys sortedArrayUsingComparator:comparator] mutableCopy];
    [mutableArray insertObject:[mutableArray lastObject] atIndex:0];
    [mutableArray removeLastObject];
    _sortedArray = [mutableArray copy];
    return _sortedArray;
}

// 列表视图
- (void)generateTableView {
//    CGRect frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H);
//    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    _tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.dataSource = self;
//    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.areaCodeDic objectForKey:self.sortedArray[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sortedArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kAreaCodeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"kAreaCodeCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    NSDictionary *itemDic = [self.areaCodeDic objectForKey:self.sortedArray[indexPath.section]][indexPath.row];
    cell.textLabel.text = itemDic[@"country"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@", itemDic[@"code"]];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortedArray;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemDic = [self.areaCodeDic objectForKey:self.sortedArray[indexPath.section]][indexPath.row];
    if (self.areaCodeBlock) self.areaCodeBlock(itemDic[@"code"]);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
