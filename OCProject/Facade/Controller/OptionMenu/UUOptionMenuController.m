//
//  UUOptionMenuController.m
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUOptionMenuController.h"
#import "UUMenuSegmentedView.h"
#import "UUMenuMultiOptionView.h"
#import "UIView+UU.h"

#define userDefaultsHot  @"HotTitleInMenu"
#define userDefaultsNew  @"NewTitleInMenu"

@interface UUOptionMenuController ()
<
    UUMenuSegmentedViewDelegate,
    UUMenuMultiOptionViewDelegate
>
@property (strong, nonatomic) UUMenuSegmentedView *segmentedView;
@property (assign, nonatomic) NSInteger selecteItem;
@end

@implementation UUOptionMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupMenuData];
    [self setupSubview];
    self.selecteItem = 0;
}

/// 设置数据
- (void)setupMenuData {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *upNamePlist = [documentPath stringByAppendingPathComponent:@"upName.plist"];
    NSString *downNamePlist = [documentPath stringByAppendingPathComponent:@"downName.plist"];
    
    NSArray *upNames = @[@"头条", @"精选", @"娱乐", @"体育", @"网易号", @"上海", @"视频", @"财经", @"科技", @"汽车", @"时尚", @"图片", @"直播", @"热点", @"跟帖", @"轻松一刻", @"段子", @"独家", @"游戏", @"军事", @"历史", @"家居", @"健康", @"哒哒趣闻", @"彩票", @"美女", @"读书", @"云课堂"];
    NSArray *downNames = @[@"NBA", @"社会", @"影视歌", @"股票", @"中国足球", @"国际足球", @"CBA", @"跑步", @"手机", @"数码", @"智能", @"态度公开课", @"房产", @"酒香", @"教育", @"亲子", @"暴雪游戏", @"态度营销", @"情感", @"艺术", @"海外", @"博客", @"论坛", @"漫画", @"萌宠", @"政务"];
    [upNames writeToFile:upNamePlist atomically:YES];
    [downNames writeToFile:downNamePlist atomically:YES];
    
    NSArray *hots = @[@"上海", @"视频"];
    NSArray *news = @[@"网易号"];
    [[NSUserDefaults standardUserDefaults] setObject:hots forKey:userDefaultsHot];
    [[NSUserDefaults standardUserDefaults] setObject:news forKey:userDefaultsNew];
}

/// 设置子视图
- (void)setupSubview {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *upNamePlist = [documentPath stringByAppendingPathComponent:@"upName.plist"];
    NSArray *titleArray = [NSArray arrayWithContentsOfFile:upNamePlist];
    
    CGRect rect = CGRectMake(0, NAVIGATOR_H, self.view.width, 30);
    UUMenuSegmentedView *segmentedView = [[UUMenuSegmentedView alloc] initWithFrame:rect withTitles:titleArray];
    segmentedView.delegate = self;
    self.segmentedView = segmentedView;
    [self.view addSubview:segmentedView];
}

#pragma mark - UUMenuSegmentedViewDelegate

- (void)segmentedView:(UUMenuSegmentedView *)segmentedView tapTitleAtIndex:(NSInteger)index {
    self.selecteItem = index;
}

- (void)segmentedView:(UUMenuSegmentedView *)segmentedView didClickButton:(UIButton *)button {
    CGRect rect = CGRectMake(0, NAVIGATOR_H, self.view.width, self.view.height - NAVIGATOR_H + 1);
    UUMenuMultiOptionView *menu = [[UUMenuMultiOptionView alloc] initWithFrame:rect];
    menu.delegate = self;
    menu.itemRow = self.selecteItem;
    [self.view addSubview:menu];
}

#pragma mark - UUMenuMultiOptionViewDelegate

- (void)menuOptionsDidChangedToTitles:(NSArray *)titles selectedIndex:(NSInteger)index {
    [self.segmentedView resetTitleArray:titles];
    [self.segmentedView titleShouldSelectedAtIndex:index];
    self.selecteItem = index;
    NSLog(@"--%@---%ld", titles[index], index);
}

@end
