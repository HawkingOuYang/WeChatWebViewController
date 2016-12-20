//
//  WKWebView+HTmWKWebView.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/10/16.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import <WebKit/WebKit.h>
#import "HTmWebViewProtocol.h"

@interface WKWebView (HTmWKWebView) <HTmWebViewProtocol>

/* HTmWebViewProtocol */

- (void)setDelegateView:(id <WKUIDelegate, WKNavigationDelegate>)delegateView;


@end
