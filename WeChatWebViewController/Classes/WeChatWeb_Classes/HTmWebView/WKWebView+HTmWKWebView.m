//
//  WKWebView+HTmWKWebView.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/10/16.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import <objc/runtime.h>
#import "WKWebView+HTmWKWebView.h"


@implementation WKWebView (HTmWKWebView)

/* HTmWebViewProtocol */

- (void)setDelegateView:(id<WKUIDelegate,WKNavigationDelegate>)delegateView
{
    self.navigationDelegate = delegateView;
    self.UIDelegate = delegateView;
}

// WKWebview没有request这个property， UIWebView有， 为了统一所以在这添加一个
- (NSURLRequest *)request
{
    return objc_getAssociatedObject(self,
                                    @selector(request));
}

- (void)setRequest:(NSURLRequest *)request
{
    objc_setAssociatedObject(self,
                             @selector(request),
                             request,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// hook一下
- (nullable WKNavigation *)htm_loadRequest:(NSURLRequest *)request
{
    self.request = request;
    
    // method swizzle后， loadRequest与htm_loadRequest方法已经互换， 调用loadRequest方法会自动替换到htm_loadRequest方法， 调用htm_loadRequest方法也会自动替换到原始的loadRequest方法， 这里实际上是在调用原始的loadRequest方法， 并不是递归
    return [self htm_loadRequest:request];
}

- (void)loadRequestFromString:(NSString *)urlNameAsString
{
    NSURL *url = [NSURL URLWithString:urlNameAsString];
    //  NSURL *encodeUrl = [NSURL URLWithString:[urlNameAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (!url) {
        DDLogVerbose(@"%@ %@ urlStirng不正确， 无法转换成NSURL",THIS_FILE,THIS_METHOD);
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    return;
}


/*
 饿汉模式
 本类中为WKWebView添加了request属性(WKWebView本身没有)，替换loadRequest方法确保WKWebView调用loadRequest时该属性被赋值
 */
+ (void)load
{
    // 保证线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(loadRequest:);
        SEL swizzledSelector = @selector(htm_loadRequest:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL methodAddSuccess = class_addMethod(class,
                                                originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod));
        if (methodAddSuccess) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}




@end
