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

/*
 * 启动广告
 */
// 获取广告图片信息
#define kGetAdInfoURL @"get_ad_info"


#endif /* UUDefineURL_h */
