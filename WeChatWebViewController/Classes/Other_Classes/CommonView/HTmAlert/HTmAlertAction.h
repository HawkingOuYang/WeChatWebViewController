//
//  HTmAlertAction.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/4/10.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTmAlertAction;//当前类


NS_ASSUME_NONNULL_BEGIN


#pragma mark - type
/**
 *  回调的block定义
 *
 *  @note   请在该block中使用参数action，而不是捕获之前创建的action实例 --- 这样可以避免retain-cycle(即strong reference cycle)。
 *  @param  action  HTmAlertAction实例
 */
typedef void(^HTmAlertActionHandler)(HTmAlertAction *action);

#pragma mark - class
/*! @brief  弹窗的action， 封装了title 和 对应的block。
 *  @author OuYangXiaoJin
 */
@interface HTmAlertAction : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (copy, readonly, nullable) HTmAlertActionHandler handler;

/**
 *  弹窗的action
 *
 *  @param title   弹窗选项的title，比如 “取消”、“确定”。
 *  @param handler 点击弹窗的title，执行该block。
 *
 *  @note 请在该block中使用参数action，而不是捕获之前创建的action实例 --- 这样可以避免retain-cycle(即strong reference cycle)。
 *
 *  @return 实例
 */
+ (instancetype)actionWithTitle:(NSString *)title
                        handler:(_Nullable HTmAlertActionHandler)handler;

@end


NS_ASSUME_NONNULL_END
