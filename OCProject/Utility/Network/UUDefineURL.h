//
//  UUDefineURL.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#ifndef UUDefineURL_h
#define UUDefineURL_h

#define URLSwitch 1 // 0 线下，1 线上

#ifdef DEBUG
#if URLSwitch
#define kAppBaseURL @"https://baseobject.com"
#else
#define kAppBaseURL @"http://test.baseobject.com/"
#endif
#else
#define kAppBaseURL @"https://baseobject.com"
#endif

// 网络连接状态
#define kNetworkStatus         @"NetworkStatus"
#define kNetworkStatusWiFi     @"NetworkStatusWiFi"
#define kNetworkStatusWWAN     @"NetworkStatusWWAN"
#define kNetworkStatusNone     @"NetworkStatusNone"
#define kNetworkStatusUnknown  @"NetworkStatusUnknown"


// 网络请求是否成功时返回的结果
#define kSuccessResult @"0000"
#define kErrorResult   @"0001"
#define kExistResult   @"0006"
#define kNullResult    @"(null)"


#pragma mark - App Version Check

// 版本号相关
#define kAppStoreVersionURL @"http://itunes.apple.com/cn/lookup?id=(根据appID修改)1036093539"
#define kGoToAppStoreURL    @"https://itunes.apple.com/cn/app/ming-yi/id(根据appID修改)1036093539?mt=8&uo=4"

/*
 * 启动广告
 */
// 获取广告图片信息
#define kGetAdInfoURL @"get_ad_info"


#endif /* UUDefineURL_h */
