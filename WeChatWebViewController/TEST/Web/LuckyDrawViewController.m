//
//  LuckyDrawViewController.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/12/1.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import "LuckyDrawViewController.h"

//#import "HTmSocialShareManager.h"


@interface LuckyDrawViewController ()

@end

@implementation LuckyDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"仿微信webview";
    
    //config navigation item
    self.navigationItem.leftItemsSupplementBackButton = YES;
    [self showCustomNavigationLeftButtonWithTitle:@"返回"
                                            image:[UIImage imageNamed:@"backItemImage"]
                                  hightlightImage:nil];
    
    
    /* [self.webView setFrame: m_mainContentViewFrame]; */
    
    
    self.urlStr = @"https://github.com/HawkingOuYang/WeChatWebViewController";
    [self.webView loadRequestFromString:self.urlStr];
}


#pragma mark - override HTmWebViewController

- (void)updateNavigationItem
{
    [self showCustomNavigationLeftButtonWithTitle:@"返回"
                                            image:[UIImage imageNamed:@"backItemImage"]
                                  hightlightImage:nil];
}

- (void)handleScriptMessage:(id)data
{
    NSDictionary *shareContent = data;
    [self shareRedPocketWithInfo:shareContent];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{

    /**
        eg.
        function sendMessageToObjC() {
            var JSONObject= {
                "meta_title":"红包 流量 话费 超值好礼天天送",
                "meta_description":"红包 流量 话费 超值好礼天天送",
                "shareURL": "http://example.domain.cn/shop/index.shtml",
                "iconName" : "myAppIdentifier",
                "iconURL" : "http://example.domain.cn/images/activity/hongbao/images/share.png",
                "shareContent" : "shareContent for Weibo"
            }
            return JSONObject;
        }
     */
    
    if ([message.name isEqualToString:self.scriptHandlerName]) {
        [self shareRedPocketWithInfo:message.body];
    }
}


#pragma mark - private

- (void)shareRedPocketWithInfo:(NSDictionary *)shareContent
{
    NSString *iconUrl = [shareContent[@"iconURL"] description];
    
    /**
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *icon = [[ServiceInterface sharedServiceInterface] imageWithURL:iconUrl];
            NSData *mediaData = UIImageJPEGRepresentation(icon, 0.8);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HTmSocialShareManager sharedManager] showShareWindowWithLink: shareContent[@"shareURL"]
                                                                         title: shareContent[@"meta_title"]
                                                                   description: shareContent[@"meta_description"]
                                                                     mediaData: mediaData];
            });
            
        });
     */
}



@end
