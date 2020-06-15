//
//  RemoteNotificationManager.h
//  MingYi
//
//  Created by NTIT on 2017/5/18.
//  Copyright © 2017年 SHNTIT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RemoteNotificationManager : NSObject

// 注册推送通知
- (void)registerUserNotification;
// 注册个推
- (void)registerGeTuiSDK;

// 以下均为个推的方法加个壳
+ (void)resetBadge;
+ (void)resume;
+ (void)setPushModeForOff:(BOOL)offValue;
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)handleRemoteNotification:(NSDictionary *)userInfo;
@end
