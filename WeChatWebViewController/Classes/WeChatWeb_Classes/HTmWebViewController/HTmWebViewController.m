//
//  HTmWebViewController.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/12/1.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import <WebViewJavascriptBridge.h>//帮助UIWebView实现JS与OC的交互。
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

#import "UIWebView+Clean.h"//处理UIWebView内存泄漏

#import "HTmWebViewController.h"
#import "HTmPlaceHolderView.h"



static void * TemplatesProject_WKWebViewContext = &TemplatesProject_WKWebViewContext;

@interface HTmWebViewController () <
UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler,
NJKWebViewProgressDelegate//用于UIWebView
>

@property (nonatomic, strong) HTmPlaceHolderView *placeHolderView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;//帮助UIWebView实现JS与OC的交互
@property (nonatomic, strong) UIProgressView *wkProgressView;//wkWebView进度条
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;//用于UIWebView的进度条
@property (nonatomic, strong) NJKWebViewProgressView *progressView;//用于UIWebView的进度条



/**
 导航条返回按钮
 */
@property (nonatomic, strong)UIBarButtonItem* customBackBarItem;
@property (nonatomic, strong)UIBarButtonItem* closeButtonItem;


///<- [begin] 仿微信：`右滑手势`webview返回 ->///
// 参考： https://github.com/Roxasora/RxWebViewController
// 感谢： Roxasora（青年李大猫）

/**
 *  array that hold snapshots
    数组的元素是字典，字典的key-value如下：
    @{
        @"request":request,                  //NSURLRequest实例
        @"snapShotView":currentSnapShotView  //UIView实例
     }
 */
@property (nonatomic)NSMutableArray<NSDictionary<NSString*,id> *> * snapShotsArray;

/**
 *  current snapshotview displaying on screen when start swiping
 */
@property (nonatomic)UIView* currentSnapShotView;

/**
 *  previous view
 */
@property (nonatomic)UIView* prevSnapShotView;

/**
 *  background alpha black view
 */
@property (nonatomic)UIView* swipingBackgoundView;

/**
 *  left pan ges (从屏幕：左侧-->往右 滑动的手势)
 */
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;

/**
 *  if is swiping now
 */
@property (nonatomic)BOOL isSwipingBack;
///<- [end] 仿微信：`右滑手势`webview返回 ->///

@end





@implementation HTmWebViewController

#pragma mark - Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    @try {
        //Code that can potentially throw an exception
        [_webView removeObserver:self
                      forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    } @catch (NSException *exception) {
        //Handle an exception thrown in the @try block
    } @finally {
        //Code that gets executed whether or not an exception is thrown
    }
    
    if (NSClassFromString(@"WKWebView")) {
        // do nothing here !
    }else{
        [(UIWebView*)_webView cleanForDealloc];
    }
}


- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)title
                                    url:(NSString *_Nonnull)url
                       javaScriptString:(NSString *_Nullable)javaScriptString
                      scriptHandlerName:(NSString *_Nullable)scriptHandlerName
{
    if (self = [self init]) {
        _naviTitle = [title copy];
        _urlStr = [url copy];
        _rootUrl = [_urlStr copy];
        
        [self configureJavascriptComponentWithJavascriptString:javaScriptString
                                             scriptHandlerName:scriptHandlerName];
    }
    return self;
}

- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)title
                                    url:(NSString *_Nonnull)url
                     javaScriptFileName:(NSString *_Nullable)javaScriptFileName
                      scriptHandlerName:(NSString *_Nullable)scriptHandlerName
{
    if (self = [self init]) {
        _naviTitle = [title copy];
        _urlStr = [url copy];
        _rootUrl = [_urlStr copy];
       
        NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:javaScriptFileName ofType:@"js"];
        NSString *js = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
        [self configureJavascriptComponentWithJavascriptString:js
                                             scriptHandlerName:scriptHandlerName];
    }
    return self;
}

/**
 重载父类BaseViewController 的方法
 是否`显示`底部标签菜单栏：默认`不显示`，如果`显示`底部标签菜单栏，则在子类中重写。
 */
- (BOOL)showBottomTabBar
{
    return NO;
}

/*
 重载父类BaseViewController 的方法
 */
- (UIView *)mainContentView
{
    self.navigationController.navigationBar.barTintColor = SystemGreen;
    self.title = _naviTitle;
    
    _webView = ({
        
        UIView <HTmWebViewProtocol> *webView;
        if (NSClassFromString(@"WKWebView")) {
            
            WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
            
            if (_javaScriptString) {
                WKUserScript *script = [[WKUserScript alloc] initWithSource:_javaScriptString
                                                              injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                           forMainFrameOnly:YES];
                [configuration.userContentController addUserScript:script];
                [configuration.userContentController addScriptMessageHandler:self name:_scriptHandlerName];
            }
            
            webView = [[WKWebView alloc] initWithFrame:m_mainContentViewFrame configuration:configuration];
            [webView setDelegateView:self];
            [self configureProgressViewForWKWebView];
            
        } else {
            
            webView = [[UIWebView alloc] initWithFrame:m_mainContentViewFrame];
            [self configureProgressViewForUIWebView];
            [webView setDelegateView:_progressProxy];
            
            self.bridge = [WebViewJavascriptBridge bridgeForWebView:(UIWebView *)webView webViewDelegate:_progressProxy handler:^(id data, WVJBResponseCallback responseCallback) {
                //DDLogInfo(@"webview注册成功 -- %@", data);
                //DDLogInfo(@"webview注册成功 -- %@", @"这是JS回调默认的handler");
            }];

            if (_scriptHandlerName) {
                
                __weak typeof(self) weakSelf = self;
                [_bridge registerHandler:_scriptHandlerName handler:^(id data, WVJBResponseCallback responseCallback) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    //这是JS与OC交互：_javaScriptString 对应 _scriptHandlerName 的handler。
                    
                    [strongSelf handleScriptMessage:data];
                    
                }];
                
            }
            
        }
        
        
        webView.backgroundColor = [UIColor whiteColor];
        webView.opaque = NO;
        [webView setScalesPageToFit:YES];
        
        [webView addGestureRecognizer:self.swipePanGesture];//仿微信：`右滑手势`webview返回
        
        webView;//表示 返回 webView
    });
    
    
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //config navigation item
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    
    if (_urlStr) {
        DDLogInfo(@"%@， 加载URL：%@", THIS_METHOD, _urlStr);
        [_webView loadRequestFromString:_urlStr];
    } else {
        DDLogInfo(@"[%@ %@], Info: URL为空", THIS_FILE, THIS_METHOD);
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.navigationController.navigationBar addSubview:_progressView];
    [self.navigationController.navigationBar addSubview:_wkProgressView];
    
    if (NSClassFromString(@"WKWebView")) {
        [_webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:NSKeyValueObservingOptionNew
                      context:TemplatesProject_WKWebViewContext];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_wkProgressView removeFromSuperview];
    [_progressView removeFromSuperview];
    
    
    if (NSClassFromString(@"WKWebView")) {
        @try {
            //Code that can potentially throw an exception
            [_webView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                             context:TemplatesProject_WKWebViewContext];
        } @catch (NSException *exception) {
            //Handle an exception thrown in the @try block
        } @finally {
            //Code that gets executed whether or not an exception is thrown
        }
    }
    
}



#pragma mark - Public Method
- (void)configureJavascriptComponentWithJavascriptString:(NSString *)javascriptString
                                       scriptHandlerName:(NSString *)scriptHandlerName
{
    _javaScriptString  = [javascriptString copy];
    _scriptHandlerName = [scriptHandlerName copy];
}

- (void)resetRootURL:(NSString *)url
{
    self.rootUrl = url;
    [self.webView loadRequestFromString:self.rootUrl];
}

- (void)reloadWebView
{
    [self.webView reload];
}


#pragma mark - PUBLIC - setters and getters
- (void)setProgressViewColor:(UIColor *)progressColor
{
    _progressViewColor = progressColor;
    _progressView.progressBarView.backgroundColor = progressColor;
    _wkProgressView.trackTintColor = progressColor;
}



#pragma mark - private - setters and getters
- (NSMutableArray<NSDictionary<NSString*,id> *> *)snapShotsArray
{
    /**
     *  array that hold snapshots
        数组的元素是字典，字典的key-value如下：
        @{
            @"request":request,                  //NSURLRequest实例
            @"snapShotView":currentSnapShotView  //UIView实例
         }
     */
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

- (UIView*)swipingBackgoundView
{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _swipingBackgoundView;
}

- (UIPanGestureRecognizer*)swipePanGesture
{
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(swipePanGestureHandler:)];
    }
    return _swipePanGesture;
}

- (BOOL)isSwipingBack
{
    if (!_isSwipingBack) {
        _isSwipingBack = NO;
    }
    return _isSwipingBack;
}

- (UIBarButtonItem*)customBackBarItem
{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"backItemImage"]
                                  imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"backItemImage-hl"]
                                    imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor
                         forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5]
                         forState:UIControlStateHighlighted];
        
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

- (UIBarButtonItem*)closeButtonItem
{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}


#pragma mark - progress view
// UIWebView添加进度条
- (void)configureProgressViewForUIWebView
{
    _progressProxy = ({
        NJKWebViewProgress *progressProxy = [[NJKWebViewProgress alloc] init];
        progressProxy.webViewProxyDelegate = self;
        progressProxy.progressDelegate = self;
        progressProxy;
    });
    
    
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    _progressView = ({
        
        NJKWebViewProgressView *progressView = [[NJKWebViewProgressView alloc] initWithFrame:({
            CGRect frame = navigationBarBounds;
            frame.origin.x = 0;
            frame.origin.y = CGRectGetHeight(navigationBarBounds);
            frame.size.height = 2.f;
            frame;
        })];
        
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        progressView.progressBarView.backgroundColor = _progressViewColor?:SystemBlue;
        progressView;
    });
}

// wkWebView 添加进度条
- (void)configureProgressViewForWKWebView
{
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    _wkProgressView = ({
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:({
            CGRect frame = navigationBarBounds;
            frame.origin.x = 0;
            frame.origin.y = CGRectGetHeight(navigationBarBounds);
            frame.size.height = 2.f;
            frame;
        })];
        progressView.progressViewStyle = UIProgressViewStyleDefault;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        progressView.trackTintColor = _progressViewColor?:SystemBlue;
        progressView;
    });
}



#pragma mark - subclass implement
- (void)returnMessageFromFreeFlowWtihDictionary:(NSDictionary *)message
{
#warning subclass implement to handle
    // subclass implement to handle
}

- (void)formDataUpdateWithDataDic:(id)data
{
#warning subclass implement to handle
    // subclass implement to handle
}

- (void)handleScriptMessage:(id)data
{
#warning subclass implement to handle    
    // subclass implement to handle javascript message
}


#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"navigation type %d", navigationType);
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
            [self pushCurrentSnapshotViewWithRequest:request];
        }break;
            
        case UIWebViewNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:request];
        }break;
            
        case UIWebViewNavigationTypeBackForward: {
        }break;
            
        case UIWebViewNavigationTypeReload: {
        }break;
            
        case UIWebViewNavigationTypeFormResubmitted: {
        }break;
            
        case UIWebViewNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:request];
        }break;
            
//  状态机 不需要default
//        default: {
//        }break;
    }
    [self updateNavigationItem];
    
    
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"window.location"];
    
    if ([string rangeOfString:@"native://freeflow"].length > 0) {
//        [self returnMessageFromFreeFlowWtihDictionary:string];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if([HTmReachabilityManager isUnreachable]) {
        [self showPlaceHolderView];
        [webView stopLoading];
        return;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [webView stringByEvaluatingJavaScriptFromString:self.javaScriptString];
    [self updateNavigationItem];
    [self hidePlaceHolderView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogError(@"%@, error occured: %@, errorStr: %@", THIS_METHOD, error.debugDescription, error.localizedDescription);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([HTmReachabilityManager isUnreachable]) {
        [self showPlaceHolderView];
        [webView stopLoading];
        return;
    }
}




#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    NSLog(@"navigation type %d",navigationType);
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
        }break;
            
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
        }break;
            
        case WKNavigationTypeBackForward: {
        }break;
            
        case WKNavigationTypeReload: {
        }break;
            
        case WKNavigationTypeFormResubmitted: {
        }break;
            
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
        }break;
            
//  状态机 不需要default
//        default: {
//        }break;
    }
    [self updateNavigationItem];
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 准备加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if([HTmReachabilityManager isUnreachable]) {
        [self showPlaceHolderView];
        [webView stopLoading];
        return;
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DDLogError(@"%@, error occured: %@, errorStr: %@", THIS_METHOD, error.debugDescription, error.localizedDescription);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString * errorStr = [error.userInfo objectForKey:@"NSErrorFailingURLStringKey"];
    NSRange headerRange = [errorStr rangeOfString:@"native://freeflow?"];
    NSString * dicStr;
    NSMutableDictionary * errorDic = [NSMutableDictionary dictionary];
    if (headerRange.length > 0) {
        dicStr = [errorStr substringFromIndex:headerRange.length];
        if (dicStr.length > 0) {
            NSArray * arr = [dicStr componentsSeparatedByString:@"&"];
            for (NSString * str in arr) {
                NSRange range = [str rangeOfString:@"="];
                NSString * key = [str substringWithRange:NSMakeRange(0, range.location)];
                NSString * values = [str substringFromIndex:range.location + 1];
                [errorDic setObjectExtra:values forKey:key];
            }
            
            if (errorDic.count > 0) {
                [self returnMessageFromFreeFlowWtihDictionary:errorDic];
            }
            
        }
    }
    
    
}

// 已经开始加载界面
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
}

// 页面已全部加载
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItem];
    [self hidePlaceHolderView];
}

// 页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DDLogError(@"%@, error occured: %@, errorStr: %@", THIS_METHOD, error.debugDescription, error.localizedDescription);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([HTmReachabilityManager isUnreachable]) {
        [self showPlaceHolderView];
        [webView stopLoading];
        return;
    }
}



#pragma mark - <WKUIDelegate>

// 使用native控件处理网页警告
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    HTmAlert *alert = [HTmAlert alertWithTitle:webView.title message:message];
    [alert addActions:[HTmAlertAction actionWithTitle:@"关闭" handler:^(HTmAlertAction *action){
        if (completionHandler) {
            completionHandler();
        }
    }]];
    [alert show];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    HTmAlert *alert = [HTmAlert alertWithTitle:webView.title message:message];
    [alert addActions:[HTmAlertAction actionWithTitle:@"关闭" handler:^(HTmAlertAction *action) {
        if (completionHandler) {
            completionHandler(NO);
        }
    }]];
    
    [alert addActions:[HTmAlertAction actionWithTitle:@"确定" handler:^(HTmAlertAction *action) {
        if (completionHandler) {
            completionHandler(YES);
        }
    }]];
    [alert show];
}


#pragma mark - <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // WKWebview在这里处理javascript消息
    
    [self formDataUpdateWithDataDic:message];
}




#pragma mark - <NJKWebViewProgressDelegate>
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}



#pragma mark - button event

- (void)onNavigationLeftButtonClicked:(UIBarButtonItem *)sender
{
    if ([self.webView canGoBack]) {
        [_webView goBack];
    } else {
        if ([self isModal]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)customBackItemClicked
{
    if ([self.webView canGoBack]) {
        [_webView goBack];
    } else {
        if ([self isModal]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)closeItemClicked
{
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - update views

// 更新导航按钮显示（前进后退）
- (void)updateNavigationItem
{
    if (self.webView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[self.closeButtonItem] animated:NO];
        
//弃用customBackBarItem，使用原生backButtonItem
//        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:nil];
    }
    
    
    BOOL canGoBack = _webView.canGoBack;
    BOOL isRootUrl = [_webView.URL.absoluteString isEqualToString:_rootUrl];
    
    /* NSString *finderTitle = [_webView stringByEvaluatingJavaScript:@"document.title"]; */
    [_webView evaluateJavaScript:@"document.title" completionHandler:^(id rlt, NSError *err){
        NSString *finderTitle = rlt;
        
        // TODO: ???
        //默认tabbar不隐藏
        self.tabBarController.tabBar.hidden=NO;
        if (isRootUrl || !canGoBack) {
            self.navigationItem.leftBarButtonItem = nil;
        } else if (canGoBack) {
            if ([finderTitle isEqualToString:@"发现"]) {
                self.navigationItem.leftBarButtonItem = nil;
            }else{
                [self showCustomNavigationLeftButtonWithTitle:@"返回"
                                                        image:nil
                                              hightlightImage:nil];
                //二级界面将tabbar隐藏
                self.tabBarController.tabBar.hidden=YES;
            }
            
        }
     }];
}

- (void)showPlaceHolderView
{
    [HTmPlaceHolderView showPlaceHolderOnView: self.webView
                                   viewOffset: -100
                                        image: [UIImage imageNamed:@"unreachable"]
                                  imageOffset: -100
                                    imageSize: [UIImage imageNamed:@"unreachable"].size
                                  description: @""
                             attributedDetail: nil
                                   bottomInfo: nil
                                  actionTitle: @"重新加载"
                                actionHandler: ^{
        DDLogInfo(@"%@， 加载URL：%@", THIS_METHOD, _urlStr);
        [self.webView loadRequestFromString:_urlStr];
    }];
}

- (void)hidePlaceHolderView
{
    [HTmPlaceHolderView hidePlaceHolderOnView:self.webView];
}



#pragma mark - logic of push and pop snap shot views
- (void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request
{
    DDLogInfo(@"%@ %@ %@ %@", THIS_FILE,THIS_METHOD, @"push with request", request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的,就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        DDLogInfo(@"%@ %@ %@", THIS_FILE,THIS_METHOD, @"about blank!! return");
        return;
    }
    //如果url一样,就不push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    UIView* currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{
       @"request":request,
       @"snapShotView":currentSnapShotView
      }
    ];
    DDLogInfo(@"%@ %@ %@ %d", THIS_FILE,THIS_METHOD, @"now array count", (int)self.snapShotsArray.count);
}

- (void)startPopSnapshotView
{
    if (self.isSwipingBack) {
        return;
    }
    if (!self.webView.canGoBack) {
        return;
    }
    self.isSwipingBack = YES;
    //create a center of screen
    //CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    CGPoint center = CGPointMake(CGRectGetMidX(self.webView.frame), CGRectGetMidY(self.webView.frame));
    
    self.currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    
    //add shadows just like UINavigationController
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 5;
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    
    //move to center of screen
    self.currentSnapShotView.center = center;
    
    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
    center.x -= 60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.prevSnapShotView];
    [self.view addSubview:self.swipingBackgoundView];
    [self.view addSubview:self.currentSnapShotView];
}

- (void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance
{
    if (!self.isSwipingBack) {
        return;
    }
    
    if (distance <= 0) {
        return;
    }
    
    CGFloat boundsWidth = self.view.bounds.size.width;
    CGFloat boundsHeight = self.view.bounds.size.height;
    
    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint prevSnapshotViewCenter    = CGPointMake(boundsWidth/2, boundsHeight/2);
    prevSnapshotViewCenter.x    -= (boundsWidth - distance)/boundsWidth *60;
    // NSLog(@"prev center x%f",prevSnapshotViewCenter.x);
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.prevSnapShotView.center = prevSnapshotViewCenter;
    self.swipingBackgoundView.alpha = (boundsWidth - distance)/boundsWidth;
}

-(void)endPopSnapShotView{
    if (!self.isSwipingBack) {
        return;
    }
    
    //prevent the user touch for now
    self.view.userInteractionEnabled = NO;
    
    CGFloat boundsWidth = self.view.bounds.size.width;
    CGFloat boundsHeight = self.view.bounds.size.height;
    
    if (self.currentSnapShotView.center.x >= boundsWidth) {
        // pop success
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2,  boundsHeight/2);
            self.prevSnapShotView.center    = CGPointMake(boundsWidth/2,    boundsHeight/2);
            self.swipingBackgoundView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView      removeFromSuperview];
            [self.swipingBackgoundView  removeFromSuperview];
            [self.currentSnapShotView   removeFromSuperview];
            [self.webView goBack];
            [self.snapShotsArray removeLastObject];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }else{
        //pop fail
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth/2,    boundsHeight/2);
            self.prevSnapShotView.center    = CGPointMake(boundsWidth/2-60, boundsHeight/2);
            self.prevSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView      removeFromSuperview];
            [self.swipingBackgoundView  removeFromSuperview];
            [self.currentSnapShotView   removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }
}

#pragma mark - events handler
- (void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture
{
    CGPoint translation = [panGesture translationInView:self.webView];
    CGPoint location    = [panGesture locationInView:   self.webView];
    // NSLog(@"pan x %f,pan y %f",translation.x,translation.y);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x > 0) {  //开始动画
            [self startPopSnapshotView];
        }
    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
}



#pragma mark - 通知响应

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
        WKWebView *webView = (WKWebView *)_webView;
        _wkProgressView.alpha = 1.0f;
        BOOL animated = webView.estimatedProgress > _wkProgressView.progress;
        [_wkProgressView setProgress:webView.estimatedProgress animated:animated];
        
        if (webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
                _wkProgressView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
}


@end
