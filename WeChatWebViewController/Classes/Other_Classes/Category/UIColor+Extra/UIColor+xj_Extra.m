//
//  UIColor+Extra.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 14-5-30.
//  Copyright (c) 2014年 [OYXJlucky@163.com] . All rights reserved.
//

#import "UIColor+xj_Extra.h"

@implementation UIColor (xj_Hex)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue
{
    return [UIColor colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue
{
    return [UIColor colorWithHex:0x000000 alpha:alphaValue];
}


+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]] scanHexInt:&red];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]] scanHexInt:&green];
    range.location = 6;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexColorString:(NSString *)hexColor alpha:(CGFloat)alpha
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 6;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}



@end
