//
//  UUNetworkDefine.h
//  OCProject
//
//  Created by Pan on 2020/7/29.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - URL Address

#define NET_URL_SWITCH 1 // 0 线下，1 线上

#ifdef DEBUG
#if NET_URL_SWITCH
#define NET_URL_BASE   @"https://baseobject.com"
#define NET_URL_IMG    @"https://baseobject.com"
#define NET_URL_SHARE  @"https://baseobject.com"
#else
#define NET_URL_BASE   @"http://test.baseobject.com"
#define NET_URL_IMG    @"http://test.baseobject.com"
#define NET_URL_SHARE  @"http://test.baseobject.com"
#endif
#else
#define NET_URL_BASE   @"https://baseobject.com"
#define NET_URL_IMG    @"https://baseobject.com"
#define NET_URL_SHARE  @"https://baseobject.com"
#endif


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString const * _Nonnull apiUrlString;   // 接口IP地址
FOUNDATION_EXPORT NSString const * _Nonnull imgUrlString;   // 图片IP地址
FOUNDATION_EXPORT NSString const * _Nonnull shareUrlString; // 分享IP地址

/// 拼接基础URL到图片地址
inline static NSString * splicingImgUrlForPath(NSString *string) {
    if ([string containsString:@"http"] || [string containsString:@"HTTP"]) {
        return string;
    }else{
        return [NSString stringWithFormat:@"%@%@", imgUrlString, string];
    }
}

typedef NSString * UUNetworkConfigKey NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT UUNetworkConfigKey const UUNetworkConfigSerializer;  // NSString 参数序列化类型，包含form、json、plist
FOUNDATION_EXPORT UUNetworkConfigKey const UUNetworkConfigAccessToken; // NSString 需要添加到请求头里的token值

FOUNDATION_EXPORT NSErrorUserInfoKey const UUNetworkErrorTips; // 错误的userInfo中的提示信息key
FOUNDATION_EXPORT NSErrorUserInfoKey const UUNetworkErrorCode; // 错误的userInfo中的错误码key

FOUNDATION_EXPORT NSNotificationName const UUNetworkResponseStatusCode401; // 网络请求返回401状态码的通知

NS_ASSUME_NONNULL_END


#pragma mark - Common

#define HTTP_IOS_BASE_URL  [NSString stringWithFormat:@"%@/api/open/ios/getUrl", NET_URL_BASE]           // 获取域名列表
#define HTTP_CHECK_VERSION [NSString stringWithFormat:@"%@/api/open/getNewAppVersion", apiUrlString]     // 检查版本号
#define HTTP_UPLOAD_IMG    [NSString stringWithFormat:@"%@/api/open/common/upload/single", apiUrlString] // 共通单个文件上传


#pragma mark - App Store

// 获取版本号相关信息
#define HTTP_APP_STORE_VERSION  @"http://itunes.apple.com/cn/lookup?id=(根据appID修改)1036093539"
// 跳转到AppStore中对应的App下载界面
#define HTTP_GOTO_APP_STORE     @"https://itunes.apple.com/cn/app/ming-yi/id(根据appID修改)1036093539?mt=8&uo=4"


#pragma mark - Network Definition

// 网络连接状态
#define NET_CONNECT_STATUS   @"NetworkStatus"
#define NET_CONNECT_WIFI     @"NetworkStatusWiFi"
#define NET_CONNECT_WWAN     @"NetworkStatusWWAN"
#define NET_CONNECT_NONE     @"NetworkStatusNone"
#define NET_CONNECT_UNKNOWN  @"NetworkStatusUnknown"


// 网络请求是否成功时返回的结果
#define NET_RESULT_SUCCESS  @"0000"
#define NET_RESULT_ERROR    @"0001"
#define NET_RESULT_EXIST    @"0006"
#define NET_RESULT_NULL     @"(null)"

// 地址切换存储字段
#define NET_REVIEW_VERSION @"kAppReviewVersion" // 版本号标识，用于检查IP地址
#define NET_REVIEW_STATE   @"kAppReviewState"   // app审核标识
#define NET_IP_ADDRESS     @"kAppIpAddress"     // 缓存IP地址字段

// 通用接口传的token值
#define NET_ACCESS_KEY     @"LH6AB08F8G7324H6GBC42D3OC72GLJ25"


#pragma mark - 启动广告

// 获取广告图片信息
#define HTTP_AD_INFO  @"get_ad_info"
