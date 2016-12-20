//
//  SystemDefineSysVersion.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/6/16.
//  Copyright (c) 2015年 [OYXJlucky@163.com]  . All rights reserved.
//  当前设备的系统版本号

#ifndef TemplatesProject_SystemDefineSysVersion_h
#define TemplatesProject_SystemDefineSysVersion_h

/**
 *  运行时，检测当前设备的系统版本号。
 *  比如：这个app是在iPhone或iPad的iOS8.0系统上运行。
 *
 *  System Versioning Preprocessor Macros
 *  source: http://stackoverflow.com/questions/3339722/how-to-check-ios-version
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*

 Usage
 
if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
    ...
}

if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
    ...
}
 */






#endif //--- TemplatesProject_SystemDefineSysVersion_h ---//






// <------------------------------ 知识点（begin） ------------------------------> //


/**
 Apple's SDK Compatibility Guide
 https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/cross_development/Introduction/Introduction.html
 */


/**
 __IPHONE_7_0   __IPHONE_8_3 等等
 __IPHONE_OS_VERSION_MIN_REQUIRED
 __IPHONE_OS_VERSION_MAX_ALLOWED
 Deployment target
 SDK version
 iPhone操作系统版本
 这些之间的关系。
 http://stackoverflow.com/questions/3269344/what-is-difference-between-these-2-macros/3269562#3269562
 */


/**
 How to #define based on iOS version?
 http://stackoverflow.com/questions/17846544/how-to-define-based-on-ios-version
 */


/**
 代码 兼容  SDK 和 手机操作系统版本，宏的使用。
 http://stackoverflow.com/questions/19789958/xcode-preprocessor-macro-to-check-if-base-sdk-ios-7-0
 */


/*
 What are the common use cases for __IPHONE_OS_VERSION_MAX_ALLOWED?
 http://stackoverflow.com/questions/7542480/what-are-the-common-use-cases-for-iphone-os-version-max-allowed
 */



// <------------------------------ 知识点（end） ------------------------------> //



