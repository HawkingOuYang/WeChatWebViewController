//
//  CNavigationController.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/7/28.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import "CNavigationController.h"


/**
 自定义导航栏控制器
 */
@interface CNavigationController ()<UIGestureRecognizerDelegate>
@end


@implementation CNavigationController


#pragma mark - life cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:SystemGreen]
                                forBarPosition:UIBarPositionTop
                                    barMetrics:UIBarMetricsDefault];
    }
    else if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:SystemGreen]
                                 forBarMetrics:UIBarMetricsDefault];
    }
    
    
    /**
     iOS7的手势滑动返回功能
     */
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    

}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // Ignore interactive pop gesture when there is only one view controller on the navigation stack
    if (self.viewControllers.count == 1)
    {
        return false;
    }
    else
    {
        return true;
    }
    
}




#pragma mark - override
/**
 重写父类UINavigationController的方法pushViewController。
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /**
     从
     根页面(即 rootViewController)
     push进入 
     navigationController的二级页面(即 非rootViewController)，
     不显示 底部标签栏。
     */
    if (self.viewControllers.count == 1)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
