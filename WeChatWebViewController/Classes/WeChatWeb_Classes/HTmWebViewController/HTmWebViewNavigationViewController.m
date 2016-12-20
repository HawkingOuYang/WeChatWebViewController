//
//  HTmWebViewNavigationViewController.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/10/23.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//

#import "HTmWebViewNavigationViewController.h"
#import "HTmWebViewController.h"


///<--- [begin] 仿微信：`右滑手势`webview返回 --->///
// 参考： https://github.com/Roxasora/RxWebViewController
// 感谢： Roxasora（青年李大猫）
///<--- [end] 仿微信：`右滑手势`webview返回 --->///


@interface HTmWebViewNavigationViewController ()<UINavigationBarDelegate>

/**
 *  由于 popViewController 会触发 shouldPopItems，因此用该布尔值记录是否应该正确 popItems
 */
@property BOOL shouldPopItemAfterPopViewController;

@end

@implementation HTmWebViewNavigationViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPopItemAfterPopViewController = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popViewControllerAnimated:animated];
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popToViewController:viewController animated:animated];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popToRootViewControllerAnimated:animated];
}


#pragma mark - <UINavigationBarDelegate>
-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    
    //! 如果应该pop，说明是在 popViewController 之后，应该直接 popItems
    if (self.shouldPopItemAfterPopViewController) {
        self.shouldPopItemAfterPopViewController = NO;
        return YES;
    }
    
    //! 如果不应该 pop，说明是点击了导航栏的返回，这时候则要做出判断区分是不是在 webview 中
    if ([self.topViewController isKindOfClass:[HTmWebViewController class]]) {
        HTmWebViewController* webVC = (HTmWebViewController*)self.viewControllers.lastObject;
        if (webVC.webView.canGoBack) {
            [webVC.webView goBack];
            
            //!make sure the back indicator view alpha back to 1
            self.shouldPopItemAfterPopViewController = NO;
            [[self.navigationBar subviews] lastObject].alpha = 1;
            return NO;
        }else{
            [self popViewControllerAnimated:YES];
            return NO;
        }
    }else{
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

@end
