//
//  NotificationNameDefine.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 12-10-31.
//  Copyright (c) 2012年 [OYXJlucky@163.com] . All rights reserved.
//  项目中公共的消息通知名称定义文件
//

#ifndef TemplatesProject_NotificationNameDefine_h
#define TemplatesProject_NotificationNameDefine_h


/**
 *  @attention 本开发框架中，能做到｀不用通知｀就尽量不用通知。
 *  @attention 本开发框架中，通知的使用特别注意：
 *
 *  @note 1、通知名不含UI，表示该通知由后台线程抛出，
                            一般是<网络层>请求完成之后，   同步地通知<逻辑层>把从服务器得来的数据保存到本地。
 *
 *  @note 2、通知名  含UI，表示该通知由 主线程抛出，
                            一般是<逻辑层>保存数据完成之后，同步地通知<界面层>更新UI 或 从本地取出之前保存的数据用来展示。
 *
 *  @note 3、通知名 的命名规范：
        #通知
        Notification的格式：类/头⽂文件名+进行状态+通知名称+Notification
        [Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
        如:
        1 NSApplicationDidBecomeActiveNotification
        2 NSWindowDidMiniaturizeNotification
        3 NSTextViewDidChangeSelectionNotification
        4 NSColorPanelColorDidChangeNotification
 *
 */


#pragma mark - 网络状态改变

//! 网络状态改变 (通知主线程 UI)
static NSString * const AppNetworkStatusDidChangeNotificationUI  =
                      @"AppNetworkStatusDidChangeNotificationUI" ;


#pragma mark - 账号相关 (能做到｀不用通知｀就尽量不用通知)

//! 帐号登出 界面层 通知 (通知主线程 UI)
static NSString * const AppDidLogoutAccountNotificationUI  =
                      @"AppDidLogoutAccountNotificationUI" ;

//! 帐号登入 逻辑层 通知 (通知其他线程 非UI)
static NSString * const AppDidLoginAccountNotification  =
                      @"AppDidLoginAccountNotification" ;
//! 帐号登入 界面层 通知 (通知主线程 UI)
static NSString * const AppDidLoginAccountNotificationUI  =
                      @"AppDidLoginAccountNotificationUI" ;

//! App Launch 之后，检查token；token有效  界面层 通知 (通知主线程 UI)
static NSString * const AppLaunchAndCheckTokenValidDidSuccessNotificationUI  =
                      @"AppLaunchAndCheckTokenValidDidSuccessNotificationUI" ;



#pragma mark - 功能相关 (能做到｀不用通知｀就尽量不用通知)

//! App下载国际化域名的请求成功，界面层 通知 (通知主线程 UI)
static NSString * const AppRealmNameRequestSuccessNotificationUI  =
                      @"AppRealmNameRequestSuccessNotificationUI" ;

//! App绑定设备的请求成功，界面层 通知 (通知主线程 UI)
static NSString * const AppBindDeviceRequestSuccessNotificationUI  =
                      @"AppBindDeviceRequestSuccessNotificationUI" ;



















#endif  ///< --------- TemplatesProject_NotificationNameDefine_h -------->///
