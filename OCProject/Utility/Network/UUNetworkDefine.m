//
//  UUNetworkDefine.m
//  OCProject
//
//  Created by Pan on 2020/7/29.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNetworkDefine.h"

NSString const * apiUrlString   = NET_URL_BASE;   // 接口IP地址
NSString const * imgUrlString   = NET_URL_IMG;    // 图片IP地址
NSString const * shareUrlString = NET_URL_SHARE;  // 分享IP地址

// NSString 参数序列化类型，包含form、json、plist
UUNetworkConfigKey const UUNetworkConfigSerializer = @"kNetworkConfigSerializer";
// NSString 需要添加到请求头里的token值
UUNetworkConfigKey const UUNetworkConfigAccessToken = @"kNetworkConfigAccessToken";

// 错误的userInfo中的提示信息key
NSErrorUserInfoKey const UUNetworkErrorTips = @"kNetworkErrorTips";
// 错误的userInfo中的错误码key
NSErrorUserInfoKey const UUNetworkErrorCode = @"kNetworkErrorCode";

// 网络请求返回401状态码的通知
NSNotificationName const UUNetworkResponseStatusCode401 = @"kNetworkResponseStatusCode";
