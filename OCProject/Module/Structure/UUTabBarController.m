//
//  UUTabBarController.m
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUTabBarController.h"
#import "UUNavigationController.h"

#import "UUBulgeTabBar.h"

@interface UUTabBarController () <UITabBarControllerDelegate>

@end

@implementation UUTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self generateTabBar];
    [self generateChildController];
    [self configureControllers];
}

// 设置视图控制器
- (void)configureControllers{
    NSArray *names = @[@"MYHomePageController", @"MYMoreFunctionController", @"MYUserPageController"];
    NSArray *items = @[@[@"明医", @"发现", @"用户"],
                       @[@"home_gray", @"found_gray", @"user_gray"],
                       @[@"home_green", @"found_green", @"user_green"]];
    
    NSMutableArray *navigations = [NSMutableArray arrayWithCapacity:names.count];
    __weak typeof(self) weakSelf = self;
    [names enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Class controllerClass = NSClassFromString(obj);
        if (controllerClass) {
            
            UIViewController *controller = [[controllerClass alloc] init];
            UITabBarItem *item = [weakSelf itemWithTitle:items[0][idx] imageName:items[1][idx] selectedImageName:items[2][idx]];
            
            UUNavigationController *navigation = [[UUNavigationController alloc] initWithRootViewController:controller];
            navigation.style = UUNavigationStyleNormal;
            navigation.tabBarItem = item;
            [navigations addObject:navigation];
            [controller.view layoutIfNeeded];
        }
    }];
    self.viewControllers = navigations;
}

// 设置每个TabBarItem
- (UITabBarItem *)itemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    
    item.titlePositionAdjustment = UIOffsetMake(0, -2);
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    return item;
}

// 配置自定义TabBar
- (void)generateTabBar {
    UUBulgeTabBar *bulge = [[UUBulgeTabBar alloc] init];
    bulge.backgroundImage = [UIImage imageNamed:@"sy_tab_bj_png"];
    [self setValue:bulge forKey:@"tabBar"];
}

// 配置子视图
- (void)generateChildController {
    
    NSArray *imageArray = @[@"sy_budh_zxwdj_icon.png",
                            @"sy_budh_zgswdj_icon.png",
                            @"sy_tab_wzj_icon.png",
                            @"sy_budh_ygjwdj_icon.png",
                            @"sy_budh_wdjwdj_icon.png"];
    
    NSArray *selectArray = @[@"sy_budh_zxjdj_icon.png",
                             @"sy_budh_zgsdj_icon.png",
                             @"sy_tab_zjwd_mr_icon.png",
                             @"sy_budh_ygjdj_icon.png",
                             @"sy_budh_wdjdj_icon.png"];
    NSArray *titleArray;
    NSArray *classNames;
    NSString *isAdopted = @""; // [StoreDefaults objectForKey:kAppHasAdopted];
    if ([isAdopted isEqualToString:@"0"]) { // 审核时
        titleArray = @[@"装修",@"效果图",@"专家问答",@"优管家",@"我的"];
        classNames = @[@"DecorationController",
                       @"EffectDiagramController",
                       @"ExpertQAController",
                       @"HouseKeeperController",
                       @"MineController"];
    } else {                               // 已通过
        titleArray = @[@"装修",@"找公司",@"专家问答",@"优管家",@"我的"];
        classNames = @[@"DecorationController",
                       @"CompanyFindController",
                       @"ExpertQAController",
                       @"HouseKeeperController",
                       @"MineController"];
    }
    for (NSInteger i = 0; i < titleArray.count; i ++) {
        [self addController:classNames[i] title:titleArray[i] image:imageArray[i] selected:selectArray[i]];
    }
}

// 添加子视图
- (void)addController:(NSString *)vcString title:(NSString *)title image:(NSString *)imageString selected:(NSString *)selectedString {
    
    UIImage *image = [[UIImage imageNamed:imageString] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selected = [[UIImage imageNamed:selectedString] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.image = image;
    item.selectedImage = selected;
    item.title = title;
    
    UIColor *color = [UIColor grayColor];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    NSDictionary *dic = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font};
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    color = [UIColor greenColor];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    NSDictionary *selectDic = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSShadowAttributeName:shadow};
    [item setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    
    Class class = NSClassFromString(vcString);
    UIViewController *controller = (UIViewController *)[[class alloc] init];
    UUNavigationController *navgation = [[UUNavigationController alloc] initWithRootViewController:controller];
    navgation.tabBarItem = item;
    [self addChildViewController:navgation];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
#warning TabBar代理中添加百度点击记录及是否登陆判断
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
