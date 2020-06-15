//
//  RemoteNotificationManager.m
//  MingYi
//
//  Created by NTIT on 2017/5/18.
//  Copyright © 2017年 SHNTIT. All rights reserved.
//

#import "RemoteNotificationManager.h"

#import "HandlePushMessage.h"
//#import "NSObject+SBJson5.h"
//#import "GeTuiSdk.h"
//#import "ExpertManager.h"
//#import "UnionManager.h"
#import <UserNotifications/UserNotifications.h>

@interface RemoteNotificationManager () // <UNUserNotificationCenterDelegate, GeTuiSdkDelegate>

@end

@implementation RemoteNotificationManager

// 注册远程通知
- (void)registerUserNotification {
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
//
//        __weak typeof(self) weakSelf = self;
//        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (!error && granted) { // 用户同意
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[UIApplication sharedApplication] registerForRemoteNotifications];
//                });
//                [weakSelf registerGeTuiSDK];
//            } else {
//                DLog(@"User refuse remote notification");
//            }
//            if (error) DLog(@"iOS 10 remote notification error: %@", error);
//        }];
//    } else {
//        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }
}

- (void)registerGeTuiSDK {
    
//    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
//    [GeTuiSdk resetBadge];
}

+ (void)resetBadge {
//    [GeTuiSdk resetBadge];
}

+ (void)resume {
//    [GeTuiSdk resume];
}

+ (void)setPushModeForOff:(BOOL)offValue {
//    [GeTuiSdk setPushModeForOff:offValue];
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
//    NSString *tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:set];
//    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [GeTuiSdk registerDeviceToken:tokenString]; //向个推服务器注册deviceToken
//    NSLog(@"tokenString : %@", tokenString);
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo {
//    [GeTuiSdk handleRemoteNotification:userInfo]; // 将收到的APNs信息传给个推统计用户有效点击数
}

#pragma mark - iOS 10 UNUserNotificationCenterDelegate

// iOS 10 APP已经接收到“远程”通知(推送) - (App运行在后台，在前台会在个推收到)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    
    if ([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS 10 收到远程通知: %@", content.userInfo);
        [HandlePushMessage handleRemoteNotificationUserInfo:content.userInfo];
    } else {
        NSLog(@"iOS 10 收到本地通知: %@", content.userInfo);
        [HandlePushMessage handleLocalNotificationMessage:content.userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    
    if ([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS 10 响应远程通知: %@", content.userInfo);
//        [GeTuiSdk handleRemoteNotification:content.userInfo];
    } else {
        NSLog(@"iOS 10 响应本地通知: %@", content.userInfo);
    }
    completionHandler();
}

#pragma mark - GeTuiSdkDelegate

// 个推SDK已注册，返回clientId
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    
    NSLog(@"clientId : %@", clientId);
//    USER.clientID = clientId;
//    [USER bindUserIDAndClientIDForServer];
//
//    UNION.clientID = clientId;
//    [UNION bindDoctorIDAndClientIDForServer];
//
//    EXPERT.clientID = clientId;
//    [EXPERT bindExpertIDAndClientIDForServer];
}

// 个推SDK收到透传消息回调(反馈透传消息)
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    NSLog(@"个推透传消息");
//    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
//    NSDictionary *payloadDic = [payloadData JSONValue];
//    [HandlePushMessage handleRemoteNotificationUserInfo:payloadDic];
}

// 个推SDK遇到错误回调，集成步骤发生的任何错误都在这里通知
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@"GexinSdk error : %@", [error localizedDescription]);
}

@end
