//
//  UUNetworkSwitch.m
//  OCProject
//
//  Created by Pan on 2020/7/29.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNetworkSwitch.h"
#import "UUNetWorkManager.h"

@implementation UUNetworkSwitch

static BOOL ipAddressAcquired = NO;     // IP地址是否获取过
static NSTimeInterval waitInterval = 2; // 网络请求最长时间

// 检查并获取IP地址
+ (void)checkForAppStoreReview {
    if (ipAddressAcquired) return;
    
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *reviewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:NET_REVIEW_VERSION];
    NSString *reviewState = [[NSUserDefaults standardUserDefaults] objectForKey:NET_REVIEW_STATE];
    
    if (![currentVersion isEqualToString:reviewVersion]) { // 此条件必须第一个判断
        [self acquireIPAddress];
    } else if ([reviewState isEqualToString:@"pro"]) { // 生产环境
        ipAddressAcquired = YES;
        NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:NET_IP_ADDRESS];
        apiUrlString = info[@"apiUrl"] ?: NET_URL_BASE;
        imgUrlString = info[@"imgUrl"] ?: NET_URL_IMG;
        shareUrlString = info[@"shareUrl"] ?: NET_URL_SHARE;
        NSString *urlString = [NSString stringWithFormat:@"%@/api/app/", apiUrlString];
        [UUNetWorkManager resetSessionManagerBaseURL:urlString];
    } else {
        [self acquireIPAddress];
    }
}

// 请求获取IP地址信息
+ (void)acquireIPAddress {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *versionNum = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@?version=%@", HTTP_IOS_BASE_URL, versionNum];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = waitInterval;
    waitInterval = 0.5;
    [request setValue:NET_ACCESS_KEY forHTTPHeaderField:@"ACCESS_TOKEN"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSError *jsonErr = nil;
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
            if (jsonErr) {
                NSLog(@"%@", jsonErr);
            } else {
                ipAddressAcquired = YES;
                apiUrlString = info[@"apiUrl"] ?: NET_URL_BASE;
                imgUrlString = info[@"imgUrl"] ?: NET_URL_IMG;
                shareUrlString = info[@"shareUrl"] ?: NET_URL_SHARE;
                NSString *urlString = [NSString stringWithFormat:@"%@/api/app/", apiUrlString];
                [UUNetWorkManager resetSessionManagerBaseURL:urlString];
                NSString *state = info[@"env"] ?: @"test";
                if ([state isEqualToString:@"pro"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:info forKey:NET_IP_ADDRESS];
                }
                [[NSUserDefaults standardUserDefaults] setObject:state forKey:NET_REVIEW_STATE];
                [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:NET_REVIEW_VERSION];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end
