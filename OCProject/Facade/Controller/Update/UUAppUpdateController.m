//
//  UUAppUpdateController.m
//  OCProject
//
//  Created by Pan on 2020/9/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAppUpdateController.h"
#import "UIColor+UU.h"
#import <Masonry/Masonry.h>

@interface UUAppUpdateController ()

@property (nonatomic, strong) UIView *bezelView;      // 框架视图
@property (nonatomic, strong) UIButton *updateButton; // 更新按钮
@property (nonatomic, strong) UIButton *ignoreButton; // 忽略按钮
@property (nonatomic, strong) UIButton *closeButton;  // 关闭按钮
@property (nonatomic, strong) NSDictionary *result;   // 获取的数据
@end

@implementation UUAppUpdateController

static BOOL versionHasChecked = NO; // 是否以检测过版本
static NSString *appIgnoreVersion = @"kAppIgnoreVersion"; // 版本号标识，用户忽略该版本升级

// 检查版本更新
+ (void)checkForNewVersion {
    if (versionHasChecked) return;
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *versionNum = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appIgnoreVersion];
    if ([ignoreVersion compare:versionNum] == NSOrderedDescending) {
        versionNum = ignoreVersion;
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:appIgnoreVersion];
    }
    NSDictionary *params = @{@"version": versionNum, @"systemType": @"1", @"appType": @"1", @"ACCESS_TOKEN": @""};
    
    [UUNetWorkManager GET:@"" param:params config:nil success:^(id  _Nullable result) {
        versionHasChecked = YES;
        if (!result || ![result isKindOfClass:[NSDictionary class]]) return ;
        if (![result[@"popout"] boolValue]) return;
        UUAppUpdateController *update = [[UUAppUpdateController alloc] init];
        update.result = result;
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:update animated:YES completion:nil];
    } failure:^(NSDictionary<NSErrorUserInfoKey,id> * _Nonnull userInfo) {
        
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *backColor = [UIColor colorWithHexString:@"#030303"];
    self.view.backgroundColor = [backColor colorWithAlphaComponent:0.5];
    
    [self generateSubviews];
    if (![self.result[@"forceUpdate"] boolValue]) {
        self.ignoreButton.hidden = NO;
        self.closeButton.hidden = NO;
    }
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 框架视图
    _bezelView = [[UIView alloc] init];
    _bezelView.backgroundColor = [UIColor whiteColor];
    _bezelView.layer.cornerRadius = 11.0;
    [self.view addSubview:_bezelView];
    [_bezelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    // 头部图标
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.contentMode = UIViewContentModeScaleToFill;
    topImageView.image = [UIImage imageNamed:@"version_upgrade"];
    [self.bezelView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.result[@"versionName"] ?: @"";
    [self.bezelView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
    }];
    
    // 说明标签
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.font = [UIFont systemFontOfSize:15];
    stateLabel.textColor = UIColor.grayColor;
    stateLabel.numberOfLines = 0;
    stateLabel.text = self.result[@"versionDesc"] ?: @"";
    [self.bezelView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    // 更新按钮
    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateButton.backgroundColor = UIColor.blueColor;
    _updateButton.layer.cornerRadius = 20.0;
    _updateButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
    [_updateButton addTarget:self action:@selector(clickUpdateButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bezelView addSubview:_updateButton];
    [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLabel.mas_bottom).mas_offset(50);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_lessThanOrEqualTo(-20);
        make.height.mas_equalTo(40);
    }];
}

// 忽略按钮
- (UIButton *)ignoreButton {
    if (_ignoreButton) return _ignoreButton;
    _ignoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ignoreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_ignoreButton setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    [_ignoreButton setTitle:@"忽略本次升级" forState:UIControlStateNormal];
    [_ignoreButton addTarget:self action:@selector(clickIgnoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bezelView addSubview:_ignoreButton];
    [_ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateButton.mas_bottom).mas_offset(12);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-12);
    }];
    return _ignoreButton;
}

// 关闭按钮
- (UIButton *)closeButton {
    if (_closeButton) return _closeButton;
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bezelView.mas_top).mas_offset(-30);
        make.right.equalTo(self.bezelView.mas_right);
        make.width.height.mas_equalTo(20);
    }];
    return _closeButton;
}

#pragma mark - Respond

// 点击更新按钮
- (void)clickUpdateButton {
    NSString *appStoreUrl = self.result[@"outLink"];
    NSURL *url = [NSURL URLWithString:appStoreUrl];
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    if (![self.result[@"forceUpdate"] boolValue]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 点击忽略按钮
- (void)clickIgnoreButton {
    NSString *ignoreVersion = [NSString stringWithFormat:@"%@", (self.result[@"version"] ?: @"")];
    [[NSUserDefaults standardUserDefaults] setObject:ignoreVersion forKey:appIgnoreVersion  ];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击关闭按钮
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
