//
//  YMPushManager.h
//  YiMaoCustomer
//
//  Created by Pan on 2020/5/14.
//  Copyright © 2020 YiMao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMPushManager : NSObject

@property (nonatomic, assign, readonly, class) BOOL registerSuccess; ///< 是否注册成功

+ (instancetype)shareManager;
+ (instancetype)new  NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 注册远程通知及激光推送服务
+ (void)registerRemoteNotificationAndJPushServiceWithOptions:(NSDictionary * _Nullable)options;
/// 注册deviceToken
+ (void)registerDeviceToken:(NSData *)deviceToken;
/// 提交收到的APNs消息
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;
/// 清除应用角标
+ (void)cleanAppBadgeValue;

/// 绑定userId为推送的Alias
+ (void)setAliasWithUserId:(NSString *)userId;
/// 解绑userId为推送的Alias
+ (void)deleteAliasWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
