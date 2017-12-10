//
//  HNHomeWebVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/6.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeWebVC.h"
#import <WebKit/WebKit.h>
@interface HNHomeWebVC ()<WKNavigationDelegate>

@property (nonatomic , weak)WKWebView *webView;

@end

@implementation HNHomeWebVC

- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, HN_NAVIGATION_BAR_HEIGHT - 64, HN_SCREEN_WIDTH, HN_SCREEN_HEIGHT - HN_NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:webView];
        _webView = webView;
   }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"返回内容");

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完毕");

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"加载失败");

}
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
//
//}
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSLog(@"decidePolicyForNavigationAction");
//}

@end
