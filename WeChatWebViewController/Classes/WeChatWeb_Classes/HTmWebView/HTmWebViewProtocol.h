//
//  HTmWebViewProtocol.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/10/16.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef HTm_STRONG
    #if __has_feature(objc_arc)
        #define HTm_STRONG strong
    #else
        #define HTm_STRONG retain
    #endif
#endif /* HTm_STRONG */


/**
 此协议，把UIWebView和WKWebView统一起来，实现webView在iOS8.0操作系统的过渡。
 */
@protocol HTmWebViewProtocol <NSObject>

@property (nonatomic, HTm_STRONG, readonly) NSURLRequest *request;
@property (nonatomic, HTm_STRONG, readonly) NSURL *URL;

- (void)setDelegateView:(id)delegateView;
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadRequestFromString:(NSString *)urlNameAsString;
- (BOOL)canGoBack;
- (void)goBack;
- (void)reload;
- (void)setScalesPageToFit:(BOOL)scalesPageToFit;
- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(void (^)(id, NSError *))completionHandler;

@end
