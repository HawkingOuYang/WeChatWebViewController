//
//  NSMutableDictionary+Extra.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 14-5-30.
//  Copyright (c) 2014年 [OYXJlucky@163.com] . All rights reserved.
//

#import "NSMutableDictionary+xj_Extra.h"


@implementation NSMutableDictionary (xj_Extra)

/**
 插入的值为nil或者key为nil时不做操作
 */
- (void)setObjectExtra:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(anObject && ![anObject isKindOfClass:[NSNull class]] && aKey)
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end

