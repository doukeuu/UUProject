//
//  UUWebViewController.m
//  OCProject
//
//  Created by Pan on 2020/6/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUWebViewController.h"
#import "UUWebProxyManager.h"
//#import <Sonic.h>
//#import <NJKWebViewProgress.h>

#define kCookieKey @"CookieKey"

@interface UUWebViewController ()
// <
//    NJKWebViewProgressDelegate
//    SonicSessionDelegate
// >
@property (nonatomic, copy) NSString *urlString; // 网址
@property (nonatomic, strong) UIProgressView *progressView;      // 进度条
@property (nonatomic, strong) UUWebProxyManager *webViewProxy; // 网页代理
@property (nonatomic, strong) UUJSExportManager *exportProxy; // JS交互代理
//@property (nonatomic, strong) NJKWebViewProgress *progressProxy; // 进度代理
@end

@implementation UUWebViewController

#pragma mark - Life Cycle

// 定义初始化方法，获取URLString
- (instancetype)initWithURLString:(NSString *)urlString {
    
    if (self = [super init]) {
        self.urlString = urlString;
        self.URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//        [[SonicEngine sharedEngine] createSessionWithUrl:self.urlString withWebDelegate:self];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:self.webTitle];
    [self generateSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showLoadingProgress = YES;
    self.useSonicSession = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.progressView.hidden = !self.showLoadingProgress;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"== %@", [self class]);
//    [[SonicEngine sharedEngine] removeSessionWithWebDelegate:self];
}

#pragma mark - Property Setter

- (void)setUrlString:(NSString *)urlString {
    
    if (!urlString || urlString.length == 0) {
        _urlString = @"";
    } else if ([urlString rangeOfString:@"?"].location == NSNotFound) {
        _urlString = [urlString stringByAppendingString:@"?platform=app"];
    } else {
        if ([urlString rangeOfString:@"platform"].location == NSNotFound) {
            _urlString = [urlString stringByAppendingString:@"&platform=app"];
        } else {
            _urlString = urlString;
        }
    }
}

#pragma mark - Subviews Generation

// 生成子视图
- (void)generateSubviews {
    
    // 导航栏返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 25);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 导航栏刷新按钮
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateAction)];
    self.navigationItem.rightBarButtonItem = reloadItem;
    
    // 导航栏进度条
    CGSize barSize = self.navigationController.navigationBar.bounds.size;
    CGRect frame = CGRectMake(0, barSize.height - 2, barSize.width, 2);
    _progressView = [[UIProgressView alloc] initWithFrame:frame];
    _progressView.trackTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    // 网页视图
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:_webView];
}

#pragma mark - WebView Configuration

// 请求网页
- (void)startWebViewLoadRequest {
    
    if (!self.urlString || self.urlString.length == 0) return;
    NSLog(@"webView load URL: %@", self.urlString);
    
    [self configureDelegate];
    [self setCookieValue:self.cookie forKey:kCookieKey withURL:self.URLRequest.URL];
    
    self.URLRequest.timeoutInterval = 15.0;
//    SonicSession *session = [[SonicEngine sharedEngine] sessionWithWebDelegate:self];
//    if (session && self.useSonicSession) {
//        [self.webView loadRequest:[SonicUtil sonicWebRequestWithSession:session withOrigin:self.URLRequest]];
//    } else {
        [self.webView loadRequest:self.URLRequest];
//    }
}

// 重新加载请求
- (void)webViewReloadRequest {
    
    if (!self.urlString || self.urlString.length == 0) return;
    NSLog(@"webView load URL: %@", self.urlString);
    
    [self setCookieValue:self.cookie forKey:kCookieKey withURL:self.URLRequest.URL];
//    SonicSession *session = [[SonicEngine sharedEngine] sessionWithWebDelegate:self];
//    if (session) {
//        [self.webView loadRequest:[SonicUtil sonicWebRequestWithSession:session withOrigin:self.URLRequest]];
//    } else {
        [self.webView loadRequest:self.URLRequest];
//    }
}

// 设置代理传递
- (void)configureDelegate {
    
    _exportProxy = [[UUJSExportManager alloc] init];
    _webViewProxy = [[UUWebProxyManager alloc] init];
//    _progressProxy = [[NJKWebViewProgress alloc] init];
//    _progressProxy.progressDelegate = self;
    
    // 设置与JS交互
    NSString *keyPath = @"documentView.webView.mainFrame.javaScriptContext";
    JSContext *context = [self.webView valueForKeyPath:keyPath];
    context[@"app"] = _exportProxy;
    
    // 两层代理：JSExportProxyManager -> WebViewProxyManager -> Controller
    _exportProxy.delegate = _webViewProxy;
    _webViewProxy.exportDelegate = self;
    
    // 三层代理：webView.delegate -> NJKWebViewProgress -> WebViewProxyManager -> Controller
//    self.webView.delegate = _progressProxy;
//    _progressProxy.webViewProxyDelegate = _webViewProxy;
    _webViewProxy.webViewDelegate = self;
}

// 设置Cookie
- (void)setCookieValue:(NSString *)value forKey:(NSString *)key withURL:(NSURL *)url {
    
    if (!value || value.length == 0 || !key || !url.host) return;
    
    NSString *cookieDomain = @".youjuke.com.cn";
    if ([url.host rangeOfString:cookieDomain].location == NSNotFound) {
        cookieDomain = url.host;
    }
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName:key,
                                                                NSHTTPCookieValue:value,
                                                                NSHTTPCookiePath:@"/",
                                                                NSHTTPCookieDomain:cookieDomain}];
    NSMutableArray *newCookies = [NSMutableArray arrayWithArray:allCookies];
    [newCookies addObject:cookie];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:newCookies forURL:url mainDocumentURL:nil];
}

// 清除Cookie
- (void)cleanCookie {
    
    if (!self.URLRequest) return;
    // 清除缓存
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:self.URLRequest];
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.URLRequest.URL];
    for (NSHTTPCookie *cookie in allCookies) {
        if ([cookie.name isEqualToString:kCookieKey]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            break;
        }
    }
}

#pragma mark - Touch Action

// 点击返回按钮
- (void)clickGoBack {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 点击刷新按钮
- (void)updateAction {
//    [[SonicEngine sharedEngine] reloadSessionWithWebDelegate:self completion:^(NSDictionary *result) {
//        NSLog(@"-- result : %@", result);
//    }];
}

//#pragma mark - NJKWebViewProgressDelegate

//- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
//
//    if (!self.showLoadingProgress) return;
//    [self.progressView setProgress:progress animated:YES];
//    if (self.progressView.progress >= 1.0) {
//        [UIView animateWithDuration:0.3 delay:1.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.progressView.alpha = 0;
//        } completion:^(BOOL finished) {
//            self.progressView.progress = 0.0;
//        }];
//    } else {
//        self.progressView.alpha = 1.0;
//    }
//}

//#pragma mark - SonicSessionDelegate
//
//- (void)sessionWillRequest:(SonicSession *)session {
//    // 可以在请求发起前同步Cookie等信息
//}
//
//- (void)session:(SonicSession *)session requireWebViewReload:(NSURLRequest *)request {
//    [self.webView loadRequest:request];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
