//
//  UUSearchPatternController.m
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchPatternController.h"

#import "UUSearchPatternInputView.h"
#import "UUSearchPatternFlowLayout.h"
#import "UUSearchPatternKeyCell.h"
#import "UUSearchPatternHeaderView.h"

#import "UUProgressHUD.h"

@interface UUSearchPatternController ()
<
    UUSearchPatternInputViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UUSearchPatternHeaderViewDelegate
>
@property (nonatomic, strong) UUSearchPatternInputView *searchView; // 搜索框视图
@property (nonatomic, strong) UICollectionView *collectionView;     // 搜索历史视图
@property (nonatomic, strong) NSUserDefaults *historyDefaults;      // 搜索历史存储类
@property (nonatomic, strong) NSMutableArray *historyKeyArray;      // 历史关键字数组
@property (nonatomic, strong) NSMutableDictionary *historyWidthDic; // 历史关键字宽度数组
@property (nonatomic, strong) NSString *patternSearchKey;           // 搜索关键字
@end

@implementation UUSearchPatternController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateNavigatorSearchViews];
    [self generateSearchCollectionView];
}

// 开始搜索
- (void)beginToSearch:(NSString *)key {}

// 清空搜索关键字
- (void)cleanToSearch {}

#pragma mark - Getter

// 搜索历史存储类
- (NSUserDefaults *)historyDefaults {
    if (_historyDefaults) return _historyDefaults;
    NSString *className = NSStringFromClass([self class]);
    NSString *suiteName = [NSString stringWithFormat:@"%@UserDefault", className];
    _historyDefaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
    return _historyDefaults;
}

// 历史关键字数组
- (NSMutableArray *)historyKeyArray {
    if (_historyKeyArray) return _historyKeyArray;
    _historyKeyArray = [[self.historyDefaults objectForKey:@"AllHistoryKeys"] mutableCopy];
    if (!_historyKeyArray) _historyKeyArray = [NSMutableArray array];
    return _historyKeyArray;
}

// 历史关键字宽度数组
- (NSMutableDictionary *)historyWidthDic {
    if (_historyWidthDic) return _historyWidthDic;
    _historyWidthDic = [[self.historyDefaults dictionaryRepresentation] mutableCopy];
    if (!_historyWidthDic) _historyWidthDic = [NSMutableDictionary dictionary];
    return _historyWidthDic;
}

#pragma mark - Subviews

// 生成导航栏视图
- (void)generateNavigatorSearchViews {
    // 搜索框
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - 75 * 2, 32);
    _searchView = [[UUSearchPatternInputView alloc] initWithFrame:rect];
    _searchView.delegate = self;
    self.navigationItem.titleView = _searchView;
    
    // 搜索按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(clickSearchItem)];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: FONT(16)};
    [rightItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [rightItem setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightItem;
}

// 生成搜索历史视图
- (void)generateSearchCollectionView {
    UUSearchPatternFlowLayout *flowLayout = [[UUSearchPatternFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 30;
    flowLayout.minimumLineSpacing = 30;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 60);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[UUSearchPatternKeyCell class] forCellWithReuseIdentifier:@"SearchPatternKeyCell"];
    [_collectionView registerClass:[UUSearchPatternHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchPatternHeaderView"];
}

#pragma mark - Respond

// 点击搜索按钮
- (void)clickSearchItem {
    if (self.searchView.textField.isEditing) {
        [self.searchView.textField endEditing:YES];
    }
    if (self.patternSearchKey.length > 0) {
        [self storeSearchHistory:self.patternSearchKey];
        [self.collectionView reloadData];
    } else {
        [UUProgressHUD showText:@"请输入搜索关键字"];
    }
    [self beginToSearch:self.patternSearchKey];
}

#pragma mark - UUSearchPatternInputViewDelegate

- (void)searchView:(UUSearchPatternInputView *)view searchKey:(NSString *)searchKey {
    self.patternSearchKey = searchKey;
}

- (void)searchViewDidClearSearchKey:(UUSearchPatternInputView *)view {
    [self cleanToSearch];
}

- (void)searchViewKeyboardDidReturn:(UUSearchPatternInputView *)view {
    [self clickSearchItem];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyKeyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UUSearchPatternKeyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchPatternKeyCell" forIndexPath:indexPath];
    cell.contentKey = self.historyKeyArray[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UUSearchPatternHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SearchPatternHeaderView" forIndexPath:indexPath];
    view.delegte = self;
    return view;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.patternSearchKey = self.historyKeyArray[indexPath.item];
    self.searchView.textField.text = self.patternSearchKey;
    [self beginToSearch:self.patternSearchKey];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.historyKeyArray[indexPath.item];
    CGFloat width = [self.historyWidthDic[key] floatValue];
    return CGSizeMake(width, 30);
}

#pragma mark - UUSearchPatternHeaderViewDelegate

- (void)headerViewDidClickDeleteButton:(UUSearchPatternHeaderView *)view {
    [self deleteSearchHistory];
    [self.collectionView reloadData];
}

#pragma mark - Store

// 存储搜索历史
- (void)storeSearchHistory:(NSString *)searchKey {
    if (searchKey == nil || searchKey.length == 0) return;
    if ([self.historyKeyArray containsObject:searchKey]) return;
    [self.historyKeyArray addObject:searchKey];
    [self.historyDefaults setObject:self.historyKeyArray forKey:@"AllHistoryKeys"];
    CGFloat keyWidth = [searchKey boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - 11, SCREEN_HEIGHT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                                    context:nil].size.width;
    [self.historyWidthDic setObject:@(keyWidth + 6) forKey:searchKey];
    [self.historyDefaults setObject:@(keyWidth + 6) forKey:searchKey];
}

// 清除搜索历史
- (void)deleteSearchHistory {
    NSDictionary *historyDic = [self.historyDefaults dictionaryRepresentation];
    for (NSString *key in historyDic) {
        [self.historyDefaults removeObjectForKey:key];
    }
    [self.historyKeyArray removeAllObjects];
}

@end
