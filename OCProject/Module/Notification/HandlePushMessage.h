//
//  HandlePushMessage.h
//  MingYi
//
//  Created by NTIT on 2017/3/7.
//  Copyright © 2017年 SHNTIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandlePushMessage : NSObject

// 单例
+ (instancetype)shareHandler;

// 处理远程推送的通知
+ (void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo;
// 处理本地推送通知
+ (void)handleLocalNotificationMessage:(NSDictionary *)info;
@end
