//
//  UUNetWorkManager.m
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNetWorkManager.h"
#import "UUDeviceCheck.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>

@interface UUNetWorkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@property (nonatomic, strong) NSString *userToken;
@end

@implementation UUNetWorkManager

+ (instancetype)shareManager {
    static UUNetWorkManager *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[UUNetWorkManager alloc] init];
    });
    return networkManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _afManager = [AFHTTPSessionManager manager];
        [self commonInitialize];
    }
    return self;
}

#pragma mark - Initialization

// 初始化
- (void)commonInitialize {
    NSURL *url = [NSURL URLWithString:NET_URL_BASE];
    [self.afManager setValue:url forKey:@"_baseURL"];

    [self configureRequestSerializer];

    NSMutableSet *mutableSet = [self.afManager.responseSerializer.acceptableContentTypes mutableCopy];
    [mutableSet addObject:@"text/html"];
    [mutableSet addObject:@"text/xml"];
    [mutableSet addObject:@"text/plain"];
    self.afManager.responseSerializer.acceptableContentTypes = [mutableSet copy];

    [self startNetworkReachabilityMonitoring];
}

// 配置请求序列化属性
- (void)configureRequestSerializer {
    self.afManager.requestSerializer.timeoutInterval = 20.f;
    NSString *userAgent = [self userAgentForRequestHeader];
    [self.afManager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
}

// 拼接请求的header的User-Agent
- (NSString *)userAgentForRequestHeader {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = info[@"CFBundleDisplayName"];
    NSString *appVersion = info[@"CFBundleShortVersionString"];
    NSString *platform = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceName = [UUDeviceCheck deviceName];
    NSString *agentString = [NSString stringWithFormat:@"%@/%@(%@;%@;%@)",
                             appName, appVersion, platform, systemVersion, deviceName];
    NSCharacterSet * set = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [agentString stringByAddingPercentEncodingWithAllowedCharacters:set];
}

// 网络情况监听
- (void)startNetworkReachabilityMonitoring {
    //当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [self.afManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"Network - 未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"Network - 网络未连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"Network - WiFi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"Network - 2G、3G、4G");
                break;
        }
    }];
    [self.afManager.reachabilityManager startMonitoring];
    
    //网络活动发生变化时,会发送下方key 的通知,可以在通知中心中添加检测
    //AFNetworkingReachabilityDidChangeNotification
}

#pragma mark - Setter Configure

// 设置网络请求baseURL
+ (void)resetSessionManagerBaseURL:(NSString *)baseURLString {
    if (!baseURLString) return;
    NSURL *url = [NSURL URLWithString:baseURLString];
    [[UUNetWorkManager shareManager].afManager setValue:url forKey:@"_baseURL"];
}

#pragma mark - Request

// get请求
+ (void)GET:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[UUNetWorkManager shareManager] taskWithMethod:@"GET" path:path param:param config:config success:success failure:failure];
}

// post请求
+ (void)POST:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[UUNetWorkManager shareManager] taskWithMethod:@"POST" path:path param:param config:config success:success failure:failure];
}

// put请求
+ (void)PUT:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[UUNetWorkManager shareManager] taskWithMethod:@"PUT" path:path param:param config:config success:success failure:failure];
}

// patch请求
+ (void)PATCH:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[UUNetWorkManager shareManager] taskWithMethod:@"PATCH" path:path param:param config:config success:success failure:failure];
}

// delete请求
+ (void)DELETE:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    [[UUNetWorkManager shareManager] taskWithMethod:@"DELETE" path:path param:param config:config success:success failure:failure];
}

// 上传文件POST网络请求
+ (void)UPLOAD:(NSString *)path param:(NSDictionary *)param content:(NSDictionary *)content config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    UUNetWorkManager *manager = [UUNetWorkManager shareManager];
    [manager resetPath:&path parameters:&param];
    
    if (config[UUNetworkConfigSerializer]) { // 参数序列化方式
        [manager handleSerializerConfigure:config];
    }
    // 添加token到请求头
    [manager handleRequestHeaderConfigure:config];
    
    NSURLSessionTask *task = [manager.afManager POST:path parameters:param headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [self handleContent:content formData:formData];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [manager handleSuccess:responseObject task:task block:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [manager handleFailure:error task:task block:failure];
    }];
    [manager querySameRequest:task cancelNew:YES];
}

// 网络请求方法
- (NSURLSessionDataTask *)taskWithMethod:(NSString *)method path:(NSString *)path param:(NSDictionary *)param config:(NSDictionary<UUNetworkConfigKey,id> *)config success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [self resetPath:&path parameters:&param];
    
    if (config[UUNetworkConfigSerializer]) { // 参数序列化方式
        [self handleSerializerConfigure:config];
    }
    // 添加token到请求头
    [self handleRequestHeaderConfigure:config];
    
    NSURLSessionDataTask *task;
    task = [self.afManager dataTaskWithHTTPMethod:method URLString:path parameters:param headers:nil uploadProgress:nil downloadProgress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject task:task block:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:error task:task block:failure];
    }];
    [task resume];
    [self querySameRequest:task cancelNew:YES];
    return task;
}

#pragma mark - Before Request

// 重置请求接口URL及参数列表
- (void)resetPath:(NSString **)path parameters:(NSDictionary **)param {
    NSAssert(*path, @"地址不能为空");

    NSString *originPath = *path;
    NSDictionary *originParam = *param;
    NSString *fixedPath = @"materialMall/management_interface";
    NSString *functionName;

    NSMutableArray *originPaths = (NSMutableArray*)[originPath componentsSeparatedByString:@"/"];
    NSMutableArray *fixedPaths = (NSMutableArray *)[fixedPath componentsSeparatedByString:@"/"];

    if (originPaths.count > 1) {
        functionName = [originPaths.lastObject copy];
        [originPaths removeLastObject];
        if (![originPaths containsObject:fixedPaths.lastObject]) {
            [originPaths addObject:fixedPaths.lastObject];
        }
        *path = [originPaths componentsJoinedByString:@"/"];
    }else{
        functionName = originPath;
        *path = fixedPath;
    }

    NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
    [newParam setValue:functionName forKey:@"function_name"];
    [newParam setValue:originParam forKey:@"params"];

    if ([NSJSONSerialization isValidJSONObject:newParam]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:newParam
                                                       options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        *param = @{@"json_msg":paramStr};
    }
}

// 参数序列化方式设置
- (void)handleSerializerConfigure:(NSDictionary<UUNetworkConfigKey,id> *)config {
    NSString *serializer = config[UUNetworkConfigSerializer];
    if ([serializer isEqualToString:@"json"]) {
        self.afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else if ([serializer isEqualToString:@"plist"]) {
        self.afManager.requestSerializer = [AFPropertyListRequestSerializer serializer];
    } else {
        if ([self.afManager.requestSerializer isMemberOfClass:[AFHTTPRequestSerializer class]]) return;
        self.afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    [self configureRequestSerializer];
}

// 请求头中添加token
- (void)handleRequestHeaderConfigure:(NSDictionary<UUNetworkConfigKey,id> *)config {
    if (self.userToken.length == 0) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TOKEN"];
        if (token.length > 0) self.userToken = token;
    }
    if (self.userToken.length > 0) {
        [self.afManager.requestSerializer setValue:self.userToken forHTTPHeaderField:@"USER_TOKEN"];
    }
    NSString *accessToken = config[UUNetworkConfigAccessToken];
    if (accessToken) {
        [self.afManager.requestSerializer setValue:accessToken forHTTPHeaderField:@"ACCESS_TOKEN"];
    }
}

// 处理上传文件的添加
+ (void)handleContent:(NSDictionary *)content formData:(id<AFMultipartFormData>)formData {
    if (!content || content.count == 0) return ;

    NSArray *array = content.allKeys;
    id firstObject = content.allValues.firstObject; // 默认内容字典里面每个key都是name，与value值一一对应
    BOOL isArray = NO;
    if ([firstObject isKindOfClass:[NSArray class]]) { // 内容字典value值为数组时，按字典仅有一个值处理
        array = (NSArray *)firstObject;
        isArray = YES;
    }

    for (NSInteger i = 0; i < array.count; i ++) {
        id key = nil, value = nil;
        if (isArray) {
            value = [array objectAtIndex:i];
        } else {
            key = [array objectAtIndex:i];
            value = [content objectForKey:key];
        }
        NSString *name = [NSString stringWithFormat:@"%zd", i];

        if ([value isKindOfClass:[UIImage class]]) { // 内容值为图片
            NSData *imageData = UIImageJPEGRepresentation(value, 1);
            NSString *type = @"jpg";
            if (!imageData) {
                imageData = UIImagePNGRepresentation(value);
                type = @"png";
            }
            if (key) {
                NSString *fileName = [NSString stringWithFormat:@"%zd.%@", i, type];
                NSString *mimeType = [NSString stringWithFormat:@"image/%@", type];
                [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:mimeType];
            } else {
                [formData appendPartWithFormData:imageData name:name];
            }
        } else if ([value isKindOfClass:[NSString class]]) { // 内容值为文件地址
            NSURL *fileURL = [NSURL URLWithString:value];
            if ([fileURL isFileURL]) {
                [formData appendPartWithFileURL:fileURL name:name error:nil];
            }
        }else if ([value isKindOfClass:[NSData class]]) { // 内容值为NSData数据
            [formData appendPartWithFormData:value name:name];
        }
    }
}

#pragma mark - After Response

// 处理成功返回结果
- (void)handleSuccess:(id)responseObject task:(NSURLSessionDataTask *)task block:(SuccessBlock)block {
    //  返回头中有token值，则缓存
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSString *token = response.allHeaderFields[@"USER_TOKEN"];
    if (token.length == 0) return;
    self.userToken = token;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"USER_TOKEN"];
    });
    
    // 返回体中的信息处理
    NSString *status = [responseObject objectForKey:@"status"];
    if (status && [status isEqualToString:@"200"]) {
        id data = [responseObject objectForKey:@"data"];
        if (block) block(data);

    } else {
        id message = [responseObject objectForKey:@"message"];
        if ([message isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [message valueForKey:@"msg"];
            NSLog(@"Error 400 = %@", msg);
        } else if ([message isKindOfClass:[NSString class]]) {
            NSLog(@"Error 400 = %@", message);
        } else {
            NSLog(@"Error 400 = %@", message);
        }
        NSDictionary *errorInfo = @{NSDebugDescriptionErrorKey: @"返回 status != 200 错误"};
        NSError *statusErr = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:NSURLErrorBadServerResponse
                                             userInfo:errorInfo];
        if (block) block(statusErr);
    }
}

- (void)handleFailure:(NSError *)error task:(NSURLSessionDataTask *)task block:(FailureBlock)block {
    NSLog(@"-- %@", error);
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -999) {
        return; // 网络请求被取消
    }
    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    NSError *underlyingError = error;
    if (error.userInfo[NSUnderlyingErrorKey]) {
        underlyingError = error.userInfo[NSUnderlyingErrorKey];
    }
    NSData *errorData = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString *tips = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    if (statusCode == 401) {
        NSString *string = tips ?: @"即将退出登陆";
        tips = @"";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:UUNetworkResponseStatusCode401 object:nil userInfo:@{UUNetworkErrorTips: string}];
        });
    } else if (statusCode == 404) {
        tips = @"温馨提示：数据走丢了！";
    } else {
        tips = tips ?: @"未找到错误信息";
    }
    NSMutableDictionary *userInfo = [underlyingError.userInfo mutableCopy];
    [userInfo setObject:tips forKey:UUNetworkErrorTips];
    [userInfo setObject:@(statusCode) forKey:UUNetworkErrorCode];
    if (block) block([userInfo copy]);
}

#pragma mark - Utility

// 查询当前正在运行的task，停止相同的task
- (void)querySameRequest:(NSURLSessionTask *)newTask cancelNew:(BOOL)cancelNew {
    NSMutableArray *oldTasks = [[UUNetWorkManager shareManager].afManager.tasks mutableCopy];
    if (oldTasks.count > 0) {
        [oldTasks removeLastObject];
    } else {
        return;
    }
    for (NSURLSessionTask *oldTask in oldTasks) {
        if ([self compareEqualRequest:newTask.originalRequest to:oldTask.originalRequest]) {
            cancelNew ? [newTask cancel] : [oldTask cancel];
            if (cancelNew) break;
        }
    }
}

// 比较两个NSURLRequest是否相等
- (BOOL)compareEqualRequest:(NSURLRequest *)compare to:(NSURLRequest *)toValue {
    BOOL sameMethod = [compare.HTTPMethod isEqualToString:toValue.HTTPMethod];
    BOOL sameURL = [compare.URL.absoluteString isEqualToString:toValue.URL.absoluteString];
    if (sameMethod && sameURL) {
        if ([compare.HTTPMethod isEqualToString:@"GET"] ||
            [compare.HTTPMethod isEqualToString:@"HEAD"] ||
            [compare.HTTPMethod isEqualToString:@"DELETE"]) {
            return YES;
        } else if ([compare.HTTPBody isEqualToData:toValue.HTTPBody]) {
            return YES;
        }
    }
    return NO;
}


@end
