//
//  AppDelegate.m
//  WeChatWebViewController
//
//  Created by HawkingOuYang.com on 2016/12/20.
//  Copyright © 2016年 [OYXJlucky@163.com] . All rights reserved.
//

#import "AppDelegate.h"


#import "CNavigationController.h"

#import "LuckyDrawViewController.h"
#import "HTmWebViewNavigationViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - test code

- (void)push
{// TODO: test code
    LuckyDrawViewController *vc = [[LuckyDrawViewController alloc] init];
    
    [((HTmWebViewNavigationViewController *)(self.window.rootViewController)) pushViewController:vc animated:YES];
}// TODO: test code

- (void)present
{// TODO: test code
    LuckyDrawViewController *vc = [[LuckyDrawViewController alloc] init];
    HTmWebViewNavigationViewController *nav = [[HTmWebViewNavigationViewController alloc] initWithRootViewController:vc];
    
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}// TODO: test code



#pragma mark - app life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rootVC = [UIViewController new];
    rootVC.title = @"我是根页面啦~ :)";
    //CNavigationController *nav = [[CNavigationController alloc] initWithRootViewController:rootVC];
    HTmWebViewNavigationViewController *nav = [[HTmWebViewNavigationViewController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    
    {// TODO: test code
        UIView *superView = rootVC.view;
        
        UILabel *desLb = UILabel.new;
        desLb.text = @"\
        by 欧阳孝金 at HawkingOuYang.com \
        \n\
        on GitHub github.com/HawkingOuYang/WeChatWebViewController \
        \n\
        All rights reserved .\
        \n\
        WeChatWebViewController \
        \n\
        仿造 微信webView效果，包括：\
        \n\
        1进度条，\
        \n\
        2左滑返回上个网页或者直接关闭(像UINavigationController)，\
        \n\
        3适配iOS8.0的UIWebView(特别处理UIWebView内存泄漏)和WKWebView，\
        \n\
        4支持JS和OC交互HybridApp，\
        \n\
        5支持WebViewProxy \
        ";
        desLb.numberOfLines = 0;
        desLb.textAlignment = NSTextAlignmentLeft;
        
        [rootVC.view addSubview: desLb];
        
        [desLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView);
            make.left.equalTo(superView);
            make.width.equalTo(superView);
        }];
        
        
        UIButton *btn1 = UIButton.new;
        UIButton *btn2 = UIButton.new;
        
        btn1.backgroundColor = SystemOrange;
        btn2.backgroundColor = SystemBlue;
        
        [btn1 setTitle:@"push"      forState:UIControlStateNormal];
        [btn2 setTitle:@"present"   forState:UIControlStateNormal];
        
        [btn1 addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
        
        [rootVC.view addSubview: btn1];
        [rootVC.view addSubview: btn2];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.mas_centerX);
            make.top.equalTo(desLb.mas_bottom).offset(10);
            
            make.size.mas_equalTo(CGSizeMake(R(50), R(50)));//看我怎么适配屏幕,这个R
        }];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.mas_centerX);
            make.centerY.equalTo(superView.mas_centerY).offset(+30+100);
            
            make.size.mas_equalTo(CGSizeMake(R(80), R(80)));//看我怎么适配屏幕,这个R
        }];
    }// TODO: test code
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
