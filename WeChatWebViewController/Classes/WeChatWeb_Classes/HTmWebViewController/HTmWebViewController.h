//
//  HTmWebViewController.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/12/1.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HTmWebViewProtocol.h"//此协议，把UIWebView和WKWebView统一起来，实现webView在iOS8.0操作系统的过渡。
#import "UIWebView+HTmUIWebView.h"
#import "WKWebView+HTmWKWebView.h"

#import "BaseViewController.h"


@interface HTmWebViewController : BaseViewController

@property (nonatomic, HTm_STRONG) UIView <HTmWebViewProtocol> * _Nonnull webView;
@property (nonatomic, copy, readwrite) NSString * _Nonnull urlStr;
@property (nonatomic, copy, readwrite) NSString * _Nonnull rootUrl;
@property (nonatomic, copy, readonly) NSString * _Nullable naviTitle;
@property (nonatomic, strong, readwrite) UIColor * _Nullable progressViewColor;
@property (nonatomic, copy, readonly) NSString * _Nullable javaScriptString;
@property (nonatomic, copy, readonly) NSString * _Nullable scriptHandlerName;


- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)title
                                    url:(NSString *_Nonnull)url
                       javaScriptString:(NSString *_Nullable)javaScriptString
                      scriptHandlerName:(NSString *_Nullable)scriptHandlerName;

- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)title
                                    url:(NSString *_Nonnull)url
                     javaScriptFileName:(NSString *_Nullable)javaScriptFileName
                      scriptHandlerName:(NSString *_Nullable)scriptHandlerName;

- (void)configureJavascriptComponentWithJavascriptString:(NSString *_Nonnull)javascriptString
                                       scriptHandlerName:(NSString *_Nonnull)scriptHandlerName;
- (void)updateNavigationItem;


- (void)resetRootURL:(NSString *_Nonnull)url;
- (void)reloadWebView;


#pragma mark - subclass implement
- (void)handleScriptMessage:(id _Nullable)data;
- (void)returnMessageFromFreeFlowWtihDictionary:(NSDictionary * _Nullable)message;
- (void)formDataUpdateWithDataDic:(id _Nullable)data;

@end
