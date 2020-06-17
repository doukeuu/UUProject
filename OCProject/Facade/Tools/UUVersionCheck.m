//
//  UUVersionCheck.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUVersionCheck.h"

#define kAdoptVersion    @"AppAdoptVersion"    // 用于判断是否请求审核状态
#define kPreviousVersion @"AppPreviousVersion" // 存储上一版本号key
#define kAppHasAdopted   @"isappstore"         // 判断应用是否通过审核，0 否，1 是

@interface UUVersionCheck ()

@property (nonatomic, strong) NSString *latestVersion; // 最新版本
@property (nonatomic, strong) NSString *appURLString;  // 下载地址
@property (nonatomic, assign) BOOL updateOptional;     // 更新是否可选
@end

@implementation UUVersionCheck

// 检测是否通过AppStore审核
+ (void)checkForAppStoreAdopt {
    
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAdoptVersion];
    NSString *currentVersion = [self currentVersion];
    if (!previousVersion || ![previousVersion isEqualToString:currentVersion]) {
        [self detectiveAppStoreAdopted];
    }
}

// 是否是更新后第一次打开App
+ (BOOL)isFirstLaunch {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *previousVersion = [defaults objectForKey:kPreviousVersion];
    NSString *currentVersion = [self currentVersion];
    
    if (!previousVersion || ![previousVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:kPreviousVersion];
        return YES;
    }
    return NO;
}

// 当前版本号
+ (NSString *)currentVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info objectForKey:@"CFBundleShortVersionString"];
}

+ (void)configUpdateOptional:(BOOL)isOptional {
    [[UUVersionCheck shareInstance] setUpdateOptional:isOptional];
}

+ (void)checkUpdateWithAppID:(NSString *)appID {
    [[UUVersionCheck shareInstance] acquireLatestVersionWithAppID:appID];
}

+ (void)checkShouldShowAlert {
    [[UUVersionCheck shareInstance] showUpdateAlert];
}

#pragma mark - AppStore Adopt

// 检测AppStore是审核还是通过，来设置对应的界面和状态
+ (void)detectiveAppStoreAdopted {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *urlStr = @"https://api.youjuke.com/materialMall/up_toTwenty_appStore";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
        if (error) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kAppHasAdopted];
            NSLog(@"%@", error);
        } else {
            NSError *jsonErr = nil;
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonErr];
            if (jsonErr) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kAppHasAdopted];
                NSLog(@"%@", jsonErr);
            } else {
                NSString *result = [NSString stringWithFormat:@"%@", [info objectForKey:kAppHasAdopted]];
                if (result.length != 0) [[NSUserDefaults standardUserDefaults] setObject:result forKey:kAppHasAdopted];
                if ([result isEqualToString:@"1"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[self currentVersion] forKey:kAdoptVersion];
                }
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

#pragma mark - Private Method

// 单例
+ (instancetype)shareInstance {
    
    static UUVersionCheck *check = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        check = [[UUVersionCheck alloc] init];
    });
    return check;
}

// 检查最新版本号
- (void)acquireLatestVersionWithAppID:(NSString *)appID {
    
    NSString *appStoreStr = @"https://itunes.apple.com/cn/lookup?id=";
    NSString *appURLStr = [NSString stringWithFormat:@"%@%@", appStoreStr, appID];
    NSURL *appURL = [NSURL URLWithString:appURLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:appURL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
        if (error) {
            NSLog(@"Version Check: %@", error);
            return ;
        }
        NSError *jsonErr = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonErr];
        if (jsonErr) {
            NSLog(@"Version Check JSON: %@", error);
            return ;
        }
        
        NSArray *infoArr = [infoDic objectForKey:@"results"];
        if (infoArr.count == 0) return;
        NSDictionary *releaseInfo = [infoArr firstObject];
        self.latestVersion = [releaseInfo objectForKey:@"version"];
        self.appURLString = [releaseInfo objectForKey:@"trackViewUrl"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showUpdateAlert];
        });
    }];
    [task resume];
}

// 弹出提示框
- (void)showUpdateAlert {
    
    if (!self.latestVersion || self.latestVersion.length == 0) return;
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [info objectForKey:@"CFBundleShortVersionString"];
    if ([localVersion compare:self.latestVersion] != NSOrderedAscending) return;
    
    NSString *appName = [info objectForKey:@"CFBundleDisplayName"];
    NSString *tip = @"新版本发布啦！\n快快更新吧";
    NSString *message = [NSString stringWithFormat:@"%@ %@ %@", appName, self.latestVersion, tip];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"现在升级"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        NSURL *appURL = [NSURL URLWithString:self.appURLString];
        if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
            [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
        }
    }]];
    if (self.updateOptional) {
        [alert addAction:[UIAlertAction actionWithTitle:@"以后再说"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 获取最新版本并提示

// 获取App Store版本号并检查弹出提示
- (void)acquireAndCheckAppStoreVersion {
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *urlString = @"http://itunes.apple.com/cn/lookup?id=1105734770";
        NSURL *versionURL = [NSURL URLWithString:urlString];
        
        NSData *versionData = [NSData dataWithContentsOfURL:versionURL];
        if (!versionData) return ;
        NSDictionary *versionDic = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingAllowFragments error:nil];
        if (!versionDic) return;
        
        NSArray *resultArray = versionDic[@"results"];
        if (resultArray.count == 0) return;
        NSDictionary *infoDic = resultArray.firstObject;
        NSString *appstoreVersion = infoDic[@"version"];
        NSString *appstoreUrl = infoDic[@"trackViewUrl"];
        if (appstoreVersion.length == 0 || appstoreUrl.length == 0) return;
        
        NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
        if ([appstoreVersion compare:currentVersion] != NSOrderedDescending) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
            NSString *message = [NSString stringWithFormat:@"发现新版本(%@)", appstoreVersion];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:appstoreUrl];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }]];
            [controller presentViewController:alert animated:YES completion:nil];
        });
    });
}

@end
