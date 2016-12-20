//
//  PlatformUtil.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 16/03/28.
//  Copyright (c) 2016年 [OYXJlucky@163.com] . All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - define
/**
 *  宏定义 坐标缩放
 *  @attention 一定不能在其它地方，重新宏定义R(x)，使得当前的宏定义失效。
 *
 *  @param x 坐标值
 *
 *  @return 缩放之后的坐标值
 */
#define R(x)                (([PlatformUtil screenScaleForRetina])*(x))

/**
 3.5寸屏幕
 */
#define isScreen3_5Inch     ([PlatformUtil is_CurrentDevice_Screen3_5Inch])

/**
 4寸屏幕
 */
#define isScreen4Inch       ([PlatformUtil is_CurrentDevice_Screen_4Inch])

/**
 4.7寸屏幕
 */
#define isScreen4_7Inch     ([PlatformUtil is_CurrentDevice_Screen4_7Inch])

/**
 5.5寸屏幕
 */
#define isScreen5_5Inch     ([PlatformUtil is_CurrentDevice_Screen5_5Inch])




#pragma mark - class
/*! @brief 设备平台 工具类
 *  @note 这个类名，用在了宏定义中，所以 一定不能 此类名。
 *  @author OuYangXiaoJin 2016.03.28
 */
@interface PlatformUtil : NSObject

/*! @brief 根据屏幕宽度比例；按比例缩放坐标。
 *  @attention 一定要在AppLaunch的时候，初始化任何UI之前，调用此方法。
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 *
 *  @return 坐标的缩放比例
 */
+ (float)screenScaleForRetina;


/**
 *  3.5寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen3_5Inch;

/**
 *  4寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen_4Inch;

/**
 *  4.7寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen4_7Inch;

/**
 *  5.5寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen5_5Inch;



/**
 App是否 安装之后第一次运行
 */
+ (BOOL)isApplicationFirstNewSetupRun;

/**
 检测机型
 */
+ (NSString *)platformString;

/**
 获取 设备信息 以及 应用程序信息
 */
+ (NSDictionary *)platformAndAppInfoDictionary;


/**
 *  输入版本号 例如1.1.1  返回 10101 五位数的版本号
 *
 *  @param version 本地的版本号
 *
 *  @return 5位数的版本号
 */
+ (NSUInteger)intergerVersionWithVersionString:(NSString*)version;



@end
