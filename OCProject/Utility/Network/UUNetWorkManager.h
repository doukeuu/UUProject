//
//  UUNetWorkManager.h
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 成功回调
typedef void (^SuccessBlock)(id _Nullable result);
/// 失败回调
typedef void (^FailureBlock)(NSDictionary<NSErrorUserInfoKey, id> *userInfo);


@interface UUNetWorkManager : NSObject

+ (instancetype)shareManager;
+ (instancetype)new  NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 设置网络请求baseURL
+ (void)resetSessionManagerBaseURL:(NSString *)baseURLString;

/// get请求
+ (void)GET:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure;

/// post请求
+ (void)POST:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure;

/// put请求
+ (void)PUT:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure;

/// patch请求
+ (void)PATCH:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure;

/// delete请求
+ (void)DELETE:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 上传文件POST网络请求
/// @param path 请求接口
/// @param param 参数字典
/// @param content 上传的内容字典，key作为name时，value只能是单个的image/data/filePath；
/// key不作为name时，value可以为数组，数组内容可以为image/data/filePath其中的一类
/// @param config 配置
/// @param success 成功回调
/// @param failure 失败回调
+ (void)UPLOAD:(NSString *)path param:(NSDictionary *)param content:(NSDictionary *)content
        config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 网络请求方法
/// @param method 方法名
/// @param path 请求接口
/// @param param 参数字典
/// @param config 方法配置
/// @param success 成功回调
/// @param failure 失败回调
- (nullable NSURLSessionDataTask *)taskWithMethod:(NSString *)method
                                             path:(NSString *)path
                                            param:(nullable NSDictionary *)param
                                           config:(nullable NSDictionary<UUNetworkConfigKey, id> *)config
                                          success:(nullable SuccessBlock)success
                                          failure:(nullable FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
