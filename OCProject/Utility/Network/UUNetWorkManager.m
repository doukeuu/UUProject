//
//  UUNetWorkManager.m
//  OCProject
//
//  Created by Pan on 2020/6/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNetWorkManager.h"
#import "UUDeviceCheck.h"
#import "UUToolsUI.h"
#import <AFNetworking.h>

//电池条上网络活动提示(菊花转动)
//#import <AFNetworkActivityIndicatorManager.h>

@interface UUNetWorkManager ()

@property (nonatomic, assign) NSInteger showHUD;    // HUD样式
@property (nonatomic, assign) NSInteger endRefresh; // 停止刷新
@end

@implementation UUNetWorkManager

+ (instancetype)shareManager {

    static UUNetWorkManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[UUNetWorkManager alloc] init];
    });
    return httpManager;
}

+ (AFHTTPSessionManager *)sessionManager {

    static AFHTTPSessionManager *afManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afManager = [AFHTTPSessionManager manager];
        [self configureSessionManager:afManager];
    });
    return afManager;
}

- (instancetype)init {

    if (self = [super init]) {
        _showHUD = 1;
        _endRefresh = 0;
    }
    return self;
}

#pragma mark - Initial Configure

- (void)checkNetwork {
    
    /*
    //当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //能够检测当前网络是wifi,蜂窝网络,没有网
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 网络发生变化时 会触发这里的代码
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogVerbose(@"当前是wifi环境");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DDLogVerbose(@"当前无网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                DDLogVerbose(@"当前网络未知");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogVerbose(@"当前是蜂窝网络");
                break;
            default:
                break;
        }
    }];
    //开启网络检测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //网络活动发生变化时,会发送下方key 的通知,可以在通知中心中添加检测
    //AFNetworkingReachabilityDidChangeNotification
    
     [[NSNotificationCenter defaultCenter] addObserver:nil selector:nil name:AFNetworkingReachabilityDidChangeNotification object:nil];
     */
}

+ (void)configureSessionManager:(AFHTTPSessionManager *)manager {

    NSURL *url = [NSURL URLWithString:kAppBaseURL];
    [manager setValue:url forKey:@"_baseURL"];

    manager.requestSerializer.timeoutInterval = 15.f;
    NSString *userAgent = [self userAgentForRequestHeader];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];

    NSMutableSet *mutableSet = [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [mutableSet addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [mutableSet copy];

    [self networkReachabilityForManager:manager];
}

// 拼接请求的header的User-Agent
+ (NSString *)userAgentForRequestHeader {

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
+ (void)networkReachabilityForManager:(AFHTTPSessionManager *)manager {

    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
//                [PromptHUD showTitle:@"未知网络" inView:UIApplication.sharedApplication.keyWindow];
                NSLog(@"Network - 未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
//                [PromptHUD showTitle:@"网络未连接" inView:UIApplication.sharedApplication.keyWindow];
                NSLog(@"Network - 网络未连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"Network - Wi-Fi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"Network - 2G、3G、4G");
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
}

#pragma mark - Setter Configure

// 公用的设置方法
+ (void)setConfig:(id)config forKey:(HTTPManagerConfig)key {

    switch (key) {
        case HTTPManagerConfigBaseURL:
            [self configSessionManagerBaseURL:config];
            break;
        case HTTPManagerConfigShowHUD:
            [self configShowProgressHUD:config];
            break;
        case HTTPManagerConfigEndRefresh:
            [self configShouldEndRefresh:config];
            break;
    }
}

// 设置网络请求baseURL
+ (void)configSessionManagerBaseURL:(id)config {

    if (!config) return;
    if ([config isKindOfClass:[NSString class]]) {
        if ([config length] == 0) return;
        NSURL *url = [NSURL URLWithString:config];
        [[UUNetWorkManager sessionManager] setValue:url forKey:@"_baseURL"];
    } else if ([config isKindOfClass:[NSURL class]]) {
        if ([config absoluteString].length == 0) return;
        [[UUNetWorkManager sessionManager] setValue:config forKey:@"_baseURL"];
    }
}

// 设置progressHUD显示样式
+ (void)configShowProgressHUD:(id)config {

    if (![config isKindOfClass:[NSNumber class]]  &&
        ![config isKindOfClass:[NSString class]]) return;
    [UUNetWorkManager shareManager].showHUD = [config integerValue];
}

// 设置MJRefresh是否停止刷新
+ (void)configShouldEndRefresh:(id)config {

    if (![config isKindOfClass:[NSNumber class]]  &&
        ![config isKindOfClass:[NSString class]]) return;
    [UUNetWorkManager shareManager].endRefresh = [config integerValue];
}

#pragma mark - POST

+ (void)POST:(NSString *)path params:(NSDictionary *)params completeHandler:(void (^)(id, NSError *))block {

    UIView *progressHUD = [self showProgressHUD];
    [self resetPath:&path parameters:&params];
    
    NSURLSessionTask *task = [[UUNetWorkManager sessionManager] POST:path parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self endScrollViewRefreshing];
        [self handleSuccess:responseObject block:block];
        [self hideProgressHUD:progressHUD];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endScrollViewRefreshing];
        [self handleFailure:error block:block];
        [self hideProgressHUD:progressHUD];
    }];
    [self querySameRequest:task cancelNew:YES];
}

+ (void)UPLOAD:(NSString *)path params:(NSDictionary *)params content:(NSDictionary *)content completeHandler:(void (^)(id, NSError *))block {

    [UUNetWorkManager shareManager].showHUD = 2;
    __block UIView *progressHUD = [self showProgressHUD];
    [self resetPath:&path parameters:&params];
    
    NSURLSessionTask *task = [[UUNetWorkManager sessionManager] POST:path parameters:params headers:@{}
                                      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                          [self handleContent:content formData:formData];
                                      } progress:^(NSProgress * _Nonnull uploadProgress) {
                                          if (progressHUD) {
                                              double total = uploadProgress.totalUnitCount;
                                              double done = uploadProgress.completedUnitCount;
                                              [progressHUD setValue:@(total / done) forKey:@"progress"];
                                          }
                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                          [self handleSuccess:responseObject block:block];
                                          [self hideProgressHUD:progressHUD];
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          [self handleFailure:error block:block];
                                          [self hideProgressHUD:progressHUD];
                                      }];
    [self querySameRequest:task cancelNew:YES];
}

#pragma mark - Handle Block

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

// 处理成功返回结果
+ (void)handleSuccess:(id)responseObject block:(CompleteBlock)block {

    NSString *status = [responseObject objectForKey:@"status"];
    if (status && [status isEqualToString:@"200"]) {
        id data = [responseObject objectForKey:@"data"];
        if (block) block(data, nil);

    } else {
        id message = [responseObject objectForKey:@"message"];
        if ([message isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [message valueForKey:@"msg"];
            NSLog(@"Error 400 = %@", msg);
//            [PromptHUD showTitle:msg inView:UIApplication.sharedApplication.keyWindow];
        } else if ([message isKindOfClass:[NSString class]]) {
            NSLog(@"Error 400 = %@", message);
//            [PromptHUD showTitle:message inView:UIApplication.sharedApplication.keyWindow];
        } else {
            NSLog(@"Error 400 = %@", message);
        }
        NSDictionary *errorInfo = @{NSDebugDescriptionErrorKey: @"返回 status != 200 错误"};
        NSError *statusErr = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:NSURLErrorBadServerResponse
                                             userInfo:errorInfo];
        if (block) block(nil, statusErr);
    }
}

// 处理失败返回结果
+ (void)handleFailure:(NSError *)error block:(CompleteBlock)block {

    NSLog(@"%@", error);
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -999) {
        return; // 网络请求被取消
    }
    if ([UUNetWorkManager sessionManager].reachabilityManager.isReachable) {
//        [PromptHUD showTitle:@"网络错误" inView:[UIApplication sharedApplication].keyWindow];
    } else {
//        [PromptHUD showTitle:@"请检查网路设置" inView:[UIApplication sharedApplication].keyWindow];
    }
    if (block) block(nil, error);
}

#pragma mark - Utility

// 重置请求接口URL及参数列表
+ (void)resetPath:(NSString **)path parameters:(NSDictionary **)param {

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

// 显示HUD
+ (UIView *)showProgressHUD {

    __block UIView *progressHUD = nil;
    if ([NSThread isMainThread]) {
        if ([UUNetWorkManager shareManager].showHUD == 1) {
//            progressHUD = [PromptHUD showIndicatorInView:UIApplication.sharedApplication.keyWindow];
        } else if ([UUNetWorkManager shareManager].showHUD == 2) {
//            progressHUD = [PromptHUD showAnnularForProgressInView:UIApplication.sharedApplication.keyWindow];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UUNetWorkManager shareManager].showHUD == 1) {
//                progressHUD = [PromptHUD showIndicatorInView:UIApplication.sharedApplication.keyWindow];
            } else if ([UUNetWorkManager shareManager].showHUD == 2) {
//                progressHUD = [PromptHUD showAnnularForProgressInView:UIApplication.sharedApplication.keyWindow];
            }
        });
    }
    return progressHUD;
}

+ (UIView *)currentView {

    UIViewController *controller = [UUToolsUI topViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
    return controller.view;
}


// 隐藏HUD
+ (void)hideProgressHUD:(UIView *)hud {

    if ([UUNetWorkManager shareManager].showHUD != 0) {
//        [PromptHUD hideHUD:hud];
    }
    [UUNetWorkManager shareManager].showHUD = 1; // 设置成默认HUD样式
}

// 停止刷新
+ (void)endScrollViewRefreshing {

    if ([UUNetWorkManager shareManager].endRefresh == 0) return;
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topController = [UUToolsUI topViewControllerFrom:rootController];
    UIView *currentView = topController.view;
    if (!currentView) return;

    UIScrollView *scrollView = nil;
    for (UIView *subview in currentView.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)subview;
            break;
        }
    }
    if (!scrollView) return;
//    if ([scrollView.mj_header isRefreshing]) {
//        [scrollView.mj_header endRefreshing];
//    }
//    if ([scrollView.mj_footer isRefreshing]) {
//        [scrollView.mj_footer endRefreshing];
//    }
    [UUNetWorkManager shareManager].endRefresh = 0;
}

// 查询当前正在运行的task，停止相同的task
+ (void)querySameRequest:(NSURLSessionTask *)newTask cancelNew:(BOOL)cancelNew {

    NSMutableArray *oldTasks = [[UUNetWorkManager sessionManager].tasks mutableCopy];
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
+ (BOOL)compareEqualRequest:(NSURLRequest *)compare to:(NSURLRequest *)toValue {

    BOOL sameMethod = [compare.HTTPMethod isEqualToString:toValue.HTTPMethod];
    BOOL sameURL = [compare.URL.absoluteString isEqualToString:toValue.URL.absoluteString];
    if (sameMethod && sameURL) {
        if ([compare.HTTPMethod isEqualToString:@"GET"]) {
            return YES;
        } else if ([compare.HTTPBody isEqualToData:toValue.HTTPBody]) {
            return YES;
        }
    }
    return NO;
}


@end
