//
//  YXBaseWebVC.m
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXBaseWebVC.h"

@interface YXBaseWebVC () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate>

/** 返回的标识 */
@property (nonatomic, strong) WKNavigation *backNavigation;

@end

@implementation YXBaseWebVC

#pragma mark - 释放资源
- (void)dealloc {
    
}
- (void)didMoveToParentViewController:(UIViewController*)parent {
    
    [super didMoveToParentViewController:parent];
    if(!parent){
        //[_wkConfiguration.userContentController removeScriptMessageHandlerForName:@""];
    }
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
            
    [self initView];
    [self startLoading];
}

#pragma mark - 初始化视图
- (void)initView {
    
    __weak typeof(self) weakSelf = self;
    
    //导航栏
    self.navView.titleLab.text = @"加载中...";
    self.navView.clickBackBlock = ^{
        
        [weakSelf goBackAction];
    };
    
    //进度视图
    _progressView = [[YXProgressSlider alloc] init];
    _progressView.minimumColor = kYXTitleNormalColor;
    _progressView.maximumColor = [UIColor clearColor];
    _progressView.isHiddenSlider = YES;
    _progressView.isHiddenCorner = YES;
    _progressView.progressHeight = 2;
    _progressView.hidden = YES;
    [self.view addSubview:_progressView];
    
    //网页配置
    _wkConfiguration = [[WKWebViewConfiguration alloc] init];
    _wkConfiguration.preferences = [[WKPreferences alloc] init];
    _wkConfiguration.preferences.minimumFontSize = 10;
    _wkConfiguration.preferences.javaScriptEnabled = YES;
    _wkConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    _wkConfiguration.userContentController = [[WKUserContentController alloc] init];
    _wkConfiguration.processPool = [[WKProcessPool alloc] init];
    
    //网页视图
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_wkConfiguration];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.delegate = self;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.opaque = NO;
    _wkWebView.backgroundColor = [UIColor clearColor];
    _wkWebView.scrollView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_wkWebView];
    
    //解决右滑返回手势的冲突
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [_wkWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
            break;
        }
    }
    
    //添加JS方法
    //[_wkConfiguration.userContentController addScriptMessageHandler:self name:@""];
}

#pragma mark - 布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _progressView.frame = CGRectMake(0, kYXNavigationBarHeight, self.view.width, 2);
    _wkWebView.frame = CGRectMake(0, kYXNavigationBarHeight, self.view.width, self.view.height - kYXNavigationBarHeight);
}

#pragma mark - 设置URL
- (void)setUrlStr:(NSString *)urlStr {
    
    //这里拼接一些参数给H5做适配
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        _urlStr = [NSString stringWithFormat:@"%@?isApp=1&isIponeX=%d&xBarHeight=%f", urlStr, kYXIsFullScreenX, kYXBottomSafeHeight];
    }
    else {
        _urlStr = [NSString stringWithFormat:@"%@&isApp=1&isIponeX=%d&xBarHeight=%f", urlStr, kYXIsFullScreenX, kYXBottomSafeHeight];
    }
}

#pragma mark - 开始加载
- (void)startLoading {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    request.timeoutInterval = 15;
    [_wkWebView loadRequest:request];
}

#pragma mark - 显示加载视图
- (void)showLoadingView {
    
    _progressView.hidden = NO;
    [_progressView setProgressValue:_wkWebView.estimatedProgress animated:YES];
    [self.view bringSubviewToFront:_progressView];
}

#pragma mark - 隐藏加载视图
- (void)hiddenLoadingView {
    
    [_progressView setProgressValue:1 animated:YES];
    
    if (_progressView.value == 1) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.progressView.hidden = YES;
            weakSelf.progressView.value = 0;
        });
    }
}

#pragma mark - 操作
- (void)goBackAction {
    
    if ([_wkWebView canGoBack]) {
        _backNavigation = [_wkWebView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)goForwardAction {
    
    if ([_wkWebView canGoForward]) {
        [_wkWebView goForward];
    }
}
- (void)refreshAction {
    
    [_wkWebView reload];
}

#pragma mark - <WKNavigationDelegate>
/** 页面跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    if ([URL.scheme isEqualToString:@"tel"]) {
        //打电话
        [YXCategoryBaseManager yxCallMobile:URL.resourceSpecifier];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([URL.scheme isEqualToString:@"itms-apps"] || [URL.host isEqualToString:@"itunes.apple.com"]) {
        //跳转AppStore
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(yxWebView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_delegate yxWebView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //显示加载转圈
    [self showLoadingView];
    
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(yxWebView:didStartProvisionalNavigation:)]) {
        [_delegate yxWebView:webView didStartProvisionalNavigation:navigation];
    }
}
//正在加载
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    //显示加载转圈
    [self showLoadingView];
}
//加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self webView:webView didFailProvisionalNavigation:navigation withError:error];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //隐藏加载转圈
    [self hiddenLoadingView];
    
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(yxWebView:didFailNavigation:withError:)]) {
        [_delegate yxWebView:webView didFailNavigation:navigation withError:error];
    }
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //隐藏加载转圈
    [self hiddenLoadingView];
    
    //设置标题
    self.navView.titleLab.text = _wkWebView.title;
    
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(yxWebView:didFinishNavigation:)]) {
        [_delegate yxWebView:webView didFinishNavigation:navigation];
    }
    
    //返回刷新数据
    if ([_backNavigation isEqual:navigation]) {
         [_wkWebView reload];
         _backNavigation = nil;
    }
}

#pragma mark - <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(yxUserContentController:didReceiveScriptMessage:)]) {
        [_delegate yxUserContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
