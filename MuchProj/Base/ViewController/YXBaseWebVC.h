//
//  YXBaseWebVC.h
//  MuchProj
//
//  Created by Ausus on 2021/11/9.
//

#import "YXBaseVC.h"
#import <WebKit/WebKit.h>
#import "YXProgressSlider.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YXBaseWebVCDelegate <NSObject>
@optional

/** 页面跳转 */
- (void)yxWebView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/** 开始加载 */
- (void)yxWebView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

/** 正在加载 */
- (void)yxWebView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;

/** 加载失败 */
- (void)yxWebView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;

/** 加载完成 */
- (void)yxWebView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

/** JS返回参数 */
- (void)yxUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface YXBaseWebVC : YXBaseVC

/** 进度视图 */
@property (nonatomic, strong) YXProgressSlider *progressView;
/** 网页视图 */
@property (nonatomic, strong) WKWebView *wkWebView;
/** 网页配置 */
@property (nonatomic, strong) WKWebViewConfiguration *wkConfiguration;
/** 网页地址 */
@property (nonatomic, copy) NSString *urlStr;
/** 网页代理 */
@property (nonatomic, weak) id <YXBaseWebVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
