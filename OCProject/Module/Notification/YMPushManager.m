//
//  YMPushManager.m
//  YiMaoCustomer
//
//  Created by Pan on 2020/5/14.
//  Copyright © 2020 YiMao. All rights reserved.
//

#import "YMPushManager.h"
//#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>

@interface YMPushManager ()  // <JPUSHRegisterDelegate>

@property (nonatomic, assign) BOOL registered; //
@end

@implementation YMPushManager

+ (instancetype)shareManager {
    static YMPushManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (BOOL)registerSuccess {
    return [YMPushManager shareManager].registered;
}

// 注册远程通知及激光推送服务
+ (void)registerRemoteNotificationAndJPushServiceWithOptions:(NSDictionary *)options {
//    [[NSNotificationCenter defaultCenter] addObserver:[self shareManager]
//                                             selector:@selector(receiveJPushRegisterNotification:)
//                                                 name:kJPFNetworkDidRegisterNotification object:nil];
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if (@available(iOS 12.0, *)) {
//        entity.types = entity.types | JPAuthorizationOptionProvidesAppNotificationSettings;
//    }
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//      // 可以添加自定义 categories
//      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:[self shareManager]];
//    BOOL isProduction = YES;
//#ifdef DEBUG
//    isProduction = NO;
//#endif
//    [JPUSHService setupWithOption:options appKey:@"fd34238ed95e8cbe8faf7bac" channel:@"AppStore" apsForProduction:isProduction];
}

// 注册deviceToken
+ (void)registerDeviceToken:(NSData *)deviceToken {
//    [JPUSHService registerDeviceToken:deviceToken];
}

// 提交收到的APNs消息
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo {
//    [JPUSHService handleRemoteNotification:remoteInfo];
}

// 清除应用角标
+ (void)cleanAppBadgeValue {
//    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// 绑定userId为推送的Alias
+ (void)setAliasWithUserId:(NSString *)userId {
    if (!userId || userId.length == 0) return;
//    [JPUSHService setAlias:userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"---- %zd -- %@ --- %zd ", iResCode, iAlias, seq);
//    } seq:1];
}

// 解绑userId为推送的Alias
+ (void)deleteAliasWithUserId:(NSString *)userId {
    if (!userId || userId.length == 0) return;
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"---- %zd -- %@ -- %zd", iResCode, iAlias, seq);
//    } seq:1];
}

// 极光注册成功通知
- (void)receiveJPushRegisterNotification:(NSNotification *)notification {
    self.registered = YES;
    NSLog(@"--- %s -- %@",  __func__, notification);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//  // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
//    completionHandler(UNNotificationPresentationOptionAlert |
//                      UNNotificationPresentationOptionBadge |
//                      UNNotificationPresentationOptionSound);
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeReceivedNewMessage object:nil];
//}

// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeTransitionToMessage object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeReceivedNewMessage object:nil];
//    });
//
//    completionHandler();  // 系统要求执行这个方法
//}

// iOS 12 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(12.0)){
//  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//    //从通知界面直接进入应用
//  }else{
//    //从通知设置界面进入应用
//  }
//}

@end
