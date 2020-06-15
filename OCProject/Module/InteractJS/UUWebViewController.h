//
//  UUWebViewController.h
//  OCProject
//
//  Created by Pan on 2020/6/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUJSExportManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUWebViewController : UIViewController
<
    UIWebViewDelegate,
    UUJSExportManagerDelegate
>
@property (nonatomic, copy) NSString *webTitle;  // 标题
@property (nonatomic, copy) NSString *cookie;    // cookie

@property (nonatomic, strong) NSMutableURLRequest *URLRequest; // 网络请求
@property (nonatomic, strong) UIWebView *webView;              // 网页视图
@property (nonatomic, assign) BOOL showLoadingProgress;        // 显示加载进度
@property (nonatomic, assign) BOOL useSonicSession;            // 是否使用VasSonic

/// 定义初始化方法，获取URLString
- (instancetype)initWithURLString:(NSString *)urlString;
/// 开始请求网页
- (void)startWebViewLoadRequest;
/// 重新加载请求
- (void)webViewReloadRequest;
/// 清除缓存
- (void)cleanCookie;
/// 点击返回按钮
- (void)clickGoBack;
@end

NS_ASSUME_NONNULL_END
