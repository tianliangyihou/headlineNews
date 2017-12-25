//
//  HNHomeWebVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/6.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeWebVC.h"
#import <WebKit/WebKit.h>
#import "HNNavigationController.h"
@interface HNHomeWebVC ()<WKNavigationDelegate>

@property (nonatomic , weak)WKWebView *webView;
@property (nonatomic , weak)MBProgressHUD *hud;

@end

@implementation HNHomeWebVC

- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, HN_SCREEN_WIDTH, HN_SCREEN_HEIGHT - HN_NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:webView];
        _webView = webView;
   }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftItemWithImageName:@"lefterbackicon_titlebar_24x24_"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
//    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HNNavigationController *nav = (HNNavigationController *)self.navigationController;
    [nav stopPopGestureRecognizer];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    HNNavigationController *nav = (HNNavigationController *)self.navigationController;
    [nav startPopGestureRecognizer];
    UIImage *image =[self.navigationController valueForKeyPath:@"defaultImage"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _hud = [MBProgressHUD showMessag:@"loading..." toView:nil];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_hud hideAnimated:YES];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"加载失败");

}
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

@end
