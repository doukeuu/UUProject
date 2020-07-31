//
//  SSBaseWebController.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "SSBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSBaseWebController : SSBaseViewController

/// 网页视图
@property (nonatomic, strong, readonly) WKWebView *webView;
/// 网址或内容
@property (nonatomic, copy) NSString *urlContent;

/// 加载网页请求
- (void)loadWebViewRequest;
@end

NS_ASSUME_NONNULL_END
