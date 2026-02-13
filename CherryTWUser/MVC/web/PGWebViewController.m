//
//  PGWebViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/11.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGWebViewController.h"
#import <WebKit/WebKit.h>

@interface PGWebViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView * myProgressView;
@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *url;


@end

@implementation PGWebViewController

+(instancetype)controllerWithTitle:(NSString *)title url:(NSString *)url
{
    url = url == nil ? @"" : url;
    if (![url hasPrefix:@"http"]) {
        url = [@"http://" stringByAppendingString:url];
    }
    PGWebViewController * controller = [[self alloc] init];
    controller.titleString = title;
    controller.url = url;
    return controller;
}
- (void)setHtmlStr:(NSString *)htmlStr
{
    _htmlStr = htmlStr;
    self.titleString = self.webTitleSrr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self loadData];
}
- (void)setUI
{
    if (self.isCallRecharge) {
        self.naviView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    }
    [self.naviView.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.titleStr = self.titleString;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:wkUScript];
    configuration.userContentController = userContentController;
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    configuration.allowsInlineMediaPlayback = YES;
     WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
     if (@available(iOS 11.0, *)) {
         webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     } else {
         // Fallback on earlier versions
//         self.automaticallyAdjustsScrollViewInsets = NO;
     }
     [self.view addSubview:webView];
     [self.view addSubview:self.myProgressView];
     [webView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.equalTo(self.view);
         make.top.mas_equalTo(self.isCallRecharge ? 64 : (STATUS_H_F+44));
     }];
     [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
     webView.allowsBackForwardNavigationGestures = YES;
     self.webView = webView;
     self.webView.backgroundColor = [UIColor clearColor];
     self.webView.opaque = NO;
     self.webView.navigationDelegate = self;
     self.webView.scrollView.showsVerticalScrollIndicator = NO;
     self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}
- (void)loadData
{
    if(self.htmlStr.length>0){
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    }else{
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
    }
}
// 记得取消监听
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content='width=device-width,user-scalable=no';"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    if ([self.url containsString:@"alipay"]) {
        NSURL *alipayURL = [NSURL URLWithString:self.url];
        [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
            
        }];
    }
}
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, STATUS_H_F+44, ScreenWidth, 0)];
        _myProgressView.tintColor = THEAME_COLOR;
        _myProgressView.trackTintColor = [UIColor clearColor];
    }
    return _myProgressView;
}

- (void)backBtnAction:(QMUIButton *)sender
{
    if (self.webView.canGoBack==YES) {
        //返回上级页面
        [self.webView goBack];
    }else{
        //退出控制器
//        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    if (self.isRecharge) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
