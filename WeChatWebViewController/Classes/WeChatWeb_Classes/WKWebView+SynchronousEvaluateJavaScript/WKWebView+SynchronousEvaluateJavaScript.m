//
//  WKWebView+SynchronousEvaluateJavaScript.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/6/16.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//  WKWebView 异步转化为同步 --- Available in iOS 8.0 and later.

#import "WKWebView+SynchronousEvaluateJavaScript.h"

@implementation WKWebView (SynchronousEvaluateJavaScript)

#pragma mark - 方法不可用
/**
 *  当前方法不可用，经过改造可用。详见：stringByEvaluatingJavaScript: 方法。
 */
- (NSString *)stringByEvaluatingJavaScript:(NSString *)script thisIsOldMethodAndNotUsed:(NSNull *)null
{
    __block NSString *resultString = nil;
    
    /**
     *  iOS代码 与 JS 交互 ---Available in iOS 8.0 and later.
     *
     *  @param script               ---The JavaScript string to evaluate.
     *  @param completionHandler    ---A block to invoke when script evaluation completes or fails.
     *
     */
    [self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                resultString = [[[NSString alloc] initWithFormat:@"%@",result] autorelease];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
    
    while (resultString == nil)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return [[resultString retain] autorelease];
}

#pragma mark - 方法可用
/**
 *  该方法经过改造后，可用。
 *  参考：正确使用Block避免Cycle Retain和Crash。
 *  来源：http://tanqisen.github.io/blog/2013/04/19/gcd-block-cycle-retain/
 */
- (NSString *)stringByEvaluatingJavaScript:(NSString *)script
{
    __block NSString *resultString = nil;
    
    __block BOOL isfetchCompleted = NO;
    
    __block WKWebView * blc_self = self;
    
    
    {
        /**
         *  iOS代码 与 JS 交互 ---Available in iOS 8.0 and later.
         *
         *  @param script               ---The JavaScript string to evaluate.
         *  @param completionHandler    ---A block to invoke when script evaluation completes or fails.
         *
         */
        
        //这是NSStackBlock。
        [blc_self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
            NSString * ahtml = @"";
            if (error == nil) {
                if (result != nil) {
                    if ([result isKindOfClass:[NSString class]])
                    {
                        ahtml = [[[NSString alloc] initWithFormat:@"%@",result] autorelease];
                    }
                }
            } else {
                NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
            }
            
            
            resultString = [ahtml copy];
            
            isfetchCompleted = YES;
            
            
            
        }];
        /**
         NSStackBlock：
         1. retain、release操作无效；
         2. 必须注意的是，NSStackBlock在函数返回后，Block内存将被回收。即使retain也没用。
         3. 容易犯的错误是[[mutableAarry addObject:stackBlock]，在函数出栈后，从mutableAarry中取到的stackBlock已经被回收，变成了野指针。
         4. 正确的做法是先将stackBlock copy到堆上，然后加入数组：[mutableAarry addObject:[[stackBlock copy] autorelease]]。
         5. 支持copy，copy之后生成新的NSMallocBlock类型对象。
         */
    }
    
    while (!isfetchCompleted) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return [resultString autorelease];
}
@end


// <------------------------------ 知识点（begin） ------------------------------> //

/*
 通过WKWebView和WebKit －－－ JS 与 OC 交互。
 步骤1:
 JavaScript synchronous native communication to WKWebView
 http://stackoverflow.com/questions/26851630/javascript-synchronous-native-communication-to-wkwebview
 步骤2:
 WKWebView evaluateJavascript return value
 http://stackoverflow.com/questions/26778955/wkwebview-evaluatejavascript-return-value
 步骤3:
 WKWebView: trying to query javascript synchronously from the main thread
 http://stackoverflow.com/questions/28388197/wkwebview-trying-to-query-javascript-synchronously-from-the-main-thread
 步骤4:
 How do I wait for an asynchronously dispatched block to finish?
 http://stackoverflow.com/questions/4326350/how-do-i-wait-for-an-asynchronously-dispatched-block-to-finish/4326754#4326754
 步骤5:
 How to dispatch on main queue synchronously without a deadlock?
 http://stackoverflow.com/questions/10330679/how-to-dispatch-on-main-queue-synchronously-without-a-deadlock
 */


// <------------------------------ 知识点（begin） ------------------------------> //



