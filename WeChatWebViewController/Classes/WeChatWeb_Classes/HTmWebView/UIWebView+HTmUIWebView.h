//
//  UIWebView+HTmUIWebView.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/10/16.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTmWebViewProtocol.h"

@interface UIWebView (HTmUIWebView) <HTmWebViewProtocol>

/* HTmWebViewProtocol */

- (void)setDelegateView:(id <UIWebViewDelegate>)delegateView;


@end
