//
//  BaseViewController.h
//  GestureSDK_Demo
//
//  Created by HawkingOuYang.com on 15/8/9.
//  Copyright (c) 2015年 OYXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    CGRect  m_mainContentViewFrame;
}

/**
 *  显示导航栏左侧的按钮
 */
- (void)showCustomNavigationLeftButtonWithTitle:(NSString *)aTitle
                                          image:(UIImage *)aImage
                                hightlightImage:(UIImage *)hImage;

/**
 判断是否是模态出视图
 */
- (BOOL)isModal;

@end
