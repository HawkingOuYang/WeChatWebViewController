//
//  HTmAlert.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/4/15.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTmAlertAction.h"//弹窗的action， 封装了title 和 对应的block


NS_ASSUME_NONNULL_BEGIN


#pragma mark - class
/*! @brief  封装了 UIAlertView 和 UIAlertController，目的在于兼容地过渡iOS8。
 *  @author OuYangXiaoJin
 */
@interface HTmAlert : NSObject

/**
 *  初始化类方法
 *
 *  @param title   标题
 *  @param message 内容
 *
 *  @return 实例
 */
+ (instancetype)alertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;

/**
 *  添加事件
 *
 *  @param action 事件
 */
- (void)addActions:(HTmAlertAction *)action;


/**
 *  显示alert
 */
- (void)show;

/**
 *  代码控制 使得弹窗消失
 *  @note 注意：该方法 不调用按钮对应的SEL。
 *
 *  @param buttonIndex 按钮的index，从0算起。
 *  @param animated    动画
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;


@end


NS_ASSUME_NONNULL_END
