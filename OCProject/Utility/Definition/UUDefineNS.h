//
//  UUDefineNS.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#ifndef UUDefineNS_h
#define UUDefineNS_h

// 打印信息及其所在类、方法和行号
#ifdef DEBUG
#define UULog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define UULog(...)
#endif

#pragma mark - Vendor Key

// 极光

// 个推
#define kGetuiAppId     @""
#define kGetuiAppKey    @""
#define kGetuiAppSecret @""

// 百度

// 友盟

// 支付宝

// 微信

// QQ

// 微博


#pragma mark - Constant Key

// 是否第一次登陆
#define kIsFirstLaunch      @"isFirstLaunch"

#endif /* UUDefineNS_h */
