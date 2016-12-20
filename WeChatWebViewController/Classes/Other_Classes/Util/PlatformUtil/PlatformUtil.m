//
//  PlatformUtil.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 16/03/28.
//  Copyright (c) 2016年 [OYXJlucky@163.com] . All rights reserved.
//

#import <sys/types.h>
#import <sys/sysctl.h>

#import "PlatformUtil.h"



@implementation PlatformUtil



/*! @brief 根据屏幕宽度比例；按比例缩放坐标。
 *  @attention 一定要在AppLaunch的时候，初始化任何UI之前，调用此方法。
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 *
 *  @return 坐标的缩放比例
 */
+ (float)screenScaleForRetina
{
    /*
     因为 此宏定义，可能影响 UI绘制性能，
     所以 改用 static变量，
     详见 PlatformUtil这个类， #define R(x)  ([PlatformUtil screenScaleForRetina])*(x)
     //----- 根据屏幕宽度比例；按比例缩放坐标 --- begin -----//
     // 使用示范：R(20)
     // 含义：R 指 针对Retina进行缩放坐标； 20 指 坐标值。
     //----- 屏幕宽度，考虑到 屏幕旋转 -----//
     #define Rx_min_SCREEN_WIDTH        MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
     //----- 根据屏幕宽度比例；按比例缩放坐标 -----//
     #define Rx_SCREEN_SCALE        (Rx_min_SCREEN_WIDTH)>320?Rx_min_SCREEN_WIDTH/320.f:1.f
     #define R(x)  (Rx_SCREEN_SCALE)*(x)
     //----- 根据屏幕宽度比例；按比例缩放坐标 --- end -----//
     */
    
    static float THE_SCREEN_SCALE_FOR_RETINA = 1.f;//默认，不缩放坐标
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // 屏幕 宽度
        CGFloat minScreenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//考虑到 屏幕旋转
        
        // 屏幕 宽度比例
        THE_SCREEN_SCALE_FOR_RETINA = (minScreenWidth>320)?(minScreenWidth/320.f):1.f;
    });//<---- dispatch_once END ---->//
    
    return THE_SCREEN_SCALE_FOR_RETINA;
}


/**
 *  3.5寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen3_5Inch
{
    static BOOL isBOOL_Screen3_5Inch = NO;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        isBOOL_Screen3_5Inch = ([UIScreen instancesRespondToSelector:@selector(currentMode)]
                                ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)
                                : NO);
    });//<---- dispatch_once END ---->//
    
    return isBOOL_Screen3_5Inch;
}

/**
 *  4寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen_4Inch
{
    static BOOL isBOOL_Screen_4Inch = NO;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        isBOOL_Screen_4Inch = ([UIScreen instancesRespondToSelector:@selector(currentMode)]
                               ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
                               : NO);
    });//<---- dispatch_once END ---->//
    
    return isBOOL_Screen_4Inch;
}

/**
 *  4.7寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen4_7Inch
{
    static BOOL isBOOL_Screen4_7Inch = NO;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        isBOOL_Screen4_7Inch = ([UIScreen instancesRespondToSelector:@selector(currentMode)]
                                ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)
                                : NO);
    });//<---- dispatch_once END ---->//
    
    return isBOOL_Screen4_7Inch;
}

/**
 *  5.5寸屏幕
 *  @note 这个方法，用在了宏定义中，所以 一定不能改变此方法签名。
 */
+ (BOOL)is_CurrentDevice_Screen5_5Inch
{
    static BOOL isBOOL_Screen5_5Inch = NO;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        isBOOL_Screen5_5Inch = ([UIScreen instancesRespondToSelector:@selector(currentMode)]
                                ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)
                                : NO);
    });//<---- dispatch_once END ---->//
    
    return isBOOL_Screen5_5Inch;
}



/**
 App是否 安装之后第一次运行
 */
+ (BOOL)isApplicationFirstNewSetupRun
{
    //! App是否 安装之后第一次运行
    static NSNumber * isFirstRun = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        isFirstRun = [[NSUserDefaults standardUserDefaults]
                      valueForKey: @"Application is first new setup run"];
        if(isFirstRun==nil){
            isFirstRun = [NSNumber numberWithBool:YES];
        }
        [[NSUserDefaults standardUserDefaults] setValue: [NSNumber numberWithBool:NO]
                                                 forKey: @"Application is first new setup run"];
    });//<---- dispatch_once END ---->//
    
    
    return [isFirstRun boolValue];
}


/**
 检测机型
 */
+ (NSString *)platformString
{
    static NSString *thePlatformString = @"";
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        // Gets a string with the device model
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
        
        
        //platform == iPhone
             if ([platform isEqualToString:@"iPhone1,1"])    thePlatformString = @"iPhone 2G";
        else if ([platform isEqualToString:@"iPhone1,2"])    thePlatformString = @"iPhone 3G";
        else if ([platform isEqualToString:@"iPhone2,1"])    thePlatformString = @"iPhone 3GS";
        else if ([platform isEqualToString:@"iPhone3,1"])    thePlatformString = @"iPhone 4";
        else if ([platform isEqualToString:@"iPhone3,2"])    thePlatformString = @"iPhone 4";
        else if ([platform isEqualToString:@"iPhone3,3"])    thePlatformString = @"iPhone 4 (CDMA)";
        else if ([platform isEqualToString:@"iPhone4,1"])    thePlatformString = @"iPhone 4S";
        else if ([platform isEqualToString:@"iPhone5,1"])    thePlatformString = @"iPhone 5 (GSM)";
        else if ([platform isEqualToString:@"iPhone5,2"])    thePlatformString = @"iPhone 5 (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPhone5,3"])    thePlatformString = @"iPhone 5c (GSM)";
        else if ([platform isEqualToString:@"iPhone5,4"])    thePlatformString = @"iPhone 5c (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPhone6,1"])    thePlatformString = @"iPhone 5s (GSM)";
        else if ([platform isEqualToString:@"iPhone6,2"])    thePlatformString = @"iPhone 5s (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPhone7,1"])    thePlatformString = @"iPhone 6 Plus";
        else if ([platform isEqualToString:@"iPhone7,2"])    thePlatformString = @"iPhone 6";
        else if ([platform isEqualToString:@"iPhone8,1"])    thePlatformString = @"iPhone 6s";
        else if ([platform isEqualToString:@"iPhone8,2"])    thePlatformString = @"iPhone 6s Plus";
        else if ([platform isEqualToString:@"iPhone8,4"])    thePlatformString = @"iPhone SE";
        /** 这里，有待继续添加 iPhone **/
        
        
        //platform == ipod
        else if ([platform isEqualToString:@"iPod1,1"])      thePlatformString = @"iPod Touch (1 Gen)";
        else if ([platform isEqualToString:@"iPod2,1"])      thePlatformString = @"iPod Touch (2 Gen)";
        else if ([platform isEqualToString:@"iPod3,1"])      thePlatformString = @"iPod Touch (3 Gen)";
        else if ([platform isEqualToString:@"iPod4,1"])      thePlatformString = @"iPod Touch (4 Gen)";
        else if ([platform isEqualToString:@"iPod5,1"])      thePlatformString = @"iPod Touch (5 Gen)";
        else if ([platform isEqualToString:@"iPod6,1"])      thePlatformString = @"iPod Touch (6 Gen)";
        /** 这里，有待继续添加 iPod **/
        
        
        //platform == ipad
        else if ([platform isEqualToString:@"iPad1,1"])      thePlatformString = @"iPad 1";
        else if ([platform isEqualToString:@"iPad2,1"])      thePlatformString = @"iPad 2 (WiFi)";
        else if ([platform isEqualToString:@"iPad2,2"])      thePlatformString = @"iPad 2 (GSM)";
        else if ([platform isEqualToString:@"iPad2,3"])      thePlatformString = @"iPad 2 (CDMA)";
        else if ([platform isEqualToString:@"iPad2,4"])      thePlatformString = @"iPad 2 (WiFi)";
        else if ([platform isEqualToString:@"iPad2,5"])      thePlatformString = @"iPad Mini (WiFi)";
        else if ([platform isEqualToString:@"iPad2,6"])      thePlatformString = @"iPad Mini (GSM)";
        else if ([platform isEqualToString:@"iPad2,7"])      thePlatformString = @"iPad Mini (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPad3,1"])      thePlatformString = @"iPad 3 (WiFi)";
        else if ([platform isEqualToString:@"iPad3,2"])      thePlatformString = @"iPad 3 (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPad3,3"])      thePlatformString = @"iPad 3 (GSM)";
        else if ([platform isEqualToString:@"iPad3,4"])      thePlatformString = @"iPad 4 (WiFi)";
        else if ([platform isEqualToString:@"iPad3,5"])      thePlatformString = @"iPad 4 (GSM)";
        else if ([platform isEqualToString:@"iPad3,6"])      thePlatformString = @"iPad 4 (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPad4,1"])      thePlatformString = @"iPad Air (WiFi)";
        else if ([platform isEqualToString:@"iPad4,2"])      thePlatformString = @"iPad Air (Cellular)";
        else if ([platform isEqualToString:@"iPad4,3"])      thePlatformString = @"iPad Air (China)";
        else if ([platform isEqualToString:@"iPad4,4"])      thePlatformString = @"iPad mini 2G (WiFi)";
        else if ([platform isEqualToString:@"iPad4,5"])      thePlatformString = @"iPad mini 2G (Cellular)";
        else if ([platform isEqualToString:@"iPad4,6"])      thePlatformString = @"iPad mini 2G (China)";
        else if ([platform isEqualToString:@"iPad4,7"])      thePlatformString = @"iPad mini 3 (WiFi)";
        else if ([platform isEqualToString:@"iPad4,8"])      thePlatformString = @"iPad mini 3 (Cellular)";
        else if ([platform isEqualToString:@"iPad4,9"])      thePlatformString = @"iPad mini 3 (China Model)";
        else if ([platform isEqualToString:@"iPad5,1"])      thePlatformString = @"iPad mini 4 (WiFi)";
        else if ([platform isEqualToString:@"iPad5,2"])      thePlatformString = @"iPad mini 4 (Cellular)";
        else if ([platform isEqualToString:@"iPad5,3"])      thePlatformString = @"iPad Air 2 (WiFi)";
        else if ([platform isEqualToString:@"iPad5,4"])      thePlatformString = @"iPad Air 2 (Cellular)";
        else if ([platform isEqualToString:@"iPad6,3"])      thePlatformString = @"iPad Pro 9.7 (Wi-Fi)";
        else if ([platform isEqualToString:@"iPad6,4"])      thePlatformString = @"iPad Pro 9.7 (Cellular)";
        else if ([platform isEqualToString:@"iPad6,7"])      thePlatformString = @"iPad Pro 12.9 (Wi-Fi)";
        else if ([platform isEqualToString:@"iPad6,8"])      thePlatformString = @"iPad Pro 12.9 (Cellular)";
        /** 这里，有待继续添加 iPad **/
        

        //platform == Apple TV
        else if ([platform isEqualToString:@"AppleTV2,1"])   thePlatformString = @"Apple TV 2G";
        else if ([platform isEqualToString:@"AppleTV3,1"])   thePlatformString = @"Apple TV 3";
        else if ([platform isEqualToString:@"AppleTV3,2"])   thePlatformString = @"Apple TV 3 (2013)";
        else if ([platform isEqualToString:@"AppleTV5,3"])   thePlatformString = @"Apple TV 4";
        /** 这里，有待继续添加 Apple TV **/
        
        
        //platform == Apple Watch
        else if ([platform isEqualToString:@"Watch1,1"])     thePlatformString = @"Apple Watch 1G 38mm";
        else if ([platform isEqualToString:@"Watch1,2"])     thePlatformString = @"Apple Watch 1G 42mm";
        /** 这里，有待继续添加 Apple Watch **/
        
        
        //platform == simulator
        else if ([platform isEqualToString:@"i386"])         thePlatformString = @"Simulator";
        else if ([platform isEqualToString:@"x86_64"])       thePlatformString = @"Simulator";
        /** 这里，有待继续添加 Simulator **/
        
        
    }); //<---- dispatch_once END ---->//
    
    
    return  thePlatformString;
}


/**
 获取 设备信息 以及 应用程序信息
 */
+ (NSDictionary *)platformAndAppInfoDictionary
{
    //获得系统日期
    NSDate *todayDate =[NSDate date];
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];//24小时制
    NSString *strFromDate = [dateToStrFormatter stringFromDate:todayDate];
    
    
    static NSMutableDictionary *infoMutableDic = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        //获取设备信息及应用程序版本
        NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
        NSString *phoneModel = [PlatformUtil platformString];
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *appDisplayVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *appBuildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        
        //设备名称
        NSString *deviceName = [[UIDevice currentDevice] name];
        
        //构造参数
        /*
         NSString *sysInfoStr = [NSString stringWithFormat:@"<br/>手机型号:%@<br/>手机系统版本:%@<br/>设备名称:%@<br/>bundleID:%@<br/>应用名称:%@<br/>显示版本:%@<br/>构建版本:%@\n<br/>日期:%ld.%d.%d<br/>",  phoneModel,phoneVersion,deviceName,  bundleID,appName,appDisplayVersion,appBuildVersion,  (long)year,(int)month,(int)day];
         */
        NSString *sysInfoStr = [NSString stringWithFormat:@"手机型号:%@, 手机系统版本:%@, 设备名称:%@, bundleID:%@, 应用名称:%@, 显示版本:%@, 构建版本:%@, 日期:%@ ",  phoneModel,phoneVersion,deviceName,  bundleID,appName,appDisplayVersion,appBuildVersion,  strFromDate];
        

        //返回参数
        infoMutableDic       = [
                                @{ @"sysInfoStr"   :   sysInfoStr?:@""         ,
                                   @"bundleID"     :   bundleID?:@""           ,
                                   
                                   // 英文KEY，不要删除此KEY！
                                   @"phoneModel"           :   phoneModel?:@""         ,
                                   @"phoneVersion"         :   phoneVersion?:@""       ,
                                   @"deviceName"           :   deviceName?:@""         ,
                                   @"appName"              :   appName?:@""            ,
                                   @"appDisplayVersion"    :   appDisplayVersion?:@""  ,
                                   @"appBuildVersion"      :   appBuildVersion?:@""    ,
                                   @"date"                 :   strFromDate?:@""        ,
                                   
                                   // 中文KEY，不要删除此KEY！
                                   @"手机型号"      :   phoneModel?:@""         ,
                                   @"手机系统版本"   :   phoneVersion?:@""       ,
                                   @"设备名称"      :   deviceName?:@""         ,
                                   @"应用名称"      :   appName?:@""            ,
                                   @"显示版本"      :   appDisplayVersion?:@""  ,
                                   @"构建版本"      :   appBuildVersion?:@""    ,
                                   @"日期"         :   strFromDate?:@""
                                   
                                   }
                                mutableCopy];
    }); //<---- dispatch_once END ---->//
    
    
    {//<--- 更新日期 begin --->//
        NSString *now_sysInfoStr = [[infoMutableDic objectForKey:@"sysInfoStr"] copy];
        NSRange range = [now_sysInfoStr rangeOfString:@"日期"
                                              options:NSLiteralSearch|NSBackwardsSearch
                                                range:NSMakeRange(0, now_sysInfoStr.length)];
        if (range.location != NSNotFound) {
            now_sysInfoStr = [[now_sysInfoStr stringByReplacingCharactersInRange:
                              NSMakeRange(range.location+range.length, now_sysInfoStr.length-range.location-range.length)
                                                                     withString:strFromDate]
                              copy];
            [infoMutableDic setObject:[now_sysInfoStr?:@"" copy] forKey:@"sysInfoStr"];
        }
        
        [infoMutableDic setObject:[strFromDate?:@"" copy] forKey:@"日期"];
        
        [infoMutableDic setObject:[strFromDate?:@"" copy] forKey:@"date"];
    }//<--- 更新日期 end --->//
    
    
    return infoMutableDic;
}


/**
 *  输入版本号 例如1.1.1  返回 10101 五位数的版本号
 *
 *  @param version 本地的版本号
 *
 *  @return 5位数的版本号
 */
+ ( NSUInteger)intergerVersionWithVersionString:(NSString *)version
{
    NSArray * versionArray = [version componentsSeparatedByString:@"."];
    if (versionArray.count<3) {
        return 0; /* 避免 崩溃 */
    }
    
    NSString *localFirst  = versionArray[0];
    NSString *localSecond = versionArray[1];
    NSString  *localThird = versionArray[2];
    
    NSUInteger localFirstInteger = [localFirst integerValue];
    NSUInteger localSecondInteger = [localSecond integerValue];
    NSUInteger localThirdInteger = [localThird integerValue];
    
    NSUInteger localVersionInteger = localFirstInteger *10000 + localSecondInteger *100 + localThirdInteger;
    
    return localVersionInteger;
}


@end





// <------------------------------ 知识点（begin） ------------------------------> //

/**
 Determine device (iPhone, iPod Touch) with iPhone SDK
 http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
 */




// <------------------------------ 知识点（end） ------------------------------> //
