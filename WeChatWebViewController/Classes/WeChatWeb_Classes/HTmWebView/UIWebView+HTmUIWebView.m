//
//  UIWebView+HTmUIWebView.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/10/16.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import "UIWebView+HTmUIWebView.h"

@implementation UIWebView (HTmUIWebView)


/* HTmWebViewProtocol */

- (void)setDelegateView:(id<UIWebViewDelegate>)delegateView
{
    self.delegate = delegateView;
}

- (NSURL *)URL
{
    return [[self request] URL];
}


- (void)loadRequestFromString:(NSString *)urlNameAsString
{
    NSURL *url = [NSURL URLWithString:urlNameAsString];
    
    if (!url) {
        DDLogInfo(@"[%@ %@] error： 错误的url", THIS_FILE, THIS_METHOD);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(void (^)(id, NSError *))completionHandler
{
    /**
     UIWebView Class Reference:
     
     Returns the result of running a script.
     
     Discussion
     JavaScript allocations are limited to 10 MB. The web view raises an exception if you exceed this limit on the total memory allocation for JavaScript
     */
    
    /**
     同步执行的
     注释 by OYXJ
     */
    NSString *string = [self stringByEvaluatingJavaScriptFromString:javaScriptString];
    if (completionHandler) {
        completionHandler(string, nil);
    }
}



@end
