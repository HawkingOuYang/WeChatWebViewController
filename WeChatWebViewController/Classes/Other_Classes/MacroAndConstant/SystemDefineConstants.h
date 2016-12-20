//
//  SystemDefineConstants.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/6/18.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//  常量宏

#ifndef TemplatesProject_SystemDefineConstants_h
#define TemplatesProject_SystemDefineConstants_h




//--- 颜色 ---//
// 系统色
#define SystemRed                [UIColor colorWithHexColorString:@"0xff717f"]
#define SystemGreen              [UIColor colorWithHexColorString:@"0x52cd9e"]
#define SystemDeepGreen          [UIColor colorWithHexColorString:@"0x42a47e"]
#define SystemBlue               [UIColor colorWithHexColorString:@"0x38bbcc"]
#define SystemGray               [UIColor colorWithHexColorString:@"0xcccccc"]
#define SystemBackGroundGray     [UIColor colorWithHexColorString:@"0xF9F9F9"]
// 辅助色
#define SystemLightGreen         [UIColor colorWithHexColorString:@"0x71f4c1"]
#define SystemDeepRed            [UIColor colorWithHexColorString:@"0xf93f52"]
#define SystemPressedRed         [UIColor colorWithHexColorString:@"0xcc5a66"]
#define SystemOrange             [UIColor colorWithHexColorString:@"0xfe8d2e"]
#define SystemYellow             [UIColor colorWithHexColorString:@"0xfc8d3c"]
#define SystemSkyBlue            [UIColor colorWithHexColorString:@"0x12cbdc"]
// 细线颜色（细线高度为1px）
#define SystemLineColorOnGrayBg  [UIColor colorWithHexColorString:@"0x000000" alpha:0.08]
#define SystemLineColorOnWhiteBg [UIColor colorWithHexColorString:@"0x000000" alpha:0.10]


//--- 获得16进制颜色 ---//
#define UIColorFromRGB(rgbValue)    \
            [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
                            green: ((float)((rgbValue & 0xFF00) >> 8))/255.0      \
                             blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//--- 图片 ---//
#define HTmImage(imageName)      [UIImage imageNamed:imageName]









#endif //--- TemplatesProject_SystemDefineConstants_h ---//
