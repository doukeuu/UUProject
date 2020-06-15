//
//  UUNetWorkManager.h
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTTPManagerConfig) {
    HTTPManagerConfigBaseURL,    // 设置网络请求的baseURL
    HTTPManagerConfigShowHUD,    // 显示HUD样式，0 不显示，1 菊花（默认），2 圆形进度
    HTTPManagerConfigEndRefresh, // 停止刷新，0 不停止（默认），1 停止
};

typedef void (^CompleteBlock)(id object, NSError *error);

@interface UUNetWorkManager : NSObject

/// 设置属性，key是HTTPManagerConfig枚举值
+ (void)setConfig:(id)config forKey:(HTTPManagerConfig)key;

/**
 普通网络POST请求
 
 @param path 请求接口
 @param params 参数字典
 @param block 请求结果回调
 */
+ (void)POST:(NSString *)path params:(NSDictionary *)params completeHandler:(void (^)(id object, NSError *error))block;

/**
 上传文件POST网络请求
 
 @param path    请求接口
 @param params  参数字典
 @param content 上传的内容字典，key作为name时，value只能是单个的image/data/filePath；
 key不作为name时，value可以为数组，数组内容可以为image/data/filePath其中的一类
 @param block   请求结果回调
 */
+ (void)UPLOAD:(NSString *)path params:(NSDictionary *)params content:(NSDictionary *)content completeHandler:(void (^)(id object, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
