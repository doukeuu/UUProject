//
//  UUWebProxyManager.m
//  OCProject
//
//  Created by Pan on 2020/6/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUWebProxyManager.h"

@implementation UUWebProxyManager

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"========");
    
    if ([self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self resetNavigationTitleWith:webView];
    
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if ([self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:webView didFailLoadWithError:error];
    }
}

#pragma mark - ExportProxyManagerDelegate

- (void)nativeResponse:(NSString *)method withInfo:(NSDictionary *)info {
    
    if ([method isEqualToString:kMethodGeneralLogin]) {
        NSLog(@"++++ ======");
    }
    
    if ([self.exportDelegate respondsToSelector:@selector(nativeResponse:withInfo:)]) {
        [self.exportDelegate nativeResponse:method withInfo:info];
    }
}

#pragma mark - Utility

// 页面跳转时，重设导航栏标题
- (void)resetNavigationTitleWith:(UIWebView* )webView {
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!title || title.length == 0) return;
    
    id controller = self.webViewDelegate;
    NSString *urlString = [controller valueForKey:@"urlString"];
    NSString *originalTitle = [controller valueForKey:@"webTitle"];
    if ([webView.request.URL.absoluteString isEqualToString:urlString]) {
        [controller setValue:originalTitle forKeyPath:@"navigationItem.title"];
    } else {
        [controller setValue:title forKeyPath:@"navigationItem.title"];
    }
}

@end
