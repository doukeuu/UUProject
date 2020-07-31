//
//  SSBaseWebController.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "SSBaseWebController.h"
#import "UIBarButtonItem+UU.h"
#import "UUCostantKey.h"

@interface SSBaseWebController ()
<
    WKNavigationDelegate,
    WKUIDelegate
>
@property (nonatomic, strong) UIProgressView *progressView; // 进度条视图
@property (nonatomic, strong) NSMutableURLRequest *request; // 网络请求类
@property (nonatomic, strong) NSString *htmlString;         // html内容字符
@end

@implementation SSBaseWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self generateBaseSubviews];
    [self loadWebViewRequest];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - Setter

- (void)setUrlContent:(NSString *)urlContent {
    _urlContent = [urlContent copy];
    [self handleURLContent:urlContent];
}

// 处理网址或内容
- (void)handleURLContent:(NSString *)content {
    if (content == nil) {
        self.request = nil;
        self.htmlString = nil;
    } else if ([content hasPrefix:@"http"] || [content hasPrefix:@"HTTP"]) { // 网址
        if ([content containsString:@".jpg"] ||
            [content containsString:@".jped"] ||
            [content containsString:@".png"] ||
            [content containsString:@".gif"]) { // 图片网址
            NSString *htmlCode = @"<body style=\"margin:0; padding:0\"><p><img src=\"%@\"/></p></body>";
            self.htmlString = [NSString stringWithFormat:htmlCode, content];
        } else {
            NSURL *url = [NSURL URLWithString:content];
            if (url == nil) url = [NSURL URLWithString:@"https://www.yimaokeji.com"];
            self.request = [[NSMutableURLRequest alloc] initWithURL:url];
            self.request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
            self.request.timeoutInterval = 20;
        }
    } else {
        if ([content containsString:@"<body"]) { // 内容有body标签
            self.htmlString = content;
        } else { // 添加body标签，设置边距为0
            self.htmlString = [NSString stringWithFormat:@"<body style=\"margin:8; padding:0\">%@</body>", content];
        }
    }
}

// 加载网页请求
- (void)loadWebViewRequest {
    if (self.request != nil) {
        [self.webView loadRequest:self.request];
    } else if (self.htmlString != nil) {
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:JSInjectedFormat injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.webView.configuration.userContentController addUserScript:userScript];
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }
}

#pragma mark - Subviews

// 生成子视图
- (void)generateBaseSubviews {
    // 返回按钮
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"arrow_back_black"]
                                                                        action:@selector(clickBackItem) target:self];
    
    // 导航栏进度条
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    _progressView = [[UIProgressView alloc] initWithFrame:rect];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = UIColor.blueColor;
    [self.view addSubview:_progressView];
    
    // 网页视图
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.configuration.preferences.minimumFontSize = 15;
    _webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    _webView.configuration.allowsInlineMediaPlayback = YES;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view insertSubview:_webView belowSubview:_progressView];
}

#pragma mark - Respond

// 点击返回按钮
- (void)clickBackItem {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
