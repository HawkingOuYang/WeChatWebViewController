//
//  HTmReachabilityManager.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/4/20.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import <Foundation/Foundation.h>


/*! @brief  对reachability的简单封装
 *  @author OuYangXiaoJin
 */
@interface HTmReachabilityManager : NSObject


+ (instancetype _Nonnull)sharedManager;

+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

//! 返回字符串，这些之一： @"Unreachable"  @"WWAN"  @"WiFi"  @"unknow"
+ (NSString*_Nonnull)currentNetwork;

@end
