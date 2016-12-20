//
//  WKWebView+SynchronousEvaluateJavaScript.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/6/16.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//  WKWebView 异步转化为同步 --- Available in iOS 8.0 and later.

/**
 *  作用：WKWebView evaluateJavascript return value
 *  来源：http://stackoverflow.com/questions/26778955/wkwebview-evaluatejavascript-return-value
 
 *  作者说明：I solved this problem by waiting for result until result value is returned.
 
            I used NSRunLoop for waiting, but I'm not sure it's best way or not...
 
            Here is the category extension source code that I'm using now.
 */

#import <WebKit/WebKit.h>

@interface WKWebView (SynchronousEvaluateJavaScript)
/**
 *  
    Example code:
 
    NSString *userAgent = [_webView stringByEvaluatingJavaScript:@"navigator.userAgent"];
 
    NSLog(@"userAgent: %@", userAgent);
 *
 */
- (NSString *)stringByEvaluatingJavaScript:(NSString *)script;
@end
